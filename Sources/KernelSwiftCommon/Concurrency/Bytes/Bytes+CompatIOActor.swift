//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 11/11/2023.
//

#if canImport(Darwin) && compiler(>=5.10)
private import Darwin
#elseif canImport(Darwin)
@_implementationOnly import Darwin
#elseif canImport(Glibc) && compiler(>=5.10)
private import Glibc
#elseif canImport(Glibc)
@_implementationOnly import Glibc
#elseif canImport(CRT) && compiler(>=5.10)
private import CRT
#elseif canImport(CRT)
@_implementationOnly import CRT
#endif

import Foundation

extension KernelSwiftCommon.Concurrency.Bytes {
    final actor CompatIOActor {
        static let `default` = CompatIOActor()
        
        nonisolated func read(from fd: Int32, into buffer: UnsafeMutableRawBufferPointer) async throws -> Int {
            while true {
                #if canImport(Darwin)
                let read = Darwin.read
                #elseif canImport(Glibc)
                let read = Glibc.read
                #elseif canImport(CRT)
                let read = CRT.read
                #endif
                let amount = read(fd, buffer.baseAddress, buffer.count)
                if amount >= .zero { return amount }
                let posixErrno = errno
                if errno != EINTR { throw NSError(domain: NSPOSIXErrorDomain, code: .init(posixErrno), userInfo: [:])}
            }
        }
        
        nonisolated func read(from handle: FileHandle, into buffer: UnsafeMutableRawBufferPointer) async throws -> Int {
            guard let data = try handle.read(upToCount: buffer.count) else { return 0 }
            data.copyBytes(to: buffer)
            return data.count
        }
        
        func createFileHandler(reading url: URL) async throws -> FileHandle { try .init(forReadingFrom: url) }
    }
}

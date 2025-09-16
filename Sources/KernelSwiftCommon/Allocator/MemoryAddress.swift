//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 25/06/2023.
//
//TODO check

//import KernelCShims
import Logging

public enum KernelAllocator: FeatureLoggable {
//    public static let logger = makeLogger()
}

extension KernelAllocator {
    public struct MemoryAddress<T: AnyObject>: CustomStringConvertible {
        public let rawInt: Int
        
        public var description: String {
            let len = 2 + 2 * MemoryLayout<UnsafeRawPointer>.size
            return String(format: "%0\(len)p", rawInt)
        }
        
        public init(for referenceType: T) {
            rawInt = Int(bitPattern: Unmanaged<T>.passUnretained(referenceType).toOpaque())
        }
    }
    
    public static func printAddress<T: AnyObject>(for referenceType: T) {
        let addressRaw = MemoryAddress(for: referenceType)
        logger.debug("[\(typeName(T.self))]:\(addressRaw.description)")
        
    }
    
    public static func printAddress<T>(forVal objectType: borrowing T) {
        withUnsafePointer(to: objectType) { ptr in
            logger.debug("[\(typeName(T.self))]:\(String(format: "%018p", Int(bitPattern: ptr)))")
        }
    }
}

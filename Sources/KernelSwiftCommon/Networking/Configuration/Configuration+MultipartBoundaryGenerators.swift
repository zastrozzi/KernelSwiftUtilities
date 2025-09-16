//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 27/03/2025.
//

import Foundation

@_documentation(visibility: private)
public protocol _KernelNetworking_Configuration_MultipartBoundaryGenerator: Sendable {
    func makeBoundary() -> String
}

extension KernelNetworking.Configuration {
    public typealias MultipartBoundaryGenerator = _KernelNetworking_Configuration_MultipartBoundaryGenerator
}

extension KernelNetworking.Configuration.MultipartBoundaryGenerator where Self == KernelNetworking.Configuration.ConstantMultipartBoundaryGenerator {
    
    public static var constant: Self { .init() }
}

extension KernelNetworking.Configuration.MultipartBoundaryGenerator where Self == KernelNetworking.Configuration.RandomMultipartBoundaryGenerator {
    
    public static var random: Self { .init() }
}

extension KernelNetworking.Configuration {
    public struct ConstantMultipartBoundaryGenerator: MultipartBoundaryGenerator {
        public let boundary: String
        
        public init(boundary: String = "__X_KERNEL_NETWORKING_BOUNDARY__") { self.boundary = boundary }
        
        public func makeBoundary() -> String { boundary }
    }
}

extension KernelNetworking.Configuration {
    public struct RandomMultipartBoundaryGenerator: MultipartBoundaryGenerator {
        public let boundaryPrefix: String
        public let randomNumberSuffixLength: Int
        private let values: [UInt8] = Array("0123456789".utf8)
        
        public init(
            boundaryPrefix: String = "__X_KERNEL_NETWORKING_",
            randomNumberSuffixLength: Int = 20
        ) {
            self.boundaryPrefix = boundaryPrefix
            self.randomNumberSuffixLength = randomNumberSuffixLength
        }
        
        public func makeBoundary() -> String {
            var randomSuffix = [UInt8](repeating: 0, count: randomNumberSuffixLength)
            for i in randomSuffix.startIndex..<randomSuffix.endIndex { randomSuffix[i] = values.randomElement()! }
            return boundaryPrefix.appending(String(decoding: randomSuffix, as: UTF8.self))
        }
    }
}

//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 06/09/2023.
//

import Foundation
import Algorithms

public protocol _KernelSwiftCommonErrorTypes: RawRepresentableAsString {
    var httpStatus: KernelNetworking.HTTP.ResponseStatus { get }
    var httpReason: String { get }
}

extension _KernelSwiftCommonErrorTypes {
    public var httpStatus: KernelNetworking.HTTP.ResponseStatus { .badRequest }
    public var httpReason: String { "" }
}

extension KernelSwiftCommon {
    public typealias ErrorTypes = _KernelSwiftCommonErrorTypes
    
    public struct TypedError<WrappedError: KernelSwiftCommon.ErrorTypes>: Error, CustomDebugStringConvertible, LocalizedError, Sendable {
        public var value: WrappedError
        public var httpStatus: KernelNetworking.HTTP.ResponseStatus
        public var httpReason: String
        public var arguments: [Any & Sendable]
        
        public var errorDescription: String? {
            #if DEBUG
            debugDescription
            #else
            httpReason
            #endif
        }
        
        public var debugDescription: String {
            printablePrimaryLine + printableArguments
        }
        
        public init(_ value: WrappedError, httpStatus: KernelNetworking.HTTP.ResponseStatus? = nil, reason: String? = nil, arguments: [Any & Sendable] = []) {
            self.value = value
            self.httpReason = reason ?? value.httpReason
            self.httpStatus = httpStatus ?? value.httpStatus
            self.arguments = arguments
        }
        
        internal var printablePrimaryLine: String {
            "[\(httpStatus.rawValue) | \(value.rawValue)] Reason: \(httpReason)"
        }
        
        internal var printableArguments: String {
            if arguments.isEmpty { "" }
            else {
                .tabbedNewLine() + "Properties:" +
                arguments.indexed().map {
                    .tabbedNewLine() + "[\($0)] " + String(describing: $1)
                }.joined()
            }
        }
    }
}

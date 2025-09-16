//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 27/03/2025.
//

import Foundation

@_documentation(visibility: private)
public protocol _KernelNetworking_Configuration_CustomCoder: Sendable {
    
    func customEncode<T: Encodable>(_ value: T) throws -> Data
    
    func customDecode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

extension KernelNetworking.Configuration {
    public typealias CustomCoder = _KernelNetworking_Configuration_CustomCoder
}

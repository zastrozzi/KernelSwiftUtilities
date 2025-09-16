//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 09/07/2023.
//
import Vapor

public protocol ASN1StringRepresentable: CustomStringConvertible {
    var string: String { get }
}

extension ASN1StringRepresentable {
    public var description: String {
        get { "\(type(of: self)) \(self.string)"}
    }
    
    public func descriptionWithMeta(_ metaString: String) -> String {
        "\(type(of: self)) \(metaString) \(self.string)"
    }
}

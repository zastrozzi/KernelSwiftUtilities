//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 06/09/2023.
//

import Foundation

public protocol RawRepresentableAsString: Codable, Equatable, CaseIterable, RawRepresentable, Sendable where RawValue == String {}
public protocol RawRepresentableAsInt: RawRepresentable, Sendable where Self.RawValue == Int {}

extension RawRepresentableAsString {
    public init?(rawValue: String) {
        if let found = Self.allCases.first(where: { $0.rawValue == rawValue }) {
            self = found
        } else {
            return nil
        }
    }
    
//    public var rawValue: String { "\(self)" }
}

//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 13/09/2024.
//

import Foundation

public protocol FixedWidthIntegerStringRepresentable<T>: Codable {
    associatedtype T: FixedWidthInteger
}

//extension FixedWidthIntegerStringRepresentable {
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        let rawString = try container.decode(String.self)
//        guard let value = T(rawString, radix: 10) else {
//            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot initialize \(Self.self) from invalid String value \(rawString)")
//        }
//        self = value
//    }
//}

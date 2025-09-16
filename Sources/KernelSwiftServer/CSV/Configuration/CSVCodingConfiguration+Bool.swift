//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 13/05/2023.
//

import Foundation
import Vapor
import Collections

extension KernelCSV.CSVCodingConfiguration {
    public enum BoolCodingStrategy: String, Codable, Equatable, CaseIterable, OpenAPIStringEnumSampleable, Sendable {
        case integer = "integer"
        case string = "string"
        case fuzzy = "fuzzy"
        
        public static let defaultStrategy: BoolCodingStrategy = .string
        
        public func bytes(from boolValue: Bool) -> [UInt8] {
            switch self {
            case .fuzzy, .string: return boolValue ? [.ascii.t, .ascii.r, .ascii.u, .ascii.e] : [.ascii.f, .ascii.a, .ascii.l, .ascii.s, .ascii.e]
            case .integer: return boolValue ? [.ascii.one] : [.ascii.zero]
            }
        }
        
        public func decodeBool(from bytes: Deque<UInt8>) throws -> Bool {
            switch (self, bytes) {
            case (.integer, [.ascii.one]): return true
            case (.integer, [.ascii.zero]): return false
            case (.string, [.ascii.t, .ascii.r, .ascii.u, .ascii.e]): return true
            case (.string, [.ascii.T, .ascii.R, .ascii.U, .ascii.E]): return true
            case (.string, [.ascii.f, .ascii.a, .ascii.l, .ascii.s, .ascii.e]): return false
            case (.string, [.ascii.F, .ascii.A, .ascii.L, .ascii.S, .ascii.E]): return false
            case (.fuzzy, _):
                switch String(utf8EncodedBytes: bytes).lowercased() {
                case "true", "yes", "t", "y", "1": return true
                case "false", "no", "f", "n", "0": return false
                default: throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Could not decode Bool from CSV bytes '\(bytes)' using fuzzy strategy"))
                }
            default: throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Could not decode Bool from CSV bytes '\(bytes)' using \(self.rawValue) strategy"))
            }
        }
    }
}

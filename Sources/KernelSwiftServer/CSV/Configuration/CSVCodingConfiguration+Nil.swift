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
    public enum NilCodingStrategy: String, Codable, Equatable, Hashable, CaseIterable, OpenAPIStringEnumSampleable, Sendable {
        case blank = "blank"
        case empty = "empty"
        case na = "na"
        case `nil` = "nil"
        case none = "none"
        case null = "null"
        case void = "void"
        
        public static let defaultStrategy: NilCodingStrategy = .blank
        
        public func bytes() -> [UInt8] {
            switch self {
            case .blank:    []
            case .empty:    [.ascii.E, .ascii.M, .ascii.P, .ascii.T, .ascii.Y]
            case .na:       [.ascii.N, .ascii.forwardSlash, .ascii.A]
            case .nil:      [.ascii.N, .ascii.I, .ascii.L]
            case .none:     [.ascii.N, .ascii.O, .ascii.N, .ascii.E]
            case .null:     [.ascii.N, .ascii.U, .ascii.L, .ascii.L]
            case .void:     [.ascii.V, .ascii.O, .ascii.I, .ascii.D]
            }
        }
        
        public func decodeNil<V>(for: V.Type, from bytes: Deque<UInt8>) throws -> Optional<V> {
            switch (self, bytes) {
            case (.blank,   []):                                                    .none
            case (.empty,   [.ascii.E, .ascii.M, .ascii.P, .ascii.T, .ascii.Y]):    .none
            case (.empty,   [.ascii.e, .ascii.m, .ascii.p, .ascii.t, .ascii.y]):    .none
            case (.na,      [.ascii.N, .ascii.forwardSlash, .ascii.A]):             .none
            case (.na,      [.ascii.n, .ascii.forwardSlash, .ascii.a]):             .none
            case (.nil,     [.ascii.N, .ascii.I, .ascii.L]):                        .none
            case (.nil,     [.ascii.n, .ascii.i, .ascii.l]):                        .none
            case (.none,    [.ascii.N, .ascii.O, .ascii.N, .ascii.E]):              .none
            case (.none,    [.ascii.n, .ascii.o, .ascii.n, .ascii.e]):              .none
            case (.null,    [.ascii.N, .ascii.U, .ascii.L, .ascii.L]):              .none
            case (.null,    [.ascii.n, .ascii.u, .ascii.l, .ascii.l]):              .none
            case (.void,    [.ascii.V, .ascii.O, .ascii.I, .ascii.D]):              .none
            case (.void,    [.ascii.v, .ascii.o, .ascii.i, .ascii.d]):              .none
            default: throw DecodingError.dataCorrupted(
                    .init(
                        codingPath: [],
                        debugDescription: "Could not decode optional value for \(Optional<V>.self) from CSV bytes '\(bytes)'"
                    )
                )
            }
            
        }
        
        public func decodeNil(from bytes: Deque<UInt8>) throws -> Optional<Any> {
            switch (self, bytes) {
            case (.blank,   []):                                                    .none
            case (.empty,   [.ascii.E, .ascii.M, .ascii.P, .ascii.T, .ascii.Y]):    .none
            case (.empty,   [.ascii.e, .ascii.m, .ascii.p, .ascii.t, .ascii.y]):    .none
            case (.na,      [.ascii.N, .ascii.forwardSlash, .ascii.A]):             .none
            case (.na,      [.ascii.n, .ascii.forwardSlash, .ascii.a]):             .none
            case (.nil,     [.ascii.N, .ascii.I, .ascii.L]):                        .none
            case (.nil,     [.ascii.n, .ascii.i, .ascii.l]):                        .none
            case (.none,    [.ascii.N, .ascii.O, .ascii.N, .ascii.E]):              .none
            case (.none,    [.ascii.n, .ascii.o, .ascii.n, .ascii.e]):              .none
            case (.null,    [.ascii.N, .ascii.U, .ascii.L, .ascii.L]):              .none
            case (.null,    [.ascii.n, .ascii.u, .ascii.l, .ascii.l]):              .none
            case (.void,    [.ascii.V, .ascii.O, .ascii.I, .ascii.D]):              .none
            case (.void,    [.ascii.v, .ascii.o, .ascii.i, .ascii.d]):              .none
            default: throw DecodingError.dataCorrupted(
                    .init(
                        codingPath: [],
                        debugDescription: "Could not decode optional value for Any from CSV bytes '\(bytes)'"
                    )
                )
            }
            
        }
        
        public func decodeNilLiteral<V: ExpressibleByNilLiteral>(from bytes: Deque<UInt8>) throws -> V {
            switch (self, bytes) {
            case (.blank,   []):                                                    nil
            case (.empty,   [.ascii.E, .ascii.M, .ascii.P, .ascii.T, .ascii.Y]):    nil
            case (.empty,   [.ascii.e, .ascii.m, .ascii.p, .ascii.t, .ascii.y]):    nil
            case (.na,      [.ascii.N, .ascii.forwardSlash, .ascii.A]):             nil
            case (.na,      [.ascii.n, .ascii.forwardSlash, .ascii.a]):             nil
            case (.nil,     [.ascii.N, .ascii.I, .ascii.L]):                        nil
            case (.nil,     [.ascii.n, .ascii.i, .ascii.l]):                        nil
            case (.none,    [.ascii.N, .ascii.O, .ascii.N, .ascii.E]):              nil
            case (.none,    [.ascii.n, .ascii.o, .ascii.n, .ascii.e]):              nil
            case (.null,    [.ascii.N, .ascii.U, .ascii.L, .ascii.L]):              nil
            case (.null,    [.ascii.n, .ascii.u, .ascii.l, .ascii.l]):              nil
            case (.void,    [.ascii.V, .ascii.O, .ascii.I, .ascii.D]):              nil
            case (.void,    [.ascii.v, .ascii.o, .ascii.i, .ascii.d]):              nil
            default: throw DecodingError.dataCorrupted(
                    .init(
                        codingPath: [],
                        debugDescription: "Could not decode nil literal for \(V.self) from CSV bytes '\(bytes)'"
                    )
                )
            }
            
        }
        
        public func isNil(_ bytes: Deque<UInt8>) -> Bool {
            switch (self, bytes) {
            case (.blank,   []):                                                    true
            case (.empty,   [.ascii.E, .ascii.M, .ascii.P, .ascii.T, .ascii.Y]):    true
            case (.empty,   [.ascii.e, .ascii.m, .ascii.p, .ascii.t, .ascii.y]):    true
            case (.na,      [.ascii.N, .ascii.forwardSlash, .ascii.A]):             true
            case (.na,      [.ascii.n, .ascii.forwardSlash, .ascii.a]):             true
            case (.nil,     [.ascii.N, .ascii.I, .ascii.L]):                        true
            case (.nil,     [.ascii.n, .ascii.i, .ascii.l]):                        true
            case (.none,    [.ascii.N, .ascii.O, .ascii.N, .ascii.E]):              true
            case (.none,    [.ascii.n, .ascii.o, .ascii.n, .ascii.e]):              true
            case (.null,    [.ascii.N, .ascii.U, .ascii.L, .ascii.L]):              true
            case (.null,    [.ascii.n, .ascii.u, .ascii.l, .ascii.l]):              true
            case (.void,    [.ascii.V, .ascii.O, .ascii.I, .ascii.D]):              true
            case (.void,    [.ascii.v, .ascii.o, .ascii.i, .ascii.d]):              true
            default: false
            }
        }
    }
}

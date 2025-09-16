//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/04/2022.
//

import Foundation
import Vapor

extension TypedRequest {
    @dynamicMemberLookup
    public struct Query: Sendable {
        private unowned let request: Request
        private let context: Context = .shared
        
        init(request: Request) {
            self.request = request
        }
        
        private func getString(at name: String) -> String? {
            return request
                .query[String.self, at: name]
        }
        
        private func getObject<T: Codable>(at name: String, as type: T.Type = T.self) -> T? {
            return request.query[T.self, at: name]
        }
        
        private func getStringArray(at name: String) -> [String]? {
            return getString(at: name)?.split(separator: ",").map(String.init)
        }
        
        public func withDefault<T: LosslessStringConvertible>(_ path: KeyPath<Context, QueryParam<T>>) throws -> T {
            if let found = getString(at: context[keyPath: path].name).flatMap(T.init) { return found }
            else if let defaultValue = context[keyPath: path].defaultValue { return defaultValue }
            else { throw Abort(.badRequest, reason: "Missing Parameter or Default for \(path.stringValue)") }
        }
        
        public func withDefault<T: Codable>(_ path: KeyPath<Context, StructuredQueryParam<T>>) throws -> T {
            if let found = getObject(at: context[keyPath: path].name, as: T.self) { return found }
            else if let defaultValue = context[keyPath: path].defaultValue { return defaultValue }
            else { throw Abort(.badRequest, reason: "Missing Enum Parameter or Default for \(path.stringValue)") }
        }
        
        public func require<T: LosslessStringConvertible>(_ path: KeyPath<Context, QueryParam<T>>) throws -> T {
            if let found = getString(at: context[keyPath: path].name).flatMap(T.init) { return found }
            else { throw Abort(.badRequest, reason: "Missing Parameter \(path.stringValue)") }
        }
        
        public func require<T: Codable>(_ path: KeyPath<Context, StructuredQueryParam<T>>) throws -> T {
            if let found = getObject(at: context[keyPath: path].name, as: T.self) { return found }
            else { throw Abort(.badRequest, reason: "Missing Enum Parameter \(path.stringValue)") }
        }
        
        public subscript<T: LosslessStringConvertible>(dynamicMember path: KeyPath<Context, QueryParam<T>>) -> T? {
            return getString(at: context[keyPath: path].name)
                .flatMap(T.init) ?? context[keyPath: path].defaultValue
        }
        
        public subscript<T: LosslessStringConvertible>(dynamicMember path: KeyPath<Context, QueryParam<[T]>>) -> [T]? {
            return getStringArray(at: context[keyPath: path].name)?
                .compactMap(T.init) ?? context[keyPath: path].defaultValue
        }
        
        public subscript<T: Codable>(dynamicMember path: KeyPath<Context, StructuredQueryParam<T>>) -> T? {
            return getObject(at: context[keyPath: path].name) ?? context[keyPath: path].defaultValue
        }
    }
}

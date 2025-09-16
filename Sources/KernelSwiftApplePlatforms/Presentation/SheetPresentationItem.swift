//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 01/09/2023.
//

import Foundation

public protocol SheetPresentable: Hashable, Equatable, Identifiable, Sendable where Self.ID == String {
//    static var none: Self { get }
}

public struct SheetPresentationValue: Hashable, Identifiable, Equatable, Sendable {
    public var wrappedValue: any SheetPresentable
    
    public init<Value: SheetPresentable>(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
    
    public var id: String {
        wrappedValue.id
    }
        
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
//        wrappedValue.hash(into: &hasher)
        id.hash(into: &hasher)
    }
    
//    public static func none<Wrapped: SheetPresentable>(_ wrappedType: Wrapped.Type) -> Self { .init(wrappedValue: Wrapped.none) }
}



extension SheetPresentable {
    public func toPresentationValue() -> SheetPresentationValue {
        .init(wrappedValue: self)
    }
}

extension SheetPresentable {
    public func dotComposedID(_ ids: [String]) -> String {
        ids.joined(separator: ".")
    }
    
    public func dotComposedID(_ ids: String...) -> String {
        ids.joined(separator: ".")
    }
    
    public func slashComposedID(_ ids: [String]) -> String {
        ids.joined(separator: "/")
    }
    
    public func slashComposedID(_ ids: String...) -> String {
        ids.joined(separator: "/")
    }
}

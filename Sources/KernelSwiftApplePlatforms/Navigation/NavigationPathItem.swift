//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/08/2023.
//

import Foundation
import Collections
import SwiftUI

public protocol NavigationPathItem: Hashable, Equatable, Identifiable, Sendable where Self.ID == String {}

public struct WrappedNavigationPathItem: Hashable, Identifiable, Sendable {
    public var id: String
    public var wrappedItem: any NavigationPathItem
    
    public init<Item: NavigationPathItem>(wrappedItem: Item) {
        self.wrappedItem = wrappedItem
        self.id = wrappedItem.id
    }
//    
//    public init<Item: NavigationPathItem & Identifiable>(wrappedItem: Item) {
//        self.wrappedItem = wrappedItem
//        self.id = String(describing: wrappedItem.id)
//    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.wrappedItem.equals(rhs.wrappedItem) && lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        wrappedItem.hash(into: &hasher)
        id.hash(into: &hasher)
    }
}

public struct TypedNavigationPathItem<Item: NavigationPathItem>: Hashable, Identifiable, Sendable {
    public var id: String
    public var wrappedItem: Item
    
    public init(wrappedItem: Item) {
        self.wrappedItem = wrappedItem
        self.id = wrappedItem.id
    }
    //
    //    public init<Item: NavigationPathItem & Identifiable>(wrappedItem: Item) {
    //        self.wrappedItem = wrappedItem
    //        self.id = String(describing: wrappedItem.id)
    //    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.wrappedItem.equals(rhs.wrappedItem) && lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        wrappedItem.hash(into: &hasher)
        id.hash(into: &hasher)
    }
}

public typealias FlexibleNavigationPath = Deque<WrappedNavigationPathItem>

extension FlexibleNavigationPath {
    public mutating func append<Item: NavigationPathItem>(_ element: Item) {
        append(.init(wrappedItem: element))
    }
    
    public mutating func append(contentsOf collection: any Collection<any NavigationPathItem>) {
        append(contentsOf: collection.map { .init(wrappedItem: $0) })
    }
    
    public mutating func prepend<Item: NavigationPathItem>(_ element: Item) {
        prepend(.init(wrappedItem: element))
    }
    
    public mutating func prepend(contentsOf collection: any Collection<any NavigationPathItem>) {
        prepend(contentsOf: collection.map { .init(wrappedItem: $0) })
    }
}

public typealias TypedNavigationPath<Item: NavigationPathItem> = Deque<TypedNavigationPathItem<Item>>

extension TypedNavigationPath {
    public mutating func append<Item: NavigationPathItem>(_ element: Item) where Self.Element == TypedNavigationPathItem<Item> {
        let wrappedPathItem: TypedNavigationPathItem<Item> = .init(wrappedItem: element)
        append(wrappedPathItem)
    }
    
    public mutating func append<Item: NavigationPathItem>(contentsOf collection: any Collection<Item>) where Self.Element == TypedNavigationPathItem<Item> {
        append(contentsOf: collection.map { .init(wrappedItem: $0) })
    }
    
    public mutating func prepend<Item: NavigationPathItem>(_ element: Item) where Self.Element == TypedNavigationPathItem<Item> {
        prepend(.init(wrappedItem: element))
    }
    
    public mutating func prepend<Item: NavigationPathItem>(contentsOf collection: any Collection<Item>) where Self.Element == TypedNavigationPathItem<Item> {
        prepend(contentsOf: collection.map { .init(wrappedItem: $0) })
    }
}

extension NavigationPathItem {
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

public struct FlexibleNavigationPathKey: EnvironmentKey {
    public static let defaultValue: FlexibleNavigationPath = []
}

extension EnvironmentValues {
    public var currentNavigationPath: FlexibleNavigationPath {
        get { self[FlexibleNavigationPathKey.self] }
        set { self[FlexibleNavigationPathKey.self] = newValue }
    }
}

extension View {
    public func presentedNavigationPath(_ path: FlexibleNavigationPath) -> some View {
        environment(\.currentNavigationPath, path)
    }
}

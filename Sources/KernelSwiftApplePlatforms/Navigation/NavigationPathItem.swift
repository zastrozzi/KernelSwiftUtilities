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

public final class MutableFlexibleNavigationPath: Identifiable, @unchecked Sendable {
    public var id: String
    public var path: FlexibleNavigationPath
    
    public init(
        id: String,
        _ path: FlexibleNavigationPath = .init()
    ) {
        self.id = id
        self.path = path
    }
}

public typealias FlexibleNavigationPath = Deque<WrappedNavigationPathItem>

extension MutableFlexibleNavigationPath {
    public var count: Int {
        path.count
    }
    
    public var endIndex: Int {
        path.endIndex
    }
    
    public var startIndex: Int {
        path.startIndex
    }
    
    public func append<Item: NavigationPathItem>(_ element: Item) {
        path.append(.init(wrappedItem: element))
    }
    
    public func append(contentsOf collection: any Collection<any NavigationPathItem>) {
        path.append(contentsOf: collection.map { .init(wrappedItem: $0) })
    }
    
    public func popFirst() -> WrappedNavigationPathItem? {
        path.popFirst()
    }
    
    public var isEmpty: Bool {
        path.isEmpty
    }
    
    @discardableResult
    public func remove(at index: Int) -> WrappedNavigationPathItem {
        path.remove(at: index)
    }
    
    public func remove(atOffsets offsets: IndexSet) {
        path.remove(atOffsets: offsets)
    }
    
    public func removeAll(keepingCapacity keepCapacity: Bool = false) {
        path.removeAll(keepingCapacity: keepCapacity)
    }
    
    public func prepend<Item: NavigationPathItem>(_ element: Item) {
        path.prepend(.init(wrappedItem: element))
    }
    
    public func prepend(contentsOf collection: any Collection<any NavigationPathItem>) {
        path.prepend(contentsOf: collection.map { .init(wrappedItem: $0) })
    }
    
    @discardableResult
    public func removeFirst() -> WrappedNavigationPathItem {
        path.removeFirst()
    }
    
    public func removeFirst(_ n: Int) {
        path.removeFirst(n)
    }
    
    @discardableResult
    public func removeLast() -> WrappedNavigationPathItem {
        path.removeLast()
    }
    
    public func removeLast(_ n: Int) {
        path.removeLast(n)
    }
}

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
    public static let defaultValue: FlexibleNavigationPath = .init()
}

public struct MutableFlexibleNavigationPathKey: EnvironmentKey {
    public static let defaultValue: MutableFlexibleNavigationPath = .init(id: "")
}

extension EnvironmentValues {
    public var currentMutableNavigationPath: MutableFlexibleNavigationPath {
        get { self[MutableFlexibleNavigationPathKey.self] }
        set { self[MutableFlexibleNavigationPathKey.self] = newValue }
    }
    
    public var currentNavigationPath: FlexibleNavigationPath {
        get { self[FlexibleNavigationPathKey.self] }
        set { self[FlexibleNavigationPathKey.self] = newValue }
    }
}

extension View {
    public func presentedMutableNavigationPath(_ path: MutableFlexibleNavigationPath) -> some View {
        environment(\.currentMutableNavigationPath, path)
    }
    
    public func presentedNavigationPath(_ path: FlexibleNavigationPath) -> some View {
        environment(\.currentNavigationPath, path)
    }
}

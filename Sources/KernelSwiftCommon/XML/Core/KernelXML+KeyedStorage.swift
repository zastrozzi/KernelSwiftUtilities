//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 17/06/2025.
//

extension KernelXML {
    public struct KeyedStorage<Key: Hashable & Comparable, Value> {
        public typealias Buffer = [(Key, Value)]
        public typealias KeyMap = [Key: [Int]]
        
        fileprivate var keyMap = KeyMap()
        fileprivate var buffer = Buffer()
        
        public var isEmpty: Bool { buffer.isEmpty }
        public var count: Int { buffer.count }
        public var keys: [Key] { buffer.map { $0.0 } }
        public var values: [Value] { buffer.map { $0.1 } }
        
        public init<S>(_ sequence: S) where S: Sequence, S.Element == (Key, Value) {
            buffer = Buffer()
            keyMap = KeyMap()
            sequence.forEach { key, value in append(value, at: key) }
        }
        
        public subscript(key: Key) -> [Value] {keyMap[key]?.map { buffer[$0].1 } ?? [] }
        
        public mutating func append(_ value: Value, at key: Key) {
            let i = buffer.count
            buffer.append((key, value))
            if keyMap[key] != nil {
                keyMap[key]?.append(i)
            } else {
                keyMap[key] = [i]
            }
        }
        
        public func map<T>(_ transform: (Key, Value) throws -> T) rethrows -> [T] {
            try buffer.map(transform)
        }
        
        public func compactMap<T>(
            _ transform: ((Key, Value)) throws -> T?
        ) rethrows -> [T] {
            try buffer.compactMap(transform)
        }
        
        public mutating func reserveCapacity(_ capacity: Int) {
            buffer.reserveCapacity(capacity)
            keyMap.reserveCapacity(capacity)
        }
        
        public init() {}
    }
}

extension KernelXML.KeyedStorage: Sequence {
    public func makeIterator() -> Buffer.Iterator { buffer.makeIterator() }
}

extension KernelXML.KeyedStorage: CustomStringConvertible {
    public var description: String {
        let result = buffer.map { "\"\($0)\": \($1)" }.joined(separator: ", ")
        
        return "[\(result)]"
    }
}

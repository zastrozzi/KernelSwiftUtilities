//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 19/06/2025.
//

import Foundation

extension KernelXML {
    public struct XMLDecodingStorage {
        private var containers: [KernelXML.Boxable] = []
        
        public init() {}
        
        public var count: Int { containers.count }
        public func topContainer() -> KernelXML.Boxable? { containers.last }
        
        public mutating func push(container: Boxable) {
            if let keyedBox = container as? KeyedBox {
                containers.append(SharedBox(keyedBox))
            } else if let unkeyedBox = container as? UnkeyedBox {
                containers.append(SharedBox(unkeyedBox))
            } else {
                containers.append(container)
            }
        }
        
        @discardableResult
        public mutating func popContainer() -> Boxable? {
            guard !containers.isEmpty else {
                return nil
            }
            return containers.removeLast()
        }
    }
}

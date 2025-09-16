//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 18/06/2025.
//

import Foundation

extension KernelXML {
    public struct EncodingStorage {
        private var containers: [KernelXML.Boxable] = []
        
        public init() {}
        
        public var count: Int { containers.count }
        public var lastContainer: KernelXML.Boxable? { containers.last }
        
        public mutating func pushKeyedContainer(
            _ keyedBox: KernelXML.KeyedBox = KernelXML.KeyedBox()
        ) -> KernelXML.SharedBox<KernelXML.KeyedBox> {
            let container = KernelXML.SharedBox(keyedBox)
            containers.append(container)
            return container
        }
        
        public mutating func pushChoiceContainer() -> SharedBox<ChoiceBox> {
            let container = SharedBox(ChoiceBox())
            containers.append(container)
            return container
        }
        
        public mutating func pushUnkeyedContainer() -> SharedBox<UnkeyedBox> {
            let container = SharedBox(UnkeyedBox())
            containers.append(container)
            return container
        }
        
        public mutating func push(container: KernelXML.Boxable) {
            if let keyedBox = container as? KeyedBox {
                containers.append(SharedBox(keyedBox))
            } else if let unkeyedBox = container as? UnkeyedBox {
                containers.append(SharedBox(unkeyedBox))
            } else {
                containers.append(container)
            }
        }
        
        public mutating func popContainer() -> KernelXML.Boxable {
            precondition(!containers.isEmpty, "Empty container stack.")
            return containers.popLast()!
        }
    }
}

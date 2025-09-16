//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 17/06/2025.
//

extension KernelXML {
    public struct KeyedBox {
        public typealias Key = String
        public typealias Attribute = SimpleBoxable
        public typealias Element = Boxable
        
        public typealias Attributes = KeyedStorage<Key, Attribute>
        public typealias Elements = KeyedStorage<Key, Element>
        
        public var elements: Elements
        public var attributes: Attributes
        
        public init(
            elements: Elements = .init(),
            attributes: Attributes = .init()
        ) {
            self.elements = elements
            self.attributes = attributes
        }
        
        public var values: (elements: Elements, attributes: Attributes) {
            (
                elements: elements,
                attributes: attributes
            )
        }
        
        public var value: SimpleBoxable? {
            return elements.values.first as? SimpleBoxable
        }
    }
}

extension KernelXML.KeyedBox {
    public init<E, A>(
        elements: E,
        attributes: A
    ) where E: Sequence, E.Element == (Key, Element), A: Sequence, A.Element == (Key, Attribute) {
        let elements = Elements(elements)
        let attributes = Attributes(attributes)
        self.init(elements: elements, attributes: attributes)
    }
}

extension KernelXML.KeyedBox: KernelXML.Boxable {
    public var isNull: Bool { false }
    public var xmlString: String? { nil }
}

extension KernelXML.KeyedBox: CustomStringConvertible {
    public var description: String {
        return "{attributes: \(attributes), elements: \(elements)}"
    }
}

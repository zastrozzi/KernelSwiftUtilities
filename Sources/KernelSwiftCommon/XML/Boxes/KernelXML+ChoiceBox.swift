//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 17/06/2025.
//

extension KernelXML {
    public struct ChoiceBox {
        public var key: String
        public var value: Boxable
        
        public init(
            key: String = "",
            value: Boxable = NullBox()
        ) {
            self.key = key
            self.value = value
        }
    }
}

extension KernelXML.ChoiceBox: KernelXML.Boxable {
    public var isNull: Bool { false }
    public var xmlString: String? { nil }
}

extension KernelXML.ChoiceBox: KernelXML.SimpleBoxable {}

extension KernelXML.ChoiceBox {
    public init?(_ keyedBox: KernelXML.KeyedBox) {
        guard
            let firstKey = keyedBox.elements.keys.first,
            let firstElement = keyedBox.elements[firstKey].first
        else {
            return nil
        }
        self.init(key: firstKey, value: firstElement)
    }
    
    public init(_ singleKeyedBox: KernelXML.SingleKeyedBox) {
        self.init(key: singleKeyedBox.key, value: singleKeyedBox.element)
    }
}

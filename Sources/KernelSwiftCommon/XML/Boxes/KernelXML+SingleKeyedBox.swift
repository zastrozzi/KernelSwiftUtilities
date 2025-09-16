//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 17/06/2025.
//

extension KernelXML {
    public struct SingleKeyedBox: KernelXML.SimpleBoxable {
        public var key: String
        public var element: KernelXML.Boxable
        
        public init(
            key: String,
            element: KernelXML.Boxable
        ) {
            self.key = key
            self.element = element
        }
    }
}

extension KernelXML.SingleKeyedBox: KernelXML.Boxable {
    public var isNull: Bool { false }
    public var xmlString: String? { nil }
}

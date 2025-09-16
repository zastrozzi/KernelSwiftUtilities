//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 17/06/2025.
//

extension KernelXML {
    public struct NullBox {
        public init() {}
    }
}

extension KernelXML.NullBox: KernelXML.Boxable {
    public var isNull: Bool { true }
    public var xmlString: String? { nil }
}

extension KernelXML.NullBox: KernelXML.SimpleBoxable {}

extension KernelXML.NullBox: Equatable {
    public static func ==(_: KernelXML.NullBox, _: KernelXML.NullBox) -> Bool { true }
}

extension KernelXML.NullBox: CustomStringConvertible {
    public var description: String { "null" }
}

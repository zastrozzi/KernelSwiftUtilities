//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 17/06/2025.
//

extension KernelXML {
    public typealias UnkeyedBox = [KernelXML.Boxable]
}

extension Array: KernelXML.Boxable {
    public var isNull: Bool { false }
    public var xmlString: String? { nil }
}

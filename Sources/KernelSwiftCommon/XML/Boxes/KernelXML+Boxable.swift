//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 17/06/2025.
//

@_documentation(visibility: private)
public protocol _KernelXMLBoxable {
    var isNull: Bool { get }
    var xmlString: String? { get }
}

@_documentation(visibility: private)
public protocol _KernelXMLSimpleBoxable: KernelXML.Boxable {}



@_documentation(visibility: private)
public protocol _KernelXMLTypeErasedSharedBoxable {
    func typeErasedUnbox() -> KernelXML.Boxable
}

@_documentation(visibility: private)
public protocol _KernelXMLSharedBoxable: KernelXML.TypeErasedSharedBoxable {
    associatedtype B: KernelXML.Boxable
    func unbox() -> B
}

@_documentation(visibility: private)
public protocol _KernelXMLValueBoxable: KernelXML.SimpleBoxable {
    associatedtype Value
    init(_ value: Value)
}

extension KernelXML.SharedBoxable {
    public func typeErasedUnbox() -> KernelXML.Boxable {
        return unbox()
    }
}

extension KernelXML {
    public typealias Boxable = _KernelXMLBoxable
    public typealias SimpleBoxable = _KernelXMLSimpleBoxable
    public typealias TypeErasedSharedBoxable = _KernelXMLTypeErasedSharedBoxable
    public typealias SharedBoxable = _KernelXMLSharedBoxable
    public typealias ValueBoxable = _KernelXMLValueBoxable
}

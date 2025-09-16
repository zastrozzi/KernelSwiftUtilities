//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 18/06/2025.
//

extension KernelXML {
    public class SharedBox<Value: KernelXML.Boxable> {
        private(set) var value: Value
        
        public init(_ value: Value) {
            self.value = value
        }
        
        public func withShared<T>(_ transform: (inout Value) throws -> T) rethrows -> T {
            return try transform(&value)
        }
    }
}

extension KernelXML.SharedBox: KernelXML.Boxable {
    public var isNull: Bool { value.isNull }
    public var xmlString: String? { value.xmlString }
}

extension KernelXML.SharedBox: KernelXML.SharedBoxable {
    public func unbox() -> Value { value }
}

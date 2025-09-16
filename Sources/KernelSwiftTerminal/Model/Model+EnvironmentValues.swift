//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/10/2023.
//

import Foundation

public protocol _KernelSwiftTerminalEnvironmentKey {
    associatedtype Value
    static var defaultValue: Value { get }
}

extension KernelSwiftTerminal.Model {
    public typealias EnvironmentKey = _KernelSwiftTerminalEnvironmentKey
}

extension KernelSwiftTerminal.Model {
    public struct EnvironmentValues {
        var values: [ObjectIdentifier: Any] = [:]
        public subscript<K: EnvironmentKey>(key: K.Type) -> K.Value {
            get { values[ObjectIdentifier(key)] as? K.Value ?? K.defaultValue }
            set { values[ObjectIdentifier(key)] = newValue }
        }
    }
}

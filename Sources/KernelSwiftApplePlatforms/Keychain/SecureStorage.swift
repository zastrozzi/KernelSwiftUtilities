//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/04/2025.
//

import Foundation
import SwiftUI
import Combine

//private final class KeychainStorage<Value: Codable>: ObservableObject {
//    var value: Value {
//        set {
//            objectWillChange.send()
//            save(newValue)
//        }
//        get { fetch() }
//    }
//    
//    let objectWillChange = PassthroughSubject<Void, Never>()
//    
//    private let key: String
//    private let defaultValue: Value
//    private let decoder = JSONDecoder()
//    private let encoder = JSONEncoder()
//    
//    private let keychain = Keychain(
//        service: "com.kernel.keychain.service",
//        accessGroup: "com.kernel.keychain.accessGroup"
//    )
//        .synchronizable(true)
//        .accessibility(.always)
//    
//    init(defaultValue: Value, for key: String) {
//        self.defaultValue = defaultValue
//        self.key = key
//    }
//    
//    private func save(_ newValue: Value) {
//        guard let data = try? encoder.encode(newValue) else {
//            return
//        }
//        
//        try? keychain.set(data, key: key)
//    }
//    
//    private func fetch() -> Value {
//        guard
//            let data = try? keychain.getData(key),
//            let freshValue = try? decoder.decode(Value.self, from: data)
//        else {
//            return defaultValue
//        }
//        
//        return freshValue
//    }
//}

//@MainActor
//@propertyWrapper public struct SecureStorage<Value: Codable>: DynamicProperty {
//    @ObservedObject private var storage: KeychainStorage<Value>
//    
//    public var wrappedValue: Value {
//        get { storage.value }
//        
//        nonmutating set {
//            storage.value = newValue
//        }
//    }
//    
//    public init(wrappedValue: Value, _ key: String) {
//        self.storage = KeychainStorage(defaultValue: wrappedValue, for: key)
//    }
//    
//    public var projectedValue: Binding<Value> {
//        .init(
//            get: { wrappedValue },
//            set: { wrappedValue = $0 }
//        )
//    }
//}

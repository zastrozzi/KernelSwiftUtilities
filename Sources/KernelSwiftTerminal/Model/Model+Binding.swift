//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 06/11/2023.
//

import Foundation

extension KernelSwiftTerminal.Model {
    @propertyWrapper
    public struct Binding<T> {
        let get: () -> T
        let set: (T) -> Void
        
        public init(get: @escaping () -> T, set: @escaping (T) -> Void) {
            self.get = get
            self.set = set
        }
        
        public var wrappedValue: T {
            get { get() }
            nonmutating set { set(newValue) }
        }
        
        public var projectedValue: Binding<T> { self }
    }
}

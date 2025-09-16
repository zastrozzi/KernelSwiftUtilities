//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/08/2022.
//

import Foundation
import SwiftUI

#if compiler(>=5.7)
// MARK: - made view types (any View) over AnyView
typealias DestinationBuilder<T> = (T) -> (any View)


class DestinationBuilderHolder: ObservableObject {
    static func identifier(for type: Any.Type) -> String {
        String(reflecting: type)
    }
    
    // MARK: - made view types (any View) over AnyView
    var builders: [String: (Any) -> (any View)?] = [:]
    
    init() {
        builders = [:]
        
//        toolbarContent = { AnyView(EmptyView()) }
    }
    
    // MARK: - made view types (any View) over AnyView
    func appendBuilder<T>(_ builder: @escaping (T) -> (any View)) {
        let key = Self.identifier(for: T.self)
        builders[key] = { data in
            if let typedData = data as? T {
                return builder(typedData)
            } else {
                return nil
            }
        }
    }
    
    // MARK: - made view types (any View) over AnyView
    
    func build<T>(_ typedData: T) -> any View {
        let base = (typedData as? AnyHashable)?.base
        let type = type(of: base ?? typedData)
        let key = Self.identifier(for: type)
        
        if let builder = builders[key], let output = builder(typedData) {
            return output
        }
        assertionFailure("No view builder found for key \(key)")
        return Image(systemName: "exclamationmark.triangle")
    }
}
#endif

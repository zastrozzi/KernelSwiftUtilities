//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 09/01/2022.
//

import Foundation
import SwiftUI
import Combine

public final class SwiftUIInspector<V> {
    let notice = PassthroughSubject<UInt, Never>()
    var callbacks = [UInt: (V) -> Void]()
    
    public func visit(_ view: V, _ line: UInt) {
        if let callback = callbacks.removeValue(forKey: line) {
            callback(view)
        }
    }
}

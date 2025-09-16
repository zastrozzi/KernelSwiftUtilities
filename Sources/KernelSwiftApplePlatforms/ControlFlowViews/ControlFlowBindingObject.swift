//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 30/08/2022.
//

import Foundation
import SwiftUI

class ControlFlowBindingObject<Value>: ObservableObject {
    let wrappedValue: Binding<Value>
    
    init(binding: Binding<Value>) {
        self.wrappedValue = binding
    }
}


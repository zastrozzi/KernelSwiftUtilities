//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/08/2022.
//

import Foundation
import SwiftUI

#if compiler(>=5.7)
class NavigationPathHolder: ObservableObject {
    var path: Binding<[any Hashable]>
    
    init(_ path: Binding<[any Hashable]>) {
        self.path = path
    }
}
#endif

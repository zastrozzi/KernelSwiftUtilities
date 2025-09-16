//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/10/2023.
//

import Foundation
import KernelSwiftTerminal

@main
enum KernelOpenAPITester {
  
    
    static func main() async throws {
        let app = KernelSwiftTerminal.Application(rootView: Views.RootView())
        app.run(withAccessory: true)
//        app.start()
    }
}


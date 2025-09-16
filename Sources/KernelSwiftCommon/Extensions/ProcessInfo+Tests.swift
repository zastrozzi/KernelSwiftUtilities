//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 09/01/2022.
//

import Foundation

public extension ProcessInfo {
    var isRunningTests: Bool {
        environment["XCTestConfigurationFilePath"] != nil
    }
}

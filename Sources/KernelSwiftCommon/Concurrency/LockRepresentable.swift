//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 28/09/2023.
//

import Foundation

public protocol LockRepresentable {
    func lock()
    func unlock()
    static func fromUnderlying() -> Self
}


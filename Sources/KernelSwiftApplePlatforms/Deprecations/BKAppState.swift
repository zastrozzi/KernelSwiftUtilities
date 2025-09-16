//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/04/2022.
//

import Foundation

@available(*, deprecated)
public protocol BKAppState: Equatable {
    static func initialize() -> Self
}

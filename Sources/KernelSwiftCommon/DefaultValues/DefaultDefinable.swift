//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 24/04/2023.
//

import Foundation

public protocol DefaultDefinable {
    static var defaultValue: Self { get }
}

//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/04/2022.
//

import Foundation

func zip<X, Y, Z>(_ left: X?, _ right: Y?, with fn: (X, Y) -> Z) -> Z? {
    return left.flatMap { lft in right.map { rght in fn(lft, rght) }}
}

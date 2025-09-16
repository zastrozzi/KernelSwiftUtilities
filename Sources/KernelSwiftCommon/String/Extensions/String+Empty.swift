//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 16/04/2023.
//

import Foundation

public extension String {
    var isEmptyOrBlank: Bool { isEmpty ? true : allSatisfy { $0.isWhitespace } }
}

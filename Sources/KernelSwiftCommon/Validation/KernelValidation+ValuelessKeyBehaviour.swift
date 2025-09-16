//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 26/03/2025.
//

import Foundation

extension KernelValidation {
    enum ValuelessKeyBehavior {
        case missing
        case skipWhenUnset
        case skipAlways
        case ignore
    }
}

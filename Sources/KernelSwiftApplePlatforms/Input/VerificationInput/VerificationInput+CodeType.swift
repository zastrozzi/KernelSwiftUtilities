//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 17/05/2025.
//

import Foundation

extension VerificationInput {
    public enum CodeType: Int, CaseIterable {
        case four = 4
        case six = 6
        
        var stringValue: String { "\(rawValue) Digit Code" }
    }
}

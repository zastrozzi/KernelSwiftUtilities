//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 18/05/2025.
//

import Foundation

extension KernelAppUtils.CodeScanner {
    public enum ScanMode {
        case once
        case oncePerCode
        case continuous
        case continuousExcept(ignoredList: Set<String>)
        case manual
        
        var isManual: Bool {
            switch self {
            case .manual:
                return true
            case .once, .oncePerCode, .continuous, .continuousExcept:
                return false
            }
        }
    }
}

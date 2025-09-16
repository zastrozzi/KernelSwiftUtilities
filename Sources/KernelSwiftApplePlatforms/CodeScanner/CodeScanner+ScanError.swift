//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 18/05/2025.
//

import Foundation

extension KernelAppUtils.CodeScanner {
    public enum ScanError: Error {
        case badInput
        case badOutput
        case initError(_ error: Error)
        case permissionDenied
    }
}

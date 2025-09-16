//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 22/09/2024.
//

import Foundation

extension KernelNetworking.DKIM {
    public enum Result: String, CaseIterable, Sendable {
        case none = "none"
        case pass = "pass"
        case fail = "fail"
        case policy = "policy"
        case neutral = "neutral"
        case temporaryError = "temperror"
        case permanentError = "permerror"
    }
}

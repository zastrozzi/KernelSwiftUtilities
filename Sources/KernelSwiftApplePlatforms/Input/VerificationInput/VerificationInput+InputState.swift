//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 17/05/2025.
//

import Foundation

extension VerificationInput {
    public enum InputState: Sendable {
        case typing
        case valid
        case invalid
    }
}

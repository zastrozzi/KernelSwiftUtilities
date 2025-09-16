//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 17/05/2025.
//

import Foundation

extension KernelCryptography.OTP {
    public enum OTPAlgorithm: Codable {
        case sha1
        case sha256
        case sha512
    }
}

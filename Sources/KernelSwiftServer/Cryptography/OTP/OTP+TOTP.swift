//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 17/05/2025.
//

import Foundation

extension KernelCryptography.OTP {
    public struct TOTP {
        public let secret: [UInt8]
        public let digits: Int
        public let timeInterval: Int
        public let algorithm: OTPAlgorithm
        
        public init(secret: [UInt8], digits: Int = 6, timeInterval: Int = 30, algorithm: OTPAlgorithm = .sha1) throws {
            try Self.validateDigits(digit: digits)
            self.secret = secret
            self.digits = digits
            self.timeInterval = timeInterval
            self.algorithm = algorithm
        }
        
        public func generate(time: Date) throws -> String {
            let secondsPast1970 = Int(floor(time.timeIntervalSince1970))
            return try generate(secondsPast1970: secondsPast1970)
        }
        
        public func generate(secondsPast1970: Int) throws -> String {
            try Self.validateTime(time: secondsPast1970)
            let counterValue = Int(floor(Double(secondsPast1970) / Double(timeInterval)))
            return generateOTP(
                secret: secret,
                algorithm: algorithm,
                counter: UInt64(counterValue),
                digits: digits
            )
        }
        
        private static func validateDigits(digit: Int) throws {
            let validDigits = 6...8
            guard validDigits.contains(digit) else { throw OTPError.invalidDigits }
        }
        
        private static func validateTime(time: Int) throws {
            guard time > 0 else { throw OTPError.invalidTime }
        }
    }
}

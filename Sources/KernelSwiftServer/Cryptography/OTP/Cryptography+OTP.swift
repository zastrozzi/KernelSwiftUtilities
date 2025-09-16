//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 17/05/2025.
//

import Vapor
import Fluent
import KernelSwiftCommon

extension KernelCryptography {
    public enum OTP {}
}

extension KernelCryptography.OTP {
    public static func generateOTP(
        secret: [UInt8],
        algorithm: OTPAlgorithm = .sha1,
        counter: UInt64,
        digits: Int = 6
    ) -> String {
        let counterMessage = counter.toBigEndianByteArray()
        let hmac = switch algorithm {
        case .sha1:
            KernelCryptography.HMAC.authenticationCode(.SHA1, secret, counterMessage)
        case .sha256:
            KernelCryptography.HMAC.authenticationCode(.SHA2_256, secret, counterMessage)
        case .sha512:
            KernelCryptography.HMAC.authenticationCode(.SHA2_512, secret, counterMessage)
        }
        
        let offset = Int((hmac.last ?? 0x00) & 0x0f)
        let truncatedHMAC = Array(hmac[offset...offset + 3])
        var number = UInt32(strtoul(truncatedHMAC.toHexString(spaced: false, uppercased: false), nil, 16))
        number &= 0x7fffffff
        number = number % UInt32(pow(10, Float(digits)))
        let strNum = String(number)
        if strNum.count == digits { return strNum }
        let prefixedZeros = String(repeatElement("0", count: (digits - strNum.count)))
        return (prefixedZeros + strNum)
    }
    
    public enum OTPError: Error, LocalizedError, CustomStringConvertible {
        case invalidDigits
        case invalidTime
        
        public var errorDescription: String? { self.description }
        
        public var description: String {
            let caseDescription: String = switch self {
            case .invalidDigits: "Invalid Digits"
            case .invalidTime: "Invalid Time"
            }
            
            return "OTPError: \(caseDescription)"
        }
    }

}

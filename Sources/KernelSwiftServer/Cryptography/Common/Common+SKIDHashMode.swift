//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/10/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCryptography.Common {
    public enum SKIDHashMode: String, Codable, Equatable, CaseIterable, RawRepresentableAsString, FluentStringEnum, OpenAPIStringEnumSampleable, Sendable {
        public static let fluentEnumName: String = "k_crypto-skid_hash_mode"
        
        case sha256pkcs1DerHex = "SHA256_PKCS1_DER_HEX"
        case sha256X509DerHex = "SHA256_X509_DER_HEX"
        case sha1pkcs1DerHex = "SHA1_PKCS1_DER_HEX"
        case sha1X509DerHex = "SHA1_X509_DER_HEX"
        case md5pkcs1DerHex = "MD5_PKCS1_DER_HEX"
        case md5X509DerHex = "MD5_X509_DER_HEX"
        
        case sha256pkcs1DerB64 = "SHA256_PKCS1_DER_B64"
        case sha256X509DerB64 = "SHA256_X509_DER_B64"
        case sha1pkcs1DerB64 = "SHA1_PKCS1_DER_B64"
        case sha1X509DerB64 = "SHA1_X509_DER_B64"
        case md5pkcs1DerB64 = "MD5_PKCS1_DER_B64"
        case md5X509DerB64 = "MD5_X509_DER_B64"
    }
}

//
//  File.swift
//
//
//  Created by Jonathan Forbes on 04/10/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCryptography.Common {
    public enum JWKSKIDHashMode: String, Codable, Equatable, CaseIterable, RawRepresentableAsString, FluentStringEnum, OpenAPIStringEnumSampleable, Sendable {
        public static let fluentEnumName: String = "k_crypto-jwks_kid_hash_mode"
        case sha1ThumbBase64Url = "SHA1_THUMB_BASE64URL"
        case sha256ThumbBase64Url = "SHA256_THUMB_BASE64URL"
    }
}

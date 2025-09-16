//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 21/06/2023.
//
import KernelSwiftCommon

extension KernelX509.Common {
    public enum KeyUsageFlag: String, Codable, Equatable, CaseIterable, RawRepresentableAsString, FluentStringEnum, OpenAPIStringEnumSampleable, Sendable, ASN1SetDecodable {
        public static let fluentEnumName: String = "k_x509-ku_flag"
        case digitalSignature
        case nonRepudiation
        case keyEncipherment
        case dataEncipherment
        case keyAgreement
        case keyCertSign
        case cRLSign
        case encipherOnly
        case decipherOnly
    }
}

extension KernelX509.Common.KeyUsageFlag {
    public var bitMask: UInt16 {
        switch self {
        case .digitalSignature: return 0x8000
        case .nonRepudiation: return 0x4000
        case .keyEncipherment: return 0x2000
        case .dataEncipherment: return 0x1000
        case .keyAgreement: return 0x0800
        case .keyCertSign: return 0x0400
        case .cRLSign: return 0x0200
        case .encipherOnly: return 0x0100
        case .decipherOnly: return 0x0080
        }
    }
    
    public static var nonDecipherFlags: [Self] {
        [
            .digitalSignature,
                .nonRepudiation,
                .keyEncipherment,
                .dataEncipherment,
                .keyAgreement,
                .keyCertSign,
                .cRLSign,
                .encipherOnly
        ]
    }
    
}

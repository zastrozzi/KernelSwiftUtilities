//
//  File.swift
//
//
//  Created by Jonathan Forbes on 20/06/2023.
//

extension KernelX509.Certificate {
    public struct Version: Hashable, Sendable, Comparable, CustomStringConvertible {
        public var rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        public static func < (lhs: KernelX509.Certificate.Version, rhs: KernelX509.Certificate.Version) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
        
        public var description: String {
            switch self {
            case .v1: return "X509CertificateV1"
            case .v3: return "X509CertificateV3"
            case let unknown: return "X509CertificateV\(unknown.rawValue + 1)"
            }
        }
        
        public static let v1 = Self(rawValue: 0x00)
        public static let v3 = Self(rawValue: 0x02)
    }
}

extension KernelX509.Certificate.Version: ASN1Buildable {
    public func buildASN1Type() -> KernelASN1.ASN1Type {
        .tagged(0, .constructed([.integer(.init(int: .init(rawValue)))]))
    }
}

extension KernelX509.Certificate.Version: ASN1Decodable {
    public init(from asn1Type: KernelASN1.ASN1Type) throws {
        guard case let .tagged(0, .constructed(array)) = asn1Type else { throw Self.decodingError(.tagged(0, .constructed), asn1Type) }
        guard case let .integer(asn1Integer) = array[0] else {
            throw Self.decodingError(.integer, array[0])
        }
        
        self.rawValue = asn1Integer.int.toInt()!
    }
}

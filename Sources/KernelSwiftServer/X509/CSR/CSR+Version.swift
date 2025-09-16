//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 19/06/2023.
//

extension KernelX509.CSR {
    public struct Version: Hashable, Sendable, Comparable, CustomStringConvertible {
        public var rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        public static func < (lhs: KernelX509.CSR.Version, rhs: KernelX509.CSR.Version) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
        
        public var description: String {
            switch self {
            case .v1: return "CSRv1"
            case let unknown: return "CSRv\(unknown.rawValue + 1)"
            }
        }
        
        public static let v1 = Self(rawValue: 0)
    }
}

extension KernelX509.CSR.Version: ASN1Decodable {
    public init(from asn1Type: KernelASN1.ASN1Type) throws {
        guard case let .integer(asn1Integer) = asn1Type else { throw Self.decodingError(.integer, asn1Type) }
        self.rawValue = asn1Integer.int.toInt()!
    }
}

extension KernelX509.CSR.Version: ASN1Buildable {
    public func buildASN1Type() -> KernelASN1.ASN1Type {
        .integer(.init(data: [.init(rawValue)]))
    }
}

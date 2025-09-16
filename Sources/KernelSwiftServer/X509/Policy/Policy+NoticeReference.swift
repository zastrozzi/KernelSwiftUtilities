//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 11/07/2023.
//
import KernelSwiftCommon

extension KernelX509.Policy {
    public struct NoticeReference: ASN1Decodable {
        public var organisation: DisplayText
        public var noticeNumbers: [KernelNumerics.BigInt]
        
        public init(
            organisation: DisplayText,
            noticeNumbers: [KernelNumerics.BigInt]
        ) {
            self.organisation = organisation
            self.noticeNumbers = noticeNumbers
        }
        //        public static var asn1DecodingSchema: DecodingSchema {[]}
        public init(from decoder: Decoder) throws {
            fatalError()
        }
        
        public init(from asn1Type: KernelASN1.ASN1Type) throws {
            guard case let .sequence(items) = asn1Type, items.count == 2 else { throw Self.decodingError(.sequence, asn1Type) }
            self.organisation = try .init(from: items[0])
            guard case let .sequence(items1) = items[1] else { throw Self.decodingError(.sequence, items[1]) }
            self.noticeNumbers = try items1.map {
                guard case let .integer(asn1Int) = $0 else { throw Self.decodingError(.integer, $0) }
                return asn1Int.int
            }
        }
        
    }
}

extension KernelX509.Policy.NoticeReference: ASN1Buildable {
    public func buildASN1Type() -> KernelASN1.ASN1Type {
        .sequence([
            organisation.buildASN1Type(),
            .sequence(noticeNumbers.map { .integer(.init(int: $0)) })
        ])
//        .sequence(rdns.map { $0.buildASN1Type() })
    }
}

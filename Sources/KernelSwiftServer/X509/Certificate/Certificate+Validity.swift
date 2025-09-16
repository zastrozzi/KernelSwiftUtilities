//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 09/07/2023.
//

import Foundation

extension KernelX509.Certificate {
    public struct Validity {
        public var notBefore: Date
        public var notAfter: Date
        public var notBeforeFormat: KernelASN1.ASN1TypeTag
        public var notAfterFormat: KernelASN1.ASN1TypeTag
        
        public init(
            notBefore: Date,
            notAfter: Date,
            notBeforeFormat: KernelASN1.ASN1TypeTag = .utcTime,
            notAfterFormat: KernelASN1.ASN1TypeTag = .utcTime
        ) {
            self.notBefore = notBefore
            self.notAfter = notAfter
            self.notBeforeFormat = notBeforeFormat
            self.notAfterFormat = notAfterFormat
        }
        
        public init(from fields: KernelX509.Fluent.Model.Validity) {
            self.init(
                notBefore: fields.notBefore,
                notAfter: fields.notAfter
            )
        }
    }
}

extension KernelX509.Certificate.Validity: ASN1Buildable {
    public func buildASN1Type() -> KernelASN1.ASN1Type {
        let before: KernelASN1.ASN1Type = switch self.notBeforeFormat {
        case .utcTime: .utcTime(.init(from: notBefore))
        case .generalisedTime: .generalisedTime(.init(from: notBefore))
        default: preconditionFailure()
        }
        let after: KernelASN1.ASN1Type = switch self.notAfterFormat {
        case .utcTime: .utcTime(.init(from: notAfter))
        case .generalisedTime: .generalisedTime(.init(from: notAfter))
        default: preconditionFailure()
        }
        return .sequence([
            before, after
        ])
    }
}

extension KernelX509.Certificate.Validity: ASN1Decodable {
    //    public static var asn1DecodingSchema: DecodingSchema {
    //        [
    //            .init(from: \.algorithm, dataType: .objectIdentifier, decodedType: KernelASN1.ASN1AlgorithmIdentifier.self),
    //            .init(from: \.parameters, dataType: .null, decodedType: KernelASN1.ASN1Type.self)
    //        ]
    //    }
    //
    
    public init(from decoder: Decoder) throws {
        fatalError()
    }
    
    public init(from asn1Type: KernelASN1.ASN1Type) throws {
        guard case let .sequence(sequenceItems) = asn1Type else { throw Self.decodingError(.sequence, asn1Type) }
        if case let .utcTime(asn1UTCTimeBefore) = sequenceItems[0] {
            self.notBefore = try asn1UTCTimeBefore.toDate()
            self.notBeforeFormat = .utcTime
        }
        else if case let .generalisedTime(asn1GeneralisedTimeBefore) = sequenceItems[0] {
            self.notBefore = try asn1GeneralisedTimeBefore.toDate()
            self.notBeforeFormat = .generalisedTime
        }
        else { throw Self.decodingError(nil, sequenceItems[0]) }
        if case let .utcTime(asn1UTCTimeAft) = sequenceItems[1] {
            self.notAfter = try asn1UTCTimeAft.toDate()
            self.notAfterFormat = .utcTime
        }
        else if case let .generalisedTime(asn1GeneralisedTimeAft) = sequenceItems[1] {
            self.notAfter = try asn1GeneralisedTimeAft.toDate()
            self.notAfterFormat = .generalisedTime
        }
        else { throw Self.decodingError(nil, sequenceItems[1]) }
//            guard case let .utcTime(asn1UTCTimeAfter) = sequenceItems[1] else { throw Self.decodingError(.utcTime, sequenceItems[1]) }
//            self.notBefore = try asn1UTCTimeBefore.toDate()
//            self.notAfter = try asn1UTCTimeAfter.toDate()
    }
}

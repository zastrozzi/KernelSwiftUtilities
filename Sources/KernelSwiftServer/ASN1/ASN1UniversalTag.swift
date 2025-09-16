//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 27/09/2023.
//

import Foundation

extension KernelASN1 {
    public enum ASN1UniversalTag: Equatable, Hashable, CustomDebugStringConvertible {
        case berTerminator
        case boolean
        case integer
        case bitString
        case octetString
        case null
        case objectIdentifier
        case objectDescriptor
        case external
        case real
        case enumerated
        case embeddedPDV
        case utf8String
        case relativeOID
        case time
        case reservedFuture
        case sequence
        case set
        case numericString
        case printableString
        case t61String
        case videotexString
        case ia5String
        case utcTime
        case generalisedTime
        case graphicString
        case visibleString
        case generalString
        case universalString
        case characterString
        case bmpString
        case date
        case timeOfDay
        case dateTime
        case duration
        case i8nOID
        case relativeI8nOID
//        case any
//        
//        case primitiveTag(UInt8)
//        case constructedTag(UInt8)
//        
//        case tagged
        
//        case composite
        
        case unknown
        
        public static func == (lhs: Self, rhs: Self) -> Bool {
            String(describing: lhs) == String(describing: rhs)
        }
        
        public func hash(into hasher: inout Hasher) {
            String(describing: self).hash(into: &hasher)
        }
        
        public var debugDescription: String {
            switch self {
            case .berTerminator: ".berTerminator"
            case .boolean: ".boolean"
            case .integer: ".integer"
            case .bitString: ".bitString"
            case .octetString: ".octetString"
            case .null: ".null"
            case .objectIdentifier: ".objectIdentifier"
            case .objectDescriptor: ".objectDescriptor"
            case .external: ".external"
            case .real: ".real"
            case .enumerated: ".enumerated"
            case .embeddedPDV: ".embeddedPDV"
            case .utf8String: ".utf8String"
            case .relativeOID: ".relativeOID"
            case .time: ".time"
            case .reservedFuture: ".reservedFuture"
            case .sequence: ".sequence"
            case .set: ".set"
            case .numericString: ".numericString"
            case .printableString: ".printableString"
            case .t61String: ".t61String"
            case .videotexString: ".videotexString"
            case .ia5String: ".ia5String"
            case .utcTime: ".utcTime"
            case .generalisedTime: ".generalisedTime"
            case .graphicString: ".graphicString"
            case .visibleString: ".visibleString"
            case .generalString: ".generalString"
            case .universalString: ".universalString"
            case .characterString: ".characterString"
            case .bmpString: ".bmpString"
            case .date: ".date"
            case .timeOfDay: ".timeOfDay"
            case .dateTime: ".dateTime"
            case .duration: ".duration"
            case .i8nOID: ".i8nOID"
            case .relativeI8nOID: ".relativeI8nOID"
            case .unknown: ".unknown"
            }
        }
    }
}

extension KernelASN1.ASN1UniversalTag {
    public init(initialByte: UInt8) {
        let lowTag = initialByte & .asn1.mask.lowTagTypeMask
        self = switch lowTag {
        case .asn1.typeTag.berTerminator: .berTerminator
        case .asn1.typeTag.boolean: .boolean
        case .asn1.typeTag.integer: .integer
        case .asn1.typeTag.bitString: .bitString
        case .asn1.typeTag.octetString: .octetString
        case .asn1.typeTag.null: .null
        case .asn1.typeTag.objectIdentifier: .objectIdentifier
        case .asn1.typeTag.objectDescriptor: .objectDescriptor
        case .asn1.typeTag.external: .external
        case .asn1.typeTag.real: .real
        case .asn1.typeTag.enumerated: .enumerated
        case .asn1.typeTag.embeddedPDV: .embeddedPDV
        case .asn1.typeTag.utf8String: .utf8String
        case .asn1.typeTag.relativeOID: .relativeOID
        case .asn1.typeTag.time: .time
        case .asn1.typeTag.reservedFuture: .reservedFuture
        case .asn1.typeTag.sequence: .sequence
        case .asn1.typeTag.set: .set
        case .asn1.typeTag.numericString: .numericString
        case .asn1.typeTag.printableString: .printableString
        case .asn1.typeTag.t61String: .t61String
        case .asn1.typeTag.videotexString: .videotexString
        case .asn1.typeTag.ia5String: .ia5String
        case .asn1.typeTag.utcTime: .utcTime
        case .asn1.typeTag.generalisedTime: .generalisedTime
        case .asn1.typeTag.graphicString: .graphicString
        case .asn1.typeTag.visibleString: .visibleString
        case .asn1.typeTag.generalString: .generalString
        case .asn1.typeTag.universalString: .universalString
        case .asn1.typeTag.characterString: .characterString
        case .asn1.typeTag.bmpString: .bmpString
        case .asn1.typeTag.date: .date
        case .asn1.typeTag.timeOfDay: .timeOfDay
        case .asn1.typeTag.dateTime: .dateTime
        case .asn1.typeTag.duration: .duration
        case .asn1.typeTag.i8nOID: .i8nOID
        case .asn1.typeTag.relativeI8nOID: .relativeI8nOID
        default: .unknown
        }
    }
}

//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 15/06/2023.
//

import Foundation


extension UInt8 {
    public typealias asn1 = ASN1
    
    
    public enum ASN1 {
        public typealias typeTag = TypeTag
        public typealias mask = Mask
        public typealias `class` = Class
        
        public enum TypeTag {
            public static let berTerminator: UInt8 = 0x00
            public static let boolean: UInt8 = 0x01
            public static let integer: UInt8 = 0x02
            public static let bitString: UInt8 = 0x03
            public static let octetString: UInt8 = 0x04
            public static let null: UInt8 = 0x05
            public static let objectIdentifier: UInt8 = 0x06
            public static let objectDescriptor: UInt8 = 0x07
            public static let external: UInt8 = 0x08
            public static let real: UInt8 = 0x09
            public static let enumerated: UInt8 = 0x0a
            public static let embeddedPDV: UInt8 = 0x0b
            public static let utf8String: UInt8 = 0x0c
            public static let relativeOID: UInt8 = 0x0d
            public static let time: UInt8 = 0x0e
            public static let reservedFuture: UInt8 = 0x0f
            public static let sequence: UInt8 = 0x10
            public static let sequenceOf: UInt8 = 0x10
            public static let set: UInt8 = 0x11
            public static let setOf: UInt8 = 0x11
            public static let numericString: UInt8 = 0x12
            public static let printableString: UInt8 = 0x13
            public static let t61String: UInt8 = 0x14
            public static let videotexString: UInt8 = 0x15
            public static let ia5String: UInt8 = 0x16
            public static let utcTime: UInt8 = 0x17
            public static let generalisedTime: UInt8 = 0x18
            public static let graphicString: UInt8 = 0x19
            public static let visibleString: UInt8 = 0x1a
            public static let generalString: UInt8 = 0x1b
            public static let universalString: UInt8 = 0x1c
            public static let characterString: UInt8 = 0x1d
            public static let bmpString: UInt8 = 0x1e
            public static let date: UInt8 = 0x1f
            public static let timeOfDay: UInt8 = 0x20
            public static let dateTime: UInt8 = 0x21
            public static let duration: UInt8 = 0x22
            public static let i8nOID: UInt8 = 0x23
            public static let relativeI8nOID: UInt8 = 0x24
        }
        
        public enum Mask {
            public static let lowTagTypeMask: UInt8 = 0x1f
            public static let constructedMask: UInt8 = 0x20
            public static let classMask: UInt8 = 0xc0
            public static let contextMask: UInt8 = 0x80
            public static let multiByteMask: UInt8 = 0x7f
        }
        
        public enum Class {
            public static let universal: UInt8 = 0x00
            public static let constructed: UInt8 = 0x20
            public static let application: UInt8 = 0x40
            public static let contextSpecific: UInt8 = 0x80
            public static let `private`: UInt8 = 0xc0
        }
        
        public static let max: UInt8 = 0xff
    }
}

extension Int {
    public typealias asn1 = ASN1
    
    
    public enum ASN1 {
        public typealias typeTag = TypeTag
        public typealias mask = Mask
        public typealias `class` = Class
        
        public enum TypeTag {
            public static let boolean: Int = 0x01
            public static let integer: Int = 0x02
            public static let bitString: Int = 0x03
            public static let octetString: Int = 0x04
            public static let null: Int = 0x05
            public static let objectIdentifier: Int = 0x06
            public static let objectDescriptor: Int = 0x07
            public static let external: Int = 0x08
            public static let real: Int = 0x09
            public static let enumerated: Int = 0x0a
            public static let embeddedPDV: Int = 0x0b
            public static let utf8String: Int = 0x0c
            public static let relativeOID: Int = 0x0d
            public static let time: Int = 0x0e
            public static let sequence: Int = 0x10
            public static let sequenceOf: Int = 0x10
            public static let set: Int = 0x11
            public static let setOf: Int = 0x11
            public static let numericString: Int = 0x12
            public static let printableString: Int = 0x13
            public static let t61String: Int = 0x14
            public static let videotexString: Int = 0x15
            public static let ia5String: Int = 0x16
            public static let utcTime: Int = 0x17
            public static let generalisedTime: Int = 0x18
            public static let graphicString: Int = 0x19
            public static let visibleString: Int = 0x1a
            public static let generalString: Int = 0x1b
            public static let characterString: Int = 0x1d
            public static let bmpString: Int = 0x1e
            public static let date: Int = 0x1f
            public static let timeOfDay: Int = 0x20
            public static let dateTime: Int = 0x21
            public static let duration: Int = 0x22
        }
        
        public enum Mask {
            public static let lowTagTypeMask: Int = 0x1f
            public static let classMask: Int = 0xc0
            public static let multiByteMask: Int = 0x7f
        }
        
        public enum Class {
            public static let universal: Int = 0x00
            public static let application: Int = 0x40
            public static let contextSpecific: Int = 0x80
            
            public static let `private`: Int = 0xc0
        }
    }
}


extension KernelASN1 {
    public enum ASN1TypeTag: UInt8, Codable, Sendable {
        case boolean = 0x01
        case integer = 0x02
        case bitString = 0x03
        case octetString = 0x04
        case null = 0x05
        case objectIdentifier = 0x06
        case objectDescriptor = 0x07
        case external = 0x08
        case real = 0x09
        case enumerated = 0x0a
        case embeddedPDV = 0x0b
        case utf8String = 0x0c
        case relativeOID = 0x0d
        case time = 0x0e
        case sequence = 0x10
        case set = 0x11
        case numericString = 0x12
        case printableString = 0x13
        case t61String = 0x14
        case videotexString = 0x15
        case ia5String = 0x16
        case utcTime = 0x17
        case generalisedTime = 0x18
        case graphicString = 0x19
        case visibleString = 0x1a
        case generalString = 0x1b
        case universalString = 0x1c
        case characterString = 0x1d
        case bmpString = 0x1e
        case date = 0x1f
        case timeOfDay = 0x20
        case dateTime = 0x21
        case duration = 0x22
    }
}

extension KernelASN1.ASN1TypeTag {
    public var asn1RawType: KernelASN1.ASN1Type.RawType {
        switch self {
        case .boolean: .boolean
        case .integer: .integer
        case .bitString: .bitString
        case .octetString: .octetString
        case .null: .null
        case .objectIdentifier: .objectIdentifier
        case .objectDescriptor: .objectDescriptor
        case .external: .external
        case .real: .real
        case .enumerated: .enumerated
        case .embeddedPDV: .embeddedPDV
        case .utf8String: .utf8String
        case .relativeOID: .relativeOID
        case .time: .time
        case .sequence: .sequence
        case .set: .set
        case .numericString: .numericString
        case .printableString: .printableString
        case .t61String: .t61String
        case .videotexString: .videotexString
        case .ia5String: .ia5String
        case .utcTime: .utcTime
        case .generalisedTime: .generalisedTime
        case .graphicString: .graphicString
        case .visibleString: .visibleString
        case .generalString: .generalString
        case .universalString: .universalString
        case .characterString: .characterString
        case .bmpString: .bmpString
        case .date: .date
        case .timeOfDay: .timeOfDay
        case .dateTime: .dateTime
        case .duration: .duration
        }
    }
}

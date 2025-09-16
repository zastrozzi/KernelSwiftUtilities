//
//  File.swift
//
//
//  Created by Jonathan Forbes on 06/07/2023.
//

extension KernelASN1 {
    public enum ASN1Type: Sendable {
        case boolean(ASN1Boolean)
        case integer(ASN1Integer)
        case bitString(ASN1BitString)
        case octetString(ASN1OctetString)
        case null(ASN1Null)
        case objectIdentifier(ASN1ObjectIdentifier)
        case utf8String(ASN1UTF8String)
        indirect case sequence([ASN1Type])
        indirect case set([ASN1Type])
        //        indirect case set([ASN1Type])
        case printableString(ASN1PrintableString)
        case t61String(ASN1T61String)
        case ia5String(ASN1IA5String)
        case utcTime(ASN1UTCTime)
        case generalisedTime(ASN1GeneralisedTime)
        case graphicString(ASN1GraphicString)
        case visibleString(ASN1VisibleString)
        case generalString(ASN1GeneralString)
        case bmpString(ASN1BMPString)
        case any(ASN1Object)
        case berTerminator
        indirect case tagged(UInt, ASN1Type.TaggedType)
        //        indirect case taggedPrimitive(UInt8, ASN1Type)
        
        case unknown
    }
}

extension KernelASN1.ASN1Type {
    public enum VerboseType {
        case boolean(KernelASN1.ASN1Boolean)
        case integer(KernelASN1.ASN1Integer)
        case bitString(KernelASN1.ASN1BitString)
        case octetString(KernelASN1.ASN1OctetString)
        case null(KernelASN1.ASN1Null)
        case objectIdentifier(KernelASN1.ASN1ObjectIdentifier)
        case utf8String(KernelASN1.ASN1UTF8String)
        indirect case sequence([VerboseTypeWithMetadata])
        indirect case set([VerboseTypeWithMetadata])
        case printableString(KernelASN1.ASN1PrintableString)
        case t61String(KernelASN1.ASN1T61String)
        case ia5String(KernelASN1.ASN1IA5String)
        case utcTime(KernelASN1.ASN1UTCTime)
        case generalisedTime(KernelASN1.ASN1GeneralisedTime)
        case graphicString(KernelASN1.ASN1GraphicString)
        case visibleString(KernelASN1.ASN1VisibleString)
        case generalString(KernelASN1.ASN1GeneralString)
        case bmpString(KernelASN1.ASN1BMPString)
        case any(KernelASN1.ASN1Object)
        case berTerminator
        
        indirect case tag(resolved: UInt, constructed: Bool, item: VerboseTypeWithMetadata? = nil, items: [VerboseTypeWithMetadata]? = nil)
        //        indirect case tag(resolved: UInt8, constructed: Bool, itemNoMeta: VerboseType? = nil, items: [VerboseType]? = nil)
        //        indirect case nonConstructedTag(resolved: UInt8, item: VerboseTypeWithMetadata)
        //        indirect case taggedPrimitive(UInt8, ASN1Type)
        
        case unknown
    }
}

extension KernelASN1.ASN1Type.VerboseType {
    public func parsing(_ parsingMetadata: KernelASN1.ASN1Type.ParsingMetadata) -> KernelASN1.ASN1Type.VerboseTypeWithMetadata {
        .init(self, parsing: parsingMetadata)
    }
    
    public func writing(_ writingMetadata: KernelASN1.ASN1Type.WritingMetadata? = nil) -> KernelASN1.ASN1Type.VerboseTypeWithMetadata {
        //        let writingMetadata =
        .init(self, writing: writingMetadata ?? generateImpliedWritingMetadata())
    }
    
    public func toASN1Type() -> KernelASN1.ASN1Type {
        switch self {
        case let .boolean(value): return .boolean(value)
        case let .integer(value): return .integer(value)
        case let .bitString(value): return .bitString(value)
        case let .octetString(value): return .octetString(value)
        case let .null(value): return .null(value)
        case let .objectIdentifier(value): return .objectIdentifier(value)
        case let .utf8String(value): return .utf8String(value)
        case let .sequence(value): return .sequence(value.map { $0.type.toASN1Type() })
        case let .set(value): return .set(value.map { $0.type.toASN1Type() })
        case let .printableString(value): return .printableString(value)
        case let .t61String(value): return .t61String(value)
        case let .ia5String(value): return .ia5String(value)
        case let .utcTime(value): return .utcTime(value)
        case let .generalisedTime(value): return .generalisedTime(value)
        case let .graphicString(value): return .graphicString(value)
        case let .visibleString(value): return .visibleString(value)
        case let .generalString(value): return .generalString(value)
        case let .bmpString(value): return .bmpString(value)
        case let .any(value): return .any(value)
        case let .tag(resolved, constructed, item, items):
            if !constructed {
                guard let item else { return .unknown }
                let tagging = item.writingMetadata?.taggingMode ?? generateImpliedWritingMetadata().taggingMode
                switch tagging {
                case .explicit:
                    return .tagged(resolved, .explicit(item.asn1()))
                default:
                    return .tagged(resolved, .implicit(item.asn1()))
                }
            } else {
                if let items {
                    return .tagged(resolved, .constructed(items.map { $0.asn1() }))
                }
                else if let item {
                    return .tagged(resolved, .constructed([item.asn1() ]))
                }
                else { return .unknown }
                
            }
            
            //        case let .tag(resolved, constructed, itemNoMeta, items):
            //            if !constructed {
            //                guard let itemNoMeta else { return .unknown }
            //                return .tagged(resolved, .explicit(item.toASN1Type()))
            //            } else {
            //                if let items {
            //                    return .tagged(resolved, .constructed(items.map { $0.toASN1Type() }))
            //                }
            //                else if let item {
            //                    return .tagged(resolved, .constructed([item.toASN1Type() ]))
            //                }
            //                else { return .unknown }
            //
            //            }
        case .berTerminator: return .berTerminator
        case .unknown: return .unknown
            //        default: return .unknown
            
        }
    }
    
    func generateImpliedWritingMetadata() -> KernelASN1.ASN1Type.WritingMetadata {
        switch self {
        case .sequence: .init(constructed: true)
        case .set: .init(constructed: true)
        case .tag(_, let constructed, _, _): .init(constructed: constructed)
            //        case .tag(_, let constructed, let item) where item.self == KernelASN1.ASN1Type.VerboseType.self: .init(constructed: constructed)
            //        case .tag(_, let constructed, let item, let items) where item.self == KernelASN1.ASN1Type.VerboseTypeWithMetadata.self: .init(constructed: constructed)
        default: .init(constructed: false)
        }
    }
}

extension KernelASN1 {
    public enum ASN1TaggingMode {
        case implicit
        case explicit
        case automatic
        
        public var printDescription: String {
            switch self {
            case .implicit: "IMPLICIT"
            case .explicit: "EXPLICIT"
            case .automatic: "AUTOMATIC"
            }
        }
    }
}

extension KernelASN1.ASN1Type {
    public var rawType: RawType {
        switch self {
        case .boolean: .boolean
        case .integer: .integer
        case .bitString: .bitString
        case .octetString: .octetString
        case .null: .null
        case .objectIdentifier: .objectIdentifier
        case .printableString: .printableString
        case .utf8String: .utf8String
        case .t61String: .t61String
        case .ia5String: .ia5String
        case .graphicString: .graphicString
        case .visibleString: .visibleString
        case .generalString: .generalString
        case .bmpString: .bmpString
        case .utcTime: .utcTime
        case .generalisedTime: .generalisedTime
        case .any: .any
        case .sequence: .sequence
        case .set: .set
        case let .tagged(tag, type):
            switch type {
            case .implicit(let asn1Type):
                    .tagged(.init(tag), .implicit(asn1Type.rawType))
            case .explicit(let asn1Type):
                    .tagged(.init(tag), .explicit(asn1Type.rawType))
            case .constructed:
                    .constructedTag(.init(tag))
            }
            //                .tagged(tag)
        case .unknown: .unknown
        case .berTerminator: .berTerminator
        }
    }
}

extension KernelASN1.ASN1Type: ASN1Decodable, Equatable, Hashable {
    public init(from decoder: Decoder) throws {
        self = .null(.init())
    }
    
    public init(from asn1Type: KernelASN1.ASN1Type) throws {
        self = asn1Type
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        String(describing: lhs) == String(describing: rhs)
    }
    
    public func hash(into hasher: inout Hasher) {
        String(describing: self).hash(into: &hasher)
    }
    
    public func serialise() -> [UInt8] { KernelASN1.ASN1Writer.dataFromObject(self) }
}

extension KernelASN1.ASN1Type.ParsedType {
    public init(fromTag tag: UInt8) {
        switch tag {
        case 0x00: self = .berTerminator
        case 0x01: self = .boolean
        case 0x02: self = .integer
        case 0x03: self = .bitString
        case 0x04: self = .octetString
        case 0x05: self = .null
        case 0x06: self = .objectIdentifier
        case 0x07: self = .objectDescriptor
        case 0x08: self = .external
        case 0x09: self = .real
        case 0x0a: self = .enumerated
        case 0x0b: self = .embeddedPDV
        case 0x0c: self = .utf8String
        case 0x0d: self = .relativeOID
        case 0x0e: self = .time
        case 0x10: self = .sequence
        case 0x11: self = .set
        case 0x12: self = .numericString
        case 0x13: self = .printableString
        case 0x14: self = .t61String
        case 0x15: self = .videotexString
        case 0x16: self = .ia5String
        case 0x17: self = .utcTime
        case 0x18: self = .generalisedTime
        case 0x19: self = .graphicString
        case 0x1a: self = .visibleString
        case 0x1b: self = .generalString
        case 0x1c: self = .universalString
        case 0x1d: self = .characterString
        case 0x1e: self = .bmpString
        case 0x1f: self = .date
        case 0x20: self = .timeOfDay
        case 0x21: self = .dateTime
        case 0x22: self = .duration
        default: self = .unknown
        }
    }
}

extension KernelASN1.ASN1Type {
    public enum ParsedType: Equatable, Hashable {
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
        case any
        case tag(resolved: UInt8, contextSpecific: Bool, constructed: Bool)
        
        case berTerminator
        //        case composite
        case unknown
        
        public static func == (lhs: KernelASN1.ASN1Type.ParsedType, rhs: KernelASN1.ASN1Type.ParsedType) -> Bool {
            String(describing: lhs) == String(describing: rhs)
        }
        
        public func hash(into hasher: inout Hasher) {
            String(describing: self).hash(into: &hasher)
        }
    }
    
    public enum RawType: Equatable, Hashable {
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
        case any
        
        case primitiveTag(UInt8)
        case constructedTag(UInt8)
        
        indirect case tagged(UInt8, RawTaggedType)
        
        case composite
        case unknown
        case berTerminator
        
        public static func == (lhs: KernelASN1.ASN1Type.RawType, rhs: KernelASN1.ASN1Type.RawType) -> Bool {
            String(describing: lhs) == String(describing: rhs)
        }
        
        public func hash(into hasher: inout Hasher) {
            String(describing: self).hash(into: &hasher)
        }
    }
    
    public enum TaggedType: Sendable {
        //        case sequence([KernelASN1.ASN1Type])
        case implicit(KernelASN1.ASN1Type)
        case explicit(KernelASN1.ASN1Type)
        case constructed([KernelASN1.ASN1Type])
        //        case constructed(single: KernelASN1.ASN1Type)
        //        case constructed([KernelASN1.ASN1Type])
        //        case choice
    }
    
    public enum RawTaggedType {
        case implicit(KernelASN1.ASN1Type.RawType)
        case explicit(KernelASN1.ASN1Type.RawType)
        //        case constructed([KernelASN1.ASN1Type])
        case constructed
    }
    
    public enum ConstructedType {
        case sequence
        case set
        //        case choice
    }
}

extension KernelASN1.ASN1Type.TaggedType {
    public var unwrapped: KernelASN1.ASN1Type {
        switch self {
        case let .implicit(item): item
        case let .explicit(item): item
        case let .constructed(items): .sequence(items)
        }
    }
    
    public var raw: KernelASN1.ASN1Type.RawTaggedType {
        switch self {
        case let .implicit(type): .implicit(type.rawType)
        case let .explicit(type): .explicit(type.rawType)
            //        case let .constructed(types): .constructed(types.map { $0 })
        case .constructed: .constructed
        }
    }
}

extension KernelASN1.ASN1Type.RawType {
    public var isPrimitive: Bool {
        switch self {
        case
                .boolean, .integer, .bitString, .octetString,
                .null, .objectIdentifier, .objectDescriptor,
                .external, .real, .enumerated, .embeddedPDV,
                .utf8String, .relativeOID, .time, .numericString,
                .printableString, .t61String, .videotexString,
                .ia5String, .utcTime, .generalisedTime,
                .graphicString, .visibleString, .generalString,
                .universalString, .characterString, .bmpString,
                .date, .timeOfDay, .dateTime, .duration, .any, .unknown, .primitiveTag:
            true
        default: false
        }
    }
}

//
//  File.swift
//
//
//  Created by Jonathan Forbes on 16/07/2023.
//
import Vapor

extension KernelASN1.ASN1Type {
    public struct ParsingMetadata {
        public var id: UUID
        public var constructed: Bool
        public var offset: Int
        public var headerLength: Int
        public var contentLength: ContentLength
        public var treeLevel: Int
        public var parentId: UUID?
        
        public init(
            id: UUID = .init(),
            constructed: Bool,
            offset: Int,
            headerLength: Int,
            contentLength: ContentLength,
            treeLevel: Int,
            parentId: UUID? = nil
        ) {
            self.id = id
            self.constructed = constructed
            self.offset = offset
            self.headerLength = headerLength
            self.contentLength = contentLength
            self.treeLevel = treeLevel
            self.parentId = parentId
        }
        
        public var endIndex: Int {
            offset + headerLength + contentLength.length
        }
        
        public func printerString(_ shouldPrint: Bool = false) -> String {
            shouldPrint ? "{ Offset: \(offset), Length: \(headerLength)+\(contentLength)\(constructed ? ", C " : " ")} " : ""
        }
    }
}

extension KernelASN1.ASN1Type.ParsingMetadata {
    
    
    public enum ContentLength: Equatable {
        case determinate(Int)
        case indeterminate
        
        public var length: Int {
            switch self {
            case let .determinate(length): length
            case .indeterminate: 0
            }
        }
        
        public static func == (lhs: KernelASN1.ASN1Type.ParsingMetadata.ContentLength, rhs: KernelASN1.ASN1Type.ParsingMetadata.ContentLength) -> Bool {
            switch (lhs, rhs) {
            case (.indeterminate, .indeterminate): true
            case (.determinate, .indeterminate): false
            case (.indeterminate, .determinate): false
            case let (.determinate(lhsLength), .determinate(rhsLength)): lhsLength == rhsLength
            }
        }
    }
}

extension KernelASN1.ASN1Type {
    public struct WritingMetadata {
        public var constructed: Bool
        public var taggingMode: KernelASN1.ASN1TaggingMode?
        
        public init(
            constructed: Bool = false,
            taggingMode: KernelASN1.ASN1TaggingMode? = nil
        ) {
            self.constructed = constructed
            self.taggingMode = taggingMode
        }
        
        public func printerString(_ shouldPrint: Bool = false) -> String {
            shouldPrint && taggingMode != nil ? "{ Mode: \(taggingMode!.printDescription) } " : ""
        }
    }
}

extension KernelASN1.ASN1Type {
    public struct ParsedTypeWithMetadata {
        public var type: ParsedType
        public var metadata: ParsingMetadata
        
        public init(
            type: KernelASN1.ASN1Type.ParsedType,
            metadata: KernelASN1.ASN1Type.ParsingMetadata
        ) {
            self.type = type
            self.metadata = metadata
        }
    }
}

extension KernelASN1.ASN1Type {
    public struct VerboseTypeWithMetadata {
        public var type: VerboseType
        public var parsingMetadata: ParsingMetadata?
        public var writingMetadata: WritingMetadata?
        
        public init(
            _ type: KernelASN1.ASN1Type.VerboseType,
            parsing parsingMetadata: KernelASN1.ASN1Type.ParsingMetadata? = nil,
            writing writingMetadata: KernelASN1.ASN1Type.WritingMetadata? = nil
        ) {
            self.type = type
            self.parsingMetadata = parsingMetadata
            self.writingMetadata = writingMetadata
        }
        
        public func asn1() -> KernelASN1.ASN1Type {
            type.toASN1Type()
        }
    }
}

extension KernelASN1.ASN1Type.VerboseTypeWithMetadata {
    public func parsing(_ newParsingMetadata: KernelASN1.ASN1Type.ParsingMetadata) -> KernelASN1.ASN1Type.VerboseTypeWithMetadata {
        .init(self.type, parsing: newParsingMetadata, writing: self.writingMetadata)
    }
    
    public func writing(_ newWritingMetadata: KernelASN1.ASN1Type.WritingMetadata) -> KernelASN1.ASN1Type.VerboseTypeWithMetadata {
        .init(self.type, parsing: self.parsingMetadata, writing: newWritingMetadata)
    }
    
    public static func sequence(_ items: [Self]) -> KernelASN1.ASN1Type.VerboseType { .sequence(items) }
    public static func set(_ items: [Self]) -> KernelASN1.ASN1Type.VerboseType { .set(items) }
    public static func sequence(_ items: [KernelASN1.ASN1Type.VerboseType]) -> KernelASN1.ASN1Type.VerboseType { .sequence(items.map { .init($0, writing: $0.generateImpliedWritingMetadata()) }) }
    public static func set(_ items: [KernelASN1.ASN1Type.VerboseType]) -> KernelASN1.ASN1Type.VerboseType { .set(items.map { .init($0, writing: $0.generateImpliedWritingMetadata()) }) }
    public static func boolean(_ wrapped: KernelASN1.ASN1Boolean) -> KernelASN1.ASN1Type.VerboseType { .boolean(wrapped) }
    public static func integer(_ wrapped: KernelASN1.ASN1Integer) -> KernelASN1.ASN1Type.VerboseType { .integer(wrapped) }
    public static func bitString(_ wrapped: KernelASN1.ASN1BitString) -> KernelASN1.ASN1Type.VerboseType { .bitString(wrapped) }
    public static func octetString(_ wrapped: KernelASN1.ASN1OctetString) -> KernelASN1.ASN1Type.VerboseType { .octetString(wrapped) }
    public static func null(_ wrapped: KernelASN1.ASN1Null) -> KernelASN1.ASN1Type.VerboseType { .null(wrapped) }
    public static func objectIdentifier(_ wrapped: KernelASN1.ASN1ObjectIdentifier) -> KernelASN1.ASN1Type.VerboseType { .objectIdentifier(wrapped) }
    public static func utf8String(_ wrapped: KernelASN1.ASN1UTF8String) -> KernelASN1.ASN1Type.VerboseType { .utf8String(wrapped) }
    public static func printableString(_ wrapped: KernelASN1.ASN1PrintableString) -> KernelASN1.ASN1Type.VerboseType { .printableString(wrapped) }
    public static func t61String(_ wrapped: KernelASN1.ASN1T61String) -> KernelASN1.ASN1Type.VerboseType { .t61String(wrapped) }
    public static func ia5String(_ wrapped: KernelASN1.ASN1IA5String) -> KernelASN1.ASN1Type.VerboseType { .ia5String(wrapped) }
    public static func utcTime(_ wrapped: KernelASN1.ASN1UTCTime) -> KernelASN1.ASN1Type.VerboseType { .utcTime(wrapped) }
    public static func generalisedTime(_ wrapped: KernelASN1.ASN1GeneralisedTime) -> KernelASN1.ASN1Type.VerboseType { .generalisedTime(wrapped) }
    public static func graphicString(_ wrapped: KernelASN1.ASN1GraphicString) -> KernelASN1.ASN1Type.VerboseType { .graphicString(wrapped) }
    public static func visibleString(_ wrapped: KernelASN1.ASN1VisibleString) -> KernelASN1.ASN1Type.VerboseType { .visibleString(wrapped) }
    public static func generalString(_ wrapped: KernelASN1.ASN1GeneralString) -> KernelASN1.ASN1Type.VerboseType { .generalString(wrapped) }
    public static func bmpString(_ wrapped: KernelASN1.ASN1BMPString) -> KernelASN1.ASN1Type.VerboseType { .bmpString(wrapped) }
    public static func any(_ wrapped: KernelASN1.ASN1Object) -> KernelASN1.ASN1Type.VerboseType { .any(wrapped) }
    public static func berTerminator() -> KernelASN1.ASN1Type.VerboseType { .berTerminator }
    
    public static func tag(_ resolved: UInt, constructed: Bool, _ item: Self? = nil, _ items: [Self]? = nil) -> KernelASN1.ASN1Type.VerboseType { .tag(resolved: resolved, constructed: constructed, item: item, items: items) }
    //    public static func tag(_ resolved: UInt8, constructed: Bool, _ item: KernelASN1.ASN1Type.VerboseType? = nil, _ items: [KernelASN1.ASN1Type.VerboseType]? = nil) -> KernelASN1.ASN1Type.VerboseType { .tag(resolved: resolved, constructed: constructed, item: item?.writing(item?.generateImpliedWritingMetadata()), items: items?.map { $0.writing($0.generateImpliedWritingMetadata()) }) }
    //    public static func nonConstructedTag(_ resolved: UInt8, _ item: Self) -> KernelASN1.ASN1Type.VerboseType { .nonConstructedTag(resolved: resolved, item: item) }
    
    public func isConstructed() -> Bool {
        switch self.type {
        case .sequence: true
        case .set: true
        case .tag(_, let constructed, _, _): constructed
        default: false
        }
    }
}
//
//extension KernelASN1.ASN1Type {
//    public struct VerboseTypeWithWritingMetadata {
//        public var type: VerboseType
//        public var metadata: WritingMetadata
//
//        public init(
//            type: KernelASN1.ASN1Type.VerboseType,
//            metadata: KernelASN1.ASN1Type.WritingMetadata
//        ) {
//            self.type = type
//            self.metadata = metadata
//        }
//    }
//}

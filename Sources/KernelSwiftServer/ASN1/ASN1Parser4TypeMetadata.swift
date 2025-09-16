//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 27/09/2023.
//

import Foundation

extension KernelASN1 {
    public struct ASN1Parser4TypeMetadata: CustomDebugStringConvertible {
        public let id: UUID
        public let initialByte: UInt8
        public let rawHeaderBytes: [UInt8]
        public var offset: Int
        public var contentLength: ASN1Parser4ContentLength
//        public var resolvedContentLength: Int = 0
        public var treeLevel: ASN1Parser4TreeLevel
        private var _structuredTagBytes: [UInt8] = []
        
        public init(
            id: UUID = .init(),
            initialByte: UInt8,
            offset: Int,
            contentLength: KernelASN1.ASN1Parser4ContentLength,
            treeLevel: KernelASN1.ASN1Parser4TreeLevel
        ) {
            self.id = id
            self.initialByte = initialByte
            self.rawHeaderBytes = []
            self.offset = offset
            self.contentLength = contentLength
            self.treeLevel = treeLevel
        }
        
        public mutating func resolveContentLength(_ length: Int) {
            contentLength = .determinate(length)
        }
        
        public mutating func resolveStructuredTagBytes(_ bytes: [UInt8]) {
            _structuredTagBytes = bytes
        }
        
        public mutating func resolveContentLengthBytes(_ bytes: [UInt8]) {
            if bytes.count > 1 {
                var len: Int = 0
                for b in bytes.dropFirst() {
                    len = len << 8
                    len += Int(b)
                }
                if len > 0 { contentLength = .determinate(len) }
            } else {
                var len: Int = 0
                for b in bytes {
                    len = len << 8
                    len += Int(b)
                }
                if len > 0 { contentLength = .determinate(len) }
            }
            
            contentLengthBytes = bytes
//            _structuredTagBytes = bytes
        }
        
        public var tag: ASN1Parser4TypeTag {
            let classTag = initialByte & .asn1.mask.classMask
//            let app = classTag == .asn1.class.application
//            print("TAG", app, contextSpecific, constructed, initialByte.toHexOctetString(), classTag.toHexOctetString(), initialByte & .asn1.mask.lowTagTypeMask)
            switch classTag {
            case .asn1.class.private:
                return .private(tag: initialByte)
            case .asn1.class.application:
                return .application(tag: initialByte)
            case .asn1.class.contextSpecific:
                let maskedLowTag = initialByte & .asn1.mask.lowTagTypeMask
                if  maskedLowTag == .asn1.mask.lowTagTypeMask {
                    return .contextSpecificStructured(tagBytes: _structuredTagBytes)
                } else {
                    return .contextSpecificSimple(tag: maskedLowTag)
                }
            default: return .universal(tag: .init(initialByte: initialByte))
                
            
            
            }
        }
        
        public var contentLengthBytes: [UInt8] = []
        
        public var contextSpecific: Bool { initialByte.and(.asn1.mask.classMask, equals: .asn1.class.contextSpecific) }
        public var constructed: Bool { initialByte.and(.asn1.mask.constructedMask, equals: .asn1.class.constructed) }
        public var headerLength: Int { tag.length + contentLengthBytes.count }
        public var contentByteOffset: Int { offset + headerLength }
        public var combinedLength: Int { headerLength + contentLength.length }
        
        
        public var debugDescription: String {
            "ASN1_TYPE_METADATA:" +
                .debugPropertyTabbedNewLine(property: "id") + id.uuidString +
                .debugPropertyTabbedNewLine(property: "initialByte") + initialByte.toHexOctetString() +
                .debugPropertyTabbedNewLine(property: "offset") + "\(offset)" +
                .debugPropertyTabbedNewLine(property: "headerLength") + "\(headerLength)" +
                .debugPropertyTabbedNewLine(property: "contentLength") + contentLength.debugDescription +
//                .debugPropertyTabbedNewLine(property: "resolvedContentLength") + "\(resolvedContentLength)" +
                .debugPropertyTabbedNewLine(property: "treeLevel") + treeLevel.debugDescription +
                .debugPropertyTabbedNewLine(property: "tag") + tag.debugDescription +
                .debugPropertyTabbedNewLine(property: "contextSpecific") + contextSpecific.description +
                .debugPropertyTabbedNewLine(property: "constructed") + constructed.description +
                .debugPropertyTabbedNewLine(property: "combinedLength") + "\(combinedLength)"
            
        }
    }
}

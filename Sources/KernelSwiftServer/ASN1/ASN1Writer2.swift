//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 17/07/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelASN1 {
    public struct ASN1Writer2 {
        static func dataForContentLength(_ contentLength: Int) -> [UInt8] {
            var data2: [UInt8] = []
            switch contentLength {
            case .zero..<128:
                data2.append(.init(contentLength))
            case 128..<256:
                data2.append(contentsOf: [0x81, .init(contentLength)])
            case 256..<(256 * 256):
                data2.append(
                    contentsOf: [
                        0x82,
                        .init(contentLength >> 8),
                        .init(contentLength & 0xff)
                    ]
                )
            case (256 * 256)..<(256 * 256 * 256):
                data2.append(
                    contentsOf: [
                        0x83,
                        .init(contentLength >> 16),
                        .init((contentLength >> 8) & 0xff),
                        .init(contentLength & 0xff)
                    ]
                )
            case (256 * 256 * 256)..<(256 * 256 * 256 * 256):
                data2.append(
                    contentsOf: [
                        0x84,
                        .init(contentLength >> 24),
                        .init((contentLength >> 16) & 0xff),
                        .init((contentLength >> 8) & 0xff),
                        .init(contentLength & 0xff)
                    ]
                )
            default: break
            }
            return data2
//            if contentLength <= 0x80 { return [.init(contentLength)] }
//            else {
//                let n = Int(log2(Double(Int.safeHighestBit(contentLength))))
//                let numberOfBytes = ((n + 7) / 8) + 1
//                var trailingBytes : [UInt8] = []
//                var mask = Int(UInt8.max) << ((numberOfBytes - 1) * 8)
//                var zeroCount: Int = 0
//                for i in 0 ..< numberOfBytes
//                {
//                    let v = (contentLength & mask) >> ((numberOfBytes - i - 1) * 8)
//                    if v != 0 { trailingBytes.append(UInt8(v)) }
//                    else { zeroCount += 1 }
//                    mask = mask >> 8
//                }
//                return [UInt8(0x80 + numberOfBytes - zeroCount)] + trailingBytes
//            }
        }
        
        static func tagForObjectType(tag: UInt8, contextSpecific: Bool, constructed: Bool) -> UInt8 {
            (tag | (constructed ? .asn1.mask.constructedMask : 0) + (contextSpecific ? .asn1.class.contextSpecific : 0))
        }
        
        static func dataForObjectType(tag: UInt8, explicit: Bool, constructed: Bool, contextSpecific: Bool = false, _ content: [UInt8]) -> [UInt8] {
            
            let maskedTag = [(tag | (constructed ? .asn1.mask.constructedMask : 0) + (contextSpecific ? .asn1.class.contextSpecific : 0))]
            if contextSpecific && !explicit {
                print("implicit, contentSpecific")
                let contentLength = dataForContentLength(content.count)
                return maskedTag + contentLength + content
            } else if contextSpecific {
                print("explicit, contentSpecific")
                let innerMaskedTag = [tag | (constructed ? .asn1.mask.constructedMask : 0)]
                let innerContentLength = dataForContentLength(content.count)
                let innerContent = innerMaskedTag + innerContentLength + content
                let contentLength = dataForContentLength(innerContent.count)
                return maskedTag + contentLength + innerContent
            } else {
                let contentLength = dataForContentLength(content.count)
                return maskedTag + contentLength + content
            }
        }
        
        public static func dataFromObject(_ object: ASN1Type.VerboseTypeWithMetadata, taggingMode: ASN1TaggingMode = .explicit) throws -> [UInt8] {
            let writingMetadata = object.writingMetadata ?? .init()
            let resolvedTaggingMode = writingMetadata.taggingMode ?? taggingMode
            switch object.type {
            case .boolean(let asn1Boolean):
                return dataForObjectType(tag: .asn1.typeTag.boolean, explicit: resolvedTaggingMode == .explicit, constructed: writingMetadata.constructed, asn1Boolean.value ? [0xff] : [0x00])
            case .integer(let asn1Integer):
                return dataForObjectType(tag: .asn1.typeTag.integer, explicit: resolvedTaggingMode == .explicit, constructed: writingMetadata.constructed,  asn1Integer.data)
            case .bitString(let asn1BitString):
                return dataForObjectType(tag: .asn1.typeTag.bitString, explicit: resolvedTaggingMode == .explicit, constructed: writingMetadata.constructed, asn1BitString.writableBytes)
            case .octetString(let asn1OctetString):
                return dataForObjectType(tag: .asn1.typeTag.octetString, explicit: resolvedTaggingMode == .explicit, constructed: writingMetadata.constructed, asn1OctetString.value)
            case .null:
                return dataForObjectType(tag: .asn1.typeTag.null, explicit: resolvedTaggingMode == .explicit, constructed: writingMetadata.constructed, [])
            case .objectIdentifier(let asn1ObjectIdentifier):
                return dataForObjectType(tag: .asn1.typeTag.objectIdentifier, explicit: resolvedTaggingMode == .explicit, constructed: writingMetadata.constructed, asn1ObjectIdentifier.writableBytes)
            case .utf8String(let asn1String):
                return dataForObjectType(tag: .asn1.typeTag.utf8String, explicit: resolvedTaggingMode == .explicit, constructed: writingMetadata.constructed, asn1String.string.utf8Bytes)
            case .sequence(let array):
                switch resolvedTaggingMode {
                case .implicit:
                    let arrayContent: [UInt8] = .init(try array.map { item in
                        try dataFromObject(item, taggingMode: resolvedTaggingMode)
                    }.joined())
                    return dataForObjectType(tag: .asn1.typeTag.sequence, explicit: resolvedTaggingMode == .explicit, constructed: true, arrayContent)
                case .explicit:
                    let arrayContent: [UInt8] = .init(try array.map { item in
                        try dataFromObject(item, taggingMode: resolvedTaggingMode)
                    }.joined())
                    return dataForObjectType(tag: .asn1.typeTag.sequence, explicit: resolvedTaggingMode == .explicit, constructed: true, arrayContent)
                case .automatic:
                    let arrayHasNoTags = array.allSatisfy { if case .tag(_, _, _, _) = $0.type { false } else { true } }
                    let arrayContent: [UInt8] = .init((
                        arrayHasNoTags ?
                        try array.enumerated().map { (index, item) in
                            try dataFromObject(.tag(.init(truncatingIfNeeded: index), constructed: item.isConstructed(), item).writing(writingMetadata), taggingMode: resolvedTaggingMode)
                        } :
                        try array.map { item in
                            try dataFromObject(item, taggingMode: resolvedTaggingMode)
                        }
                    ).joined())
                    print(arrayContent.toHexString())
                    let data = dataForObjectType(tag: .asn1.typeTag.sequence, explicit: resolvedTaggingMode == .explicit, constructed: true, arrayContent)
                    print(data.toHexString())
                    return data
                    
                }
//                return dataForObjectType(tag: .asn1.typeTag.sequence, explicit: resolvedTaggingMode == .explicit, constructed: true, array.map { dataFromObject($0, taggingMode: taggingMode) }.flatMap { $0 })
            case .set(let array):
                switch resolvedTaggingMode {
                case .implicit:
                    let arrayContent: [UInt8] = .init(try array.map { item in
                        try dataFromObject(item, taggingMode: taggingMode)
                    }.joined())
                    return dataForObjectType(tag: .asn1.typeTag.set, explicit: resolvedTaggingMode == .explicit, constructed: true, arrayContent)
                case .explicit:
                    let arrayContent: [UInt8] = .init(try array.map { item in
                        try dataFromObject(item, taggingMode: taggingMode)
                    }.joined())
                    return dataForObjectType(tag: .asn1.typeTag.set, explicit: resolvedTaggingMode == .explicit, constructed: true, arrayContent)
                case .automatic:
                    let arrayHasNoTags = array.allSatisfy { if case .tag(_, _, _, _) = $0.type { false } else { true } }
                    let arrayContent: [UInt8] = .init((
                        arrayHasNoTags ?
                        try array.enumerated().map { (index, item) in
                            try dataFromObject(.tag(.init(truncatingIfNeeded: index), constructed: item.isConstructed(), item).writing(writingMetadata), taggingMode: resolvedTaggingMode)
                        } :
                            try array.map { item in
                                try dataFromObject(item, taggingMode: taggingMode)
                            }
                    ).joined())
                    return dataForObjectType(tag: .asn1.typeTag.set, explicit: resolvedTaggingMode == .explicit, constructed: true, arrayContent)
                    
                }
            case .printableString(let asn1String):
                return dataForObjectType(tag: .asn1.typeTag.printableString, explicit: resolvedTaggingMode == .explicit, constructed: writingMetadata.constructed, asn1String.string.utf8Bytes)
            case .t61String(let asn1String):
                return dataForObjectType(tag: .asn1.typeTag.t61String, explicit: resolvedTaggingMode == .explicit, constructed: writingMetadata.constructed, asn1String.string.utf8Bytes)
            case .ia5String(let asn1String):
                return dataForObjectType(tag: .asn1.typeTag.ia5String, explicit: resolvedTaggingMode == .explicit, constructed: writingMetadata.constructed, asn1String.string.utf8Bytes)
            case .utcTime(let asn1Time):
                return dataForObjectType(tag: .asn1.typeTag.utcTime, explicit: resolvedTaggingMode == .explicit, constructed: writingMetadata.constructed, asn1Time.string.utf8Bytes)
            case .generalisedTime(let asn1Time):
                return dataForObjectType(tag: .asn1.typeTag.generalisedTime, explicit: resolvedTaggingMode == .explicit, constructed: writingMetadata.constructed, asn1Time.string.utf8Bytes)
            case .graphicString(let asn1String):
                return dataForObjectType(tag: .asn1.typeTag.graphicString, explicit: resolvedTaggingMode == .explicit, constructed: writingMetadata.constructed, asn1String.string.utf8Bytes)
            case .visibleString(let asn1String):
                return dataForObjectType(tag: .asn1.typeTag.visibleString, explicit: resolvedTaggingMode == .explicit, constructed: writingMetadata.constructed, asn1String.string.utf8Bytes)
            case .generalString(let asn1String):
                return dataForObjectType(tag: .asn1.typeTag.generalString, explicit: resolvedTaggingMode == .explicit, constructed: writingMetadata.constructed, asn1String.string.utf8Bytes)
            case .bmpString(let asn1String):
                return dataForObjectType(tag: .asn1.typeTag.bmpString, explicit: resolvedTaggingMode == .explicit, constructed: writingMetadata.constructed, asn1String.string.utf8Bytes)
            case .any(let asn1Object):
                return asn1Object.anyData
            case .tag(let resolved, let constructed, let item, let items):
                let contextTag = tagForObjectType(tag: UInt8(resolved), contextSpecific: true, constructed: constructed)
                if !constructed {
                    guard items == nil, let item else { throw KernelASN1.TypedError(.writingFailed) }
                    let furtherResolvedTaggingMode = item.writingMetadata?.taggingMode ?? resolvedTaggingMode
                    switch furtherResolvedTaggingMode {
                    case .implicit:
                        let explicit = try dataFromObject(item, taggingMode: furtherResolvedTaggingMode)
                        return [contextTag] + .init(explicit.dropFirst())
                    case .explicit:
                        let explicit = try dataFromObject(item, taggingMode: furtherResolvedTaggingMode)
                        print("EXPL", explicit)
                        let contentLength = dataForContentLength(explicit.count)
                        return [(contextTag | .asn1.mask.constructedMask)] + contentLength + explicit
                    case .automatic:
                        let explicit = try dataFromObject(item, taggingMode: furtherResolvedTaggingMode)
                        return [contextTag] + .init(explicit.dropFirst())
                    }
                } else {
                    let items = items ?? ((item != nil) ? [item!] : [])
                    let arrayContent: [UInt8] = .init(try items.map { item in
                        try dataFromObject(item, taggingMode: taggingMode)
                    }.joined())
                    let contentLength = dataForContentLength(arrayContent.count)
                    return [contextTag] + contentLength + arrayContent
//                    switch resolvedTaggingMode {
//                    case .implicit:
//                        let arrayContent: [UInt8] = .init(try items.map { item in
//                            try dataFromObject(item, taggingMode: taggingMode)
//                        }.joined())
//                        let contentLength = dataForContentLength(arrayContent.count)
//                        return [contextTag] + contentLength + arrayContent
//                    case .explicit:
//                        let explicit = try dataFromObject(item, taggingMode: resolvedTaggingMode)
//                        let contentLength = dataForContentLength(explicit.count)
//                        return [contextTag] + contentLength + explicit
//                    case .automatic:
//                        let explicit = try dataFromObject(item, taggingMode: resolvedTaggingMode)
//                        return [contextTag] + .init(explicit.dropFirst())
//                    }
                }
//                if constructed { guard (items != nil && !items!.isEmpty) }
//                return dataForObjectType(tag: resolved, explicit: resolvedTaggingMode == .explicit, constructed: writingMetadata.constructed, contextSpecific: true, items.map { dataFromObject($0, taggingMode: taggingMode) }.flatMap { $0 })
//            case .nonConstructedTag(let resolved, let item):
//                return dataForObjectType(tag: resolved, explicit: resolvedTaggingMode == .explicit, constructed: false, contextSpecific: true, dataFromObject(item, taggingMode: taggingMode))
            case .unknown:
                return []
            case .berTerminator: return [0x00, 0x00]
            }
        }
    }
}

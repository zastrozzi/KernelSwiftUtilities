//
//  File.swift
//
//
//  Created by Jonathan Forbes on 18/06/2023.
//

import Foundation
import KernelSwiftCommon


extension KernelASN1 {
    
    public struct ASN1Writer {
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
//
//            if contentLength < 0x80 { return [.init(contentLength)] }
//            else {
//                let n = Int(log2(Double(Int.safeHighestBit(contentLength))))
//                let numberOfBytes = ((n + 7) / 8)
//                var data : [UInt8] = []
//                var mask = 0xff << ((numberOfBytes) * 8)
//                var zeroCount: Int = 0
//                for i in 0 ..< numberOfBytes
//                {
//                    let v = (contentLength & mask) >> ((numberOfBytes - i) * 8)
//                    if v != 0 { data.append(UInt8(v)) }
//                    else { zeroCount += 1 }
//                    mask = mask >> 8
//                }
//                let res = [UInt8(0x80 + numberOfBytes - zeroCount)] + data
//                print("CONTENT LENGTH", contentLength)
//                print("N", n)
//                print("CONTENT LENGTH BYTES", res.toHexString())
//                print("CONTENT LENGTH BYTES 2", data2.toHexString())
//                return res
//            }
        }
        
        static func dataForObjectType(tag: UInt8, _ content: [UInt8]) -> [UInt8] {
            let constructed: Bool = switch tag {
            case .asn1.typeTag.sequence, .asn1.typeTag.set: true
            default: false
            }
            let maskedTag = [tag | (constructed ? .asn1.mask.constructedMask : 0)]
            let contentLength = dataForContentLength(content.count)
            return maskedTag + contentLength + content
        }
        
        public static func dataFromObject(_ object: ASN1Type, taggingMode: ASN1TaggingMode = .explicit, implicitTag: ASN1Type.RawType? = nil) -> [UInt8] {
            switch object {
            case .boolean(let asn1Boolean):
                return [.asn1.typeTag.boolean, 0x01, asn1Boolean.value ? 0xff : 0x00]
            case .integer(let asn1Integer):
                return dataForObjectType(tag: .asn1.typeTag.integer, asn1Integer.data)
            case .bitString(let asn1BitString):
                var data: [UInt8] = [.init(asn1BitString.unusedBits)]
                if asn1BitString.unusedBits == 0 { data += asn1BitString.value }
                else {
                    let mask: UInt8 = 0xff - (UInt8(1 << asn1BitString.unusedBits) - 1)
                    data += asn1BitString.value[0..<(asn1BitString.value.count - 1)]
                    data += [asn1BitString.value[asn1BitString.value.count - 1] & mask]
                }
                
                return dataForObjectType(tag: .asn1.typeTag.bitString, data)
            case .octetString(let asn1OctetString):
                return dataForObjectType(tag: .asn1.typeTag.octetString, asn1OctetString.value)
            case .null:
                return [.asn1.typeTag.null, 0]
            case .objectIdentifier(let asn1ObjectIdentifier):
                let prefix: UInt8 = .init(asn1ObjectIdentifier.identifier[0] * 40 + asn1ObjectIdentifier.identifier[1])
                var data: [UInt8] = [prefix]
                for var v in asn1ObjectIdentifier.identifier[2..<asn1ObjectIdentifier.identifier.count] {
                    var values: [Int] = []
                    repeat {
                        values.append(v & .asn1.mask.multiByteMask)
                        v = v >> 7
                    } while v != 0
                    data += values[1..<values.count].reversed().map { .init(.asn1.class.contextSpecific | $0)}
                    data += [.init(values[0])]
                }
                return dataForObjectType(tag: .asn1.typeTag.objectIdentifier, data)
            case .printableString(let asn1String): return dataForObjectType(tag: .asn1.typeTag.printableString, asn1String.string.utf8Bytes)
            case .utf8String(let asn1String): return dataForObjectType(tag: .asn1.typeTag.utf8String, asn1String.string.utf8Bytes)
            case .ia5String(let asn1String): return dataForObjectType(tag: .asn1.typeTag.ia5String, asn1String.string.utf8Bytes)
            case .visibleString(let asn1String): return dataForObjectType(tag: .asn1.typeTag.visibleString, asn1String.string.utf8Bytes)
            case .generalString(let asn1String): return dataForObjectType(tag: .asn1.typeTag.generalString, asn1String.string.utf8Bytes)
            case .bmpString(let asn1String): return dataForObjectType(tag: .asn1.typeTag.bmpString, asn1String.string.utf8Bytes)
            case .graphicString(let asn1String): return dataForObjectType(tag: .asn1.typeTag.graphicString, asn1String.string.utf8Bytes)
            case .utcTime(let asn1Time): return dataForObjectType(tag: .asn1.typeTag.utcTime, asn1Time.string.utf8Bytes)
            case .generalisedTime(let asn1Time): return dataForObjectType(tag: .asn1.typeTag.generalisedTime, asn1Time.string.utf8Bytes)
            case .sequence(let array):
                return dataForObjectType(tag: .asn1.typeTag.sequence, array.map { dataFromObject($0, taggingMode: taggingMode, implicitTag: .sequence) }.flatMap { $0 })
            case .set(let array):
                return dataForObjectType(tag: .asn1.typeTag.set, array.map { dataFromObject($0, taggingMode: taggingMode, implicitTag: .set) }.flatMap { $0 })
            case .tagged(let tag, let taggedType):
                switch taggedType {
                case .implicit(let implicitTaggedType):
                    let implicitTag = implicitTag ?? .sequence
                    let data = dataFromObject(implicitTaggedType, taggingMode: .implicit, implicitTag: implicitTag).dropFirst()
                    let replaced =
                    //                    (implicitTag == .set || implicitTag == .sequence) ?
                    //                    (tag + .asn1.mask.constructedMask + .asn1.class.contextSpecific) :
                    (UInt8(tag) + .asn1.class.contextSpecific)
                    return [.init(replaced)] + data
                case .explicit(let explicitTaggedType):
                    return dataForObjectType(tag: UInt8(tag) + ((explicitTaggedType.rawType == .set || explicitTaggedType.rawType == .sequence) ? .asn1.mask.constructedMask : 0x00)  + .asn1.class.contextSpecific, dataFromObject(explicitTaggedType, taggingMode: taggingMode, implicitTag: implicitTag))
                case .constructed(let array):
                    //                    let constr: KernelASN1.ASN1Type = constructedType == .sequence ? .sequence(array) : .set(array)
                    return dataForObjectType(tag: UInt8(tag) + .asn1.mask.constructedMask + .asn1.class.contextSpecific, array.map { dataFromObject($0, taggingMode: taggingMode, implicitTag: .constructedTag(UInt8(tag))) }.flatMap { $0 })
                }
            default: return []
            }
        }
    }
}

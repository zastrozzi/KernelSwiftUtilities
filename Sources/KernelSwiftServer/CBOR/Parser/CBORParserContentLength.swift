//
//  File.swift
//
//
//  Created by Jonathan Forbes on 19/09/2023.
//

import Foundation

extension KernelCBOR {
    public enum CBORParserContentLength {
        case terminated
        case initialByteLength(Int)
        case lengthBytes(Int)
        case lengthItems(Int)
        case lengthByteItems(Int)
        case tagged
        case unknown
    }
}

extension KernelCBOR.CBORParserContentLength {
    public init(initialByte: UInt8) {
        self = switch initialByte {
        case _ where UInt8.cbor.initialByte.integer.contains(initialByte): .initialByteLength(0)
        case .cbor.initialByte.uint8: .initialByteLength(1)
        case .cbor.initialByte.uint16: .initialByteLength(2)
        case .cbor.initialByte.uint32: .initialByteLength(4)
        case .cbor.initialByte.uint64: .initialByteLength(8)
            
        case _ where UInt8.cbor.initialByte.negativeInteger.contains(initialByte): .initialByteLength(0)
        case .cbor.initialByte.negativeUInt8: .initialByteLength(1)
        case .cbor.initialByte.negativeUInt16: .initialByteLength(2)
        case .cbor.initialByte.negativeUInt32: .initialByteLength(4)
        case .cbor.initialByte.negativeUInt64: .initialByteLength(8)
            
        case _ where UInt8.cbor.initialByte.byteString.contains(initialByte): .initialByteLength(.init(initialByte - .cbor.initialByteMask.byteString))
        case .cbor.initialByte.byteStringUInt8Length: .lengthBytes(1)
        case .cbor.initialByte.byteStringUInt16Length: .lengthBytes(2)
        case .cbor.initialByte.byteStringUInt32Length: .lengthBytes(4)
        case .cbor.initialByte.byteStringUInt64Length: .lengthBytes(8)
        case .cbor.initialByte.byteStringWithTerminator: .terminated
            
        case _ where UInt8.cbor.initialByte.utf8String.contains(initialByte): .initialByteLength(.init(initialByte - .cbor.initialByteMask.utf8String))
        case .cbor.initialByte.utf8StringUInt8Length: .lengthBytes(1)
        case .cbor.initialByte.utf8StringUInt16Length: .lengthBytes(2)
        case .cbor.initialByte.utf8StringUInt32Length: .lengthBytes(4)
        case .cbor.initialByte.utf8StringUInt64Length: .lengthBytes(8)
        case .cbor.initialByte.utf8StringWithTerminator: .terminated
            
        case _ where UInt8.cbor.initialByte.array.contains(initialByte): .lengthItems(.init(initialByte - .cbor.initialByteMask.array))
        case .cbor.initialByte.arrayUInt8Length: .lengthByteItems(1)
        case .cbor.initialByte.arrayUInt16Length: .lengthByteItems(2)
        case .cbor.initialByte.arrayUInt32Length: .lengthByteItems(4)
        case .cbor.initialByte.arrayUInt64Length: .lengthByteItems(8)
        case .cbor.initialByte.arrayWithTerminator: .terminated
            
        case _ where UInt8.cbor.initialByte.map.contains(initialByte): .lengthItems(.init(initialByte - .cbor.initialByteMask.map))
        case .cbor.initialByte.mapUInt8Length: .lengthByteItems(1)
        case .cbor.initialByte.mapUInt16Length: .lengthByteItems(2)
        case .cbor.initialByte.mapUInt32Length: .lengthByteItems(4)
        case .cbor.initialByte.mapUInt64Length: .lengthByteItems(8)
        case .cbor.initialByte.mapWithTerminator: .terminated
            
        case .cbor.initialByte.textBasedDateTime: .tagged
        case .cbor.initialByte.epochBasedDateTime: .tagged
        case .cbor.initialByte.positiveBignum: .tagged
        case .cbor.initialByte.negativeBignum: .tagged
        case .cbor.initialByte.decimalFraction: .tagged
        case .cbor.initialByte.bigFloat: .tagged
            
        case _ where UInt8.cbor.initialByte.taggedItem.contains(initialByte): .tagged
        case _ where UInt8.cbor.initialByte.expectedConversion.contains(initialByte): .tagged
        case _ where UInt8.cbor.initialByte.moreTaggedItems.contains(initialByte): .tagged
            
        case _ where UInt8.cbor.initialByte.simpleValue.contains(initialByte): .initialByteLength(0)
        case .cbor.initialByte.false: .initialByteLength(0)
        case .cbor.initialByte.true: .initialByteLength(0)
        case .cbor.initialByte.null: .initialByteLength(0)
        case .cbor.initialByte.undefined: .initialByteLength(0)
        case .cbor.initialByte.simpleValueOneByte: .initialByteLength(1)
        case .cbor.initialByte.halfPrecisionFloat: .initialByteLength(2)
        case .cbor.initialByte.singlePrecisionFloat: .initialByteLength(4)
        case .cbor.initialByte.doublePrecisionFloat: .initialByteLength(8)
            
        case .cbor.initialByte.break: .initialByteLength(0)
            
        default: .unknown
        }
    }
}

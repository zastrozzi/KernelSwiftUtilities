//
//  File.swift
//
//
//  Created by Jonathan Forbes on 19/09/2023.
//

import Foundation

extension KernelCBOR {
    public enum CBORParserHeaderLength {
        case resolved(Int)
        case unknown
    }
}

extension KernelCBOR.CBORParserHeaderLength {
    public init(initialByte: UInt8) {
        self = switch initialByte {
        case _ where UInt8.cbor.initialByte.integer.contains(initialByte): .resolved(1)
        case .cbor.initialByte.uint8: .resolved(1)
        case .cbor.initialByte.uint16: .resolved(1)
        case .cbor.initialByte.uint32: .resolved(1)
        case .cbor.initialByte.uint64: .resolved(1)
            
        case _ where UInt8.cbor.initialByte.negativeInteger.contains(initialByte): .resolved(1)
        case .cbor.initialByte.negativeUInt8: .resolved(1)
        case .cbor.initialByte.negativeUInt16: .resolved(1)
        case .cbor.initialByte.negativeUInt32: .resolved(1)
        case .cbor.initialByte.negativeUInt64: .resolved(1)
            
        case _ where UInt8.cbor.initialByte.byteString.contains(initialByte): .resolved(1)
        case .cbor.initialByte.byteStringUInt8Length: .resolved(2)
        case .cbor.initialByte.byteStringUInt16Length: .resolved(3)
        case .cbor.initialByte.byteStringUInt32Length: .resolved(5)
        case .cbor.initialByte.byteStringUInt64Length: .resolved(9)
        case .cbor.initialByte.byteStringWithTerminator: .resolved(1)
            
        case _ where UInt8.cbor.initialByte.utf8String.contains(initialByte): .resolved(1)
        case .cbor.initialByte.utf8StringUInt8Length: .resolved(2)
        case .cbor.initialByte.utf8StringUInt16Length: .resolved(3)
        case .cbor.initialByte.utf8StringUInt32Length: .resolved(5)
        case .cbor.initialByte.utf8StringUInt64Length: .resolved(9)
        case .cbor.initialByte.utf8StringWithTerminator: .resolved(1)
            
        case _ where UInt8.cbor.initialByte.array.contains(initialByte): .resolved(1)
        case .cbor.initialByte.arrayUInt8Length: .resolved(2)
        case .cbor.initialByte.arrayUInt16Length: .resolved(3)
        case .cbor.initialByte.arrayUInt32Length: .resolved(5)
        case .cbor.initialByte.arrayUInt64Length: .resolved(9)
        case .cbor.initialByte.arrayWithTerminator: .resolved(1)
            
        case _ where UInt8.cbor.initialByte.map.contains(initialByte): .resolved(1)
        case .cbor.initialByte.mapUInt8Length: .resolved(2)
        case .cbor.initialByte.mapUInt16Length: .resolved(3)
        case .cbor.initialByte.mapUInt32Length: .resolved(5)
        case .cbor.initialByte.mapUInt64Length: .resolved(9)
        case .cbor.initialByte.mapWithTerminator: .resolved(1)
            
        case .cbor.initialByte.textBasedDateTime: .resolved(1)
        case .cbor.initialByte.epochBasedDateTime: .resolved(1)
        case .cbor.initialByte.positiveBignum: .resolved(1)
        case .cbor.initialByte.negativeBignum: .resolved(1)
        case .cbor.initialByte.decimalFraction: .resolved(1)
        case .cbor.initialByte.bigFloat: .resolved(1)
            
        case _ where UInt8.cbor.initialByte.taggedItem.contains(initialByte): .resolved(1)
        case _ where UInt8.cbor.initialByte.expectedConversion.contains(initialByte): .resolved(1)
        case _ where UInt8.cbor.initialByte.moreTaggedItems.contains(initialByte):
            switch initialByte - .cbor.initialByteMask.moreTagged {
            case 0: .resolved(2)
            case 1: .resolved(3)
            case 2: .resolved(5)
            case 3: .resolved(9)
            default: .unknown
            }
            
        case _ where UInt8.cbor.initialByte.simpleValue.contains(initialByte): .resolved(1)
        case .cbor.initialByte.false: .resolved(1)
        case .cbor.initialByte.true: .resolved(1)
        case .cbor.initialByte.null: .resolved(1)
        case .cbor.initialByte.undefined: .resolved(1)
        case .cbor.initialByte.simpleValueOneByte: .resolved(1)
        case .cbor.initialByte.halfPrecisionFloat: .resolved(1)
        case .cbor.initialByte.singlePrecisionFloat: .resolved(1)
        case .cbor.initialByte.doublePrecisionFloat: .resolved(1)
            
        case .cbor.initialByte.break: .resolved(1)
            
        default: .unknown
        }
    }
    
    public var resolvedLength: Int {
        guard case let .resolved(int) = self else { return 1 }
        return int
    }
}

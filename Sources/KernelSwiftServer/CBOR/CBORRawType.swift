//
//  File.swift
//
//
//  Created by Jonathan Forbes on 19/09/2023.
//

import Foundation


extension KernelCBOR {
    public enum CBORRawType {
        case unsignedInt
        case negativeInt
        case byteString
        case utf8String
        case array
        case map
        case tagged
        case simple
        case boolean
        case null
        case undefined
        case half
        case float
        case double
        case `break`
        case date
        
        case unknown
    }
}

extension KernelCBOR.CBORRawType {
    public init(initialByte: UInt8) {
        self = switch initialByte {
        case _ where UInt8.cbor.initialByte.integer.contains(initialByte): .unsignedInt
        case .cbor.initialByte.uint8: .unsignedInt
        case .cbor.initialByte.uint16: .unsignedInt
        case .cbor.initialByte.uint32: .unsignedInt
        case .cbor.initialByte.uint64: .unsignedInt
            
        case _ where UInt8.cbor.initialByte.negativeInteger.contains(initialByte): .negativeInt
        case .cbor.initialByte.negativeUInt8: .negativeInt
        case .cbor.initialByte.negativeUInt16: .negativeInt
        case .cbor.initialByte.negativeUInt32: .negativeInt
        case .cbor.initialByte.negativeUInt64: .negativeInt
            
        case _ where UInt8.cbor.initialByte.byteString.contains(initialByte): .byteString
        case .cbor.initialByte.byteStringUInt8Length: .byteString
        case .cbor.initialByte.byteStringUInt16Length: .byteString
        case .cbor.initialByte.byteStringUInt32Length: .byteString
        case .cbor.initialByte.byteStringUInt64Length: .byteString
        case .cbor.initialByte.byteStringWithTerminator: .byteString
            
        case _ where UInt8.cbor.initialByte.utf8String.contains(initialByte): .utf8String
        case .cbor.initialByte.utf8StringUInt8Length: .utf8String
        case .cbor.initialByte.utf8StringUInt16Length: .utf8String
        case .cbor.initialByte.utf8StringUInt32Length: .utf8String
        case .cbor.initialByte.utf8StringUInt64Length: .utf8String
        case .cbor.initialByte.utf8StringWithTerminator: .utf8String
            
        case _ where UInt8.cbor.initialByte.array.contains(initialByte): .array
        case .cbor.initialByte.arrayUInt8Length: .array
        case .cbor.initialByte.arrayUInt16Length: .array
        case .cbor.initialByte.arrayUInt32Length: .array
        case .cbor.initialByte.arrayUInt64Length: .array
        case .cbor.initialByte.arrayWithTerminator: .array
            
        case _ where UInt8.cbor.initialByte.map.contains(initialByte): .map
        case .cbor.initialByte.mapUInt8Length: .map
        case .cbor.initialByte.mapUInt16Length: .map
        case .cbor.initialByte.mapUInt32Length: .map
        case .cbor.initialByte.mapUInt64Length: .map
        case .cbor.initialByte.mapWithTerminator: .map
            
        case .cbor.initialByte.textBasedDateTime: .tagged
        case .cbor.initialByte.epochBasedDateTime: .tagged
        case .cbor.initialByte.positiveBignum: .tagged
        case .cbor.initialByte.negativeBignum: .tagged
        case .cbor.initialByte.decimalFraction: .tagged
        case .cbor.initialByte.bigFloat: .tagged
            
        case _ where UInt8.cbor.initialByte.taggedItem.contains(initialByte): .tagged
        case _ where UInt8.cbor.initialByte.expectedConversion.contains(initialByte): .tagged
        case _ where UInt8.cbor.initialByte.moreTaggedItems.contains(initialByte): .tagged
            
        case _ where UInt8.cbor.initialByte.simpleValue.contains(initialByte): .simple
        case .cbor.initialByte.false: .boolean
        case .cbor.initialByte.true: .boolean
        case .cbor.initialByte.null: .null
        case .cbor.initialByte.undefined: .undefined
        case .cbor.initialByte.simpleValueOneByte: .simple
        case .cbor.initialByte.halfPrecisionFloat: .half
        case .cbor.initialByte.singlePrecisionFloat: .float
        case .cbor.initialByte.doublePrecisionFloat: .double
            
        case .cbor.initialByte.break: .break
            
        default: .unknown
        }
    }
    
    public func initialByte(_ length: Int, truncatingIfPossible: Bool) throws -> UInt8 {
        switch self {
        case .unsignedInt:
            switch length {
            case _ where length <= UInt8.max: truncatingIfPossible ? .init(length) : .cbor.initialByte.uint8
            case _ where length <= UInt16.max: .cbor.initialByte.uint16
            case _ where length <= UInt32.max: .cbor.initialByte.uint32
            case _ where length <= UInt64.max: .cbor.initialByte.uint64
            default: .cbor.initialByte.uint64
            }
        case .negativeInt:
            switch length {
            case _ where length <= UInt8.max: truncatingIfPossible ? .init(length) + .cbor.initialByteMask.negativeInteger : .cbor.initialByte.negativeUInt8
            case _ where length <= UInt16.max: .cbor.initialByte.negativeUInt16
            case _ where length <= UInt32.max: .cbor.initialByte.negativeUInt32
            case _ where length <= UInt64.max: .cbor.initialByte.negativeUInt64
            default: .cbor.initialByte.negativeUInt64
            }
        case .byteString:
            switch length {
            case _ where length <= UInt8.max: truncatingIfPossible ? .init(length) + .cbor.initialByteMask.byteString : .cbor.initialByte.byteStringUInt8Length
            case _ where length <= UInt16.max: .cbor.initialByte.byteStringUInt16Length
            case _ where length <= UInt32.max: .cbor.initialByte.byteStringUInt32Length
            case _ where length <= UInt64.max: .cbor.initialByte.byteStringUInt64Length
            default: .cbor.initialByte.byteStringUInt64Length
            }
        case .utf8String:
            switch length {
            case _ where length <= UInt8.max: truncatingIfPossible ? .init(length) + .cbor.initialByteMask.utf8String : .cbor.initialByte.utf8StringUInt8Length
            case _ where length <= UInt16.max: .cbor.initialByte.utf8StringUInt16Length
            case _ where length <= UInt32.max: .cbor.initialByte.utf8StringUInt32Length
            case _ where length <= UInt64.max: .cbor.initialByte.utf8StringUInt64Length
            default: .cbor.initialByte.utf8StringUInt64Length
            }
        case .array:
            switch length {
            case _ where length <= UInt8.max: truncatingIfPossible ? .init(length) + .cbor.initialByteMask.array : .cbor.initialByte.arrayUInt8Length
            case _ where length <= UInt16.max: .cbor.initialByte.arrayUInt16Length
            case _ where length <= UInt32.max: .cbor.initialByte.arrayUInt32Length
            case _ where length <= UInt64.max: .cbor.initialByte.arrayUInt64Length
            default: .cbor.initialByte.arrayUInt64Length
            }
        case .map:
            switch length {
            case _ where length <= UInt8.max: truncatingIfPossible ? .init(length) + .cbor.initialByteMask.map : .cbor.initialByte.mapUInt8Length
            case _ where length <= UInt16.max: .cbor.initialByte.mapUInt16Length
            case _ where length <= UInt32.max: .cbor.initialByte.mapUInt32Length
            case _ where length <= UInt64.max: .cbor.initialByte.mapUInt64Length
            default: .cbor.initialByte.mapUInt64Length
            }
        case .null: .cbor.initialByte.null
        case .undefined: .cbor.initialByte.undefined
        case .half: .cbor.initialByte.halfPrecisionFloat
        case .float: .cbor.initialByte.singlePrecisionFloat
        case .double: .cbor.initialByte.doublePrecisionFloat
        case .break: .cbor.initialByte.break
        default: throw KernelCBOR.TypedError(.invalidType)
        }
    }
}

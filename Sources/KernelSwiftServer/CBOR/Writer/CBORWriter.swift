//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 25/09/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCBOR {
    public struct CBORWriter {
        public static func dataFromCBORType(_ type: CBORType, options: CBORCodingOptions = .init()) throws -> [UInt8] {
            switch type {
            case let .unsignedInt(unsignedInt):
                return dataFromInteger(unsignedInt, strategy: options.integerCodingStrategy)
            case let .negativeInt(negativeInt):
                var bytes = dataFromInteger(negativeInt, strategy: options.integerCodingStrategy)
                bytes[0] += .cbor.initialByteMask.negativeInteger
                return bytes
            case let .byteString(byteString):
                var bytes = try headerLengthBytes(byteString.count, rawType: .byteString, strategy: options.integerCodingStrategy)
//                print("HEADER", bytes.toHexString())
                bytes.append(contentsOf: byteString)
                return bytes
            case let .utf8String(utf8String):
                let stringBytes = utf8String.utf8
                var bytes = try headerLengthBytes(stringBytes.count, rawType: .utf8String, strategy: options.integerCodingStrategy)
                bytes.append(contentsOf: stringBytes)
                return bytes
            case let .array(array):
                var bytes = try headerLengthBytes(array.count, rawType: .array, strategy: options.integerCodingStrategy)
                for item in array { bytes.append(contentsOf: try dataFromCBORType(item, options: options)) }
                return bytes
            case let .map(dict):
                var bytes = try headerLengthBytes(dict.count, rawType: .map, strategy: options.integerCodingStrategy)
                for entry in dict {
                    bytes.append(contentsOf: try dataFromCBORType(entry.key, options: options))
                    bytes.append(contentsOf: try dataFromCBORType(entry.value, options: options))
                }
                return bytes
            case let .tagged(tag, taggedType):
                var tagBytes = dataFromInteger(tag.rawValue, strategy: .minimum(truncatingIfPossible: true))
                tagBytes[0] += .cbor.initialByteMask.tagged
                tagBytes.append(contentsOf: try dataFromCBORType(taggedType, options: options))
                return tagBytes
            case let .simple(simpleByte):
                if simpleByte < (.cbor.initialByte.false - .cbor.initialByteMask.simple) {
                    return [simpleByte + .cbor.initialByteMask.simple]
                } else {
                    return [.cbor.initialByte.simpleValueOneByte, simpleByte]
                }
            case let .boolean(bool): return bool ? [.cbor.initialByte.true] : [.cbor.initialByte.false]
            case .null: return [.cbor.initialByte.null]
            case .undefined: return [.cbor.initialByte.undefined]
            case let .half(half): return [.cbor.initialByte.halfPrecisionFloat] + half.toBigEndianByteArray()
            case let .float(float): return [.cbor.initialByte.singlePrecisionFloat] + float.toBigEndianByteArray()
            case let .double(double): return [.cbor.initialByte.doublePrecisionFloat] + double.toBigEndianByteArray()
            case .break: return [.cbor.initialByte.break]
            case .date(_):
                preconditionFailure("Not implemented")
            }
        }
        
        private static func dataFromInteger(_ value: UInt64, strategy: CBORCodingOptions.IntegerCodingStrategy) -> [UInt8] {
            var bytes: [UInt8] = []
            switch strategy {
            case let .minimum(truncatingIfPossible):
                switch value {
                case _ where value <= UInt8.max: 
                    if (value >= .cbor.initialByte.uint8 - .cbor.initialByteMask.integer) || !truncatingIfPossible { bytes.append(.cbor.initialByte.uint8) }
                    bytes.append(contentsOf: UInt8(value).toBigEndianByteArray())
                case _ where value <= UInt16.max:
                    bytes.append(.cbor.initialByte.uint16)
                    bytes.append(contentsOf: UInt16(value).toBigEndianByteArray())
                case _ where value <= UInt32.max:
                    bytes.append(.cbor.initialByte.uint32)
                    bytes.append(contentsOf: UInt32(value).toBigEndianByteArray())
                default:
                    bytes.append(.cbor.initialByte.uint64)
                    bytes.append(contentsOf: value.toBigEndianByteArray())
                }
            case .maximum:
                bytes.append(.cbor.initialByte.uint64)
                bytes.append(contentsOf: value.toBigEndianByteArray())
            case let .fixed(integerType, truncatingIfPossible):
                switch integerType {
                case is UInt8.Type:
                    if (value >= .cbor.initialByte.uint8 - .cbor.initialByteMask.integer) || !truncatingIfPossible { bytes.append(.cbor.initialByte.uint8) }
                    bytes.append(contentsOf: UInt8(value).toBigEndianByteArray())
                case is UInt16.Type:
                    bytes.append(.cbor.initialByte.uint16)
                    bytes.append(contentsOf: UInt16(value).toBigEndianByteArray())
                case is UInt32.Type:
                    bytes.append(.cbor.initialByte.uint32)
                    bytes.append(contentsOf: UInt32(value).toBigEndianByteArray())
                default:
                    bytes.append(.cbor.initialByte.uint64)
                    bytes.append(contentsOf: value.toBigEndianByteArray())
                }
            }
            return bytes
        }
        
        private static func headerLengthBytes(_ length: Int, rawType: CBORRawType, strategy: CBORCodingOptions.IntegerCodingStrategy) throws -> [UInt8] {
            var bytes: [UInt8] = []
            switch strategy {
            case let .minimum(truncatingIfPossible):
                bytes.append(try rawType.initialByte(length, truncatingIfPossible: truncatingIfPossible))
                guard [.byteString, .utf8String, .array, .map].contains(rawType) else { return bytes }
                switch length {
                case _ where length < UInt8.cbor.initialByte.uint8 && truncatingIfPossible: break
                case _ where length <= UInt8.max && !truncatingIfPossible: 
                    bytes.append(contentsOf: UInt8(length).toBigEndianByteArray())
                    break
                case _ where length <= UInt16.max:
                    bytes.append(contentsOf: UInt16(length).toBigEndianByteArray())
                    break
                case _ where length <= UInt32.max:
                    bytes.append(contentsOf: UInt32(length).toBigEndianByteArray())
                    break
                case _ where length <= UInt64.max:
                    bytes.append(contentsOf: UInt64(length).toBigEndianByteArray())
                    break
                default: break
                }
            case .maximum:
                bytes.append(try rawType.initialByte(length, truncatingIfPossible: false))
                guard [.byteString, .utf8String, .array, .map].contains(rawType) else { return bytes }
                bytes.append(contentsOf: UInt64(length).toBigEndianByteArray())
            case let .fixed(integerType, truncatingIfPossible):
                switch integerType {
                case is UInt8.Type: 
                    bytes.append(try rawType.initialByte(length, truncatingIfPossible: truncatingIfPossible))
                    guard [.byteString, .utf8String, .array, .map].contains(rawType) else { return bytes }
                    if !truncatingIfPossible { bytes.append(contentsOf: UInt8(length).toBigEndianByteArray()) }
                case is UInt16.Type: 
                    bytes.append(try rawType.initialByte(length, truncatingIfPossible: false))
                    guard [.byteString, .utf8String, .array, .map].contains(rawType) else { return bytes }
                    bytes.append(contentsOf: UInt16(length).toBigEndianByteArray())
                case is UInt32.Type:
                    bytes.append(try rawType.initialByte(length, truncatingIfPossible: false))
                    guard [.byteString, .utf8String, .array, .map].contains(rawType) else { return bytes }
                    bytes.append(contentsOf: UInt32(length).toBigEndianByteArray())
                default: 
                    bytes.append(try rawType.initialByte(length, truncatingIfPossible: false))
                    guard [.byteString, .utf8String, .array, .map].contains(rawType) else { return bytes }
                    bytes.append(contentsOf: UInt64(length).toBigEndianByteArray())
                }
            }
            return bytes
        }
    }
}

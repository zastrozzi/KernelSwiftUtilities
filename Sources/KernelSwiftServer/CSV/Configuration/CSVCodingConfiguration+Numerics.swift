//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 13/05/2023.
//

import Foundation
import Vapor
import Collections
import KernelSwiftCommon

extension KernelCSV.CSVCodingConfiguration {
    public struct NumericCodingStrategy: Codable, Equatable, Hashable, Content, OpenAPIEncodableSampleable, Sendable {
        
        
        public var digitGroupSeparator: UInt8
        public var fractionalSeparator: UInt8
        public var encodeWithDigitGroupSeparator: Bool
        
        public static let defaultStrategy: NumericCodingStrategy = .init(
            digitGroupSeparator: .ascii.comma,
            fractionalSeparator: .ascii.period,
            encodeWithDigitGroupSeparator: false
        )
        
        public init(
            digitGroupSeparator: UInt8 = .ascii.comma,
            fractionalSeparator: UInt8 = .ascii.period,
            encodeWithDigitGroupSeparator: Bool = false
        ) {
            self.digitGroupSeparator = digitGroupSeparator
            self.fractionalSeparator = fractionalSeparator
            self.encodeWithDigitGroupSeparator = encodeWithDigitGroupSeparator
        }
        
        public func bytes<I: FixedWidthInteger>(from fixedWidthInteger: I) -> [UInt8] {
            var workingInteger = fixedWidthInteger.magnitude
            var byteArray: [UInt8] = []
            var digitsProcessed: Int = 0
            while workingInteger > 0 {
                switch workingInteger % 10 {
                case 0: byteArray.insert(.ascii.zero,   at: 0)
                case 1: byteArray.insert(.ascii.one,    at: 0)
                case 2: byteArray.insert(.ascii.two,    at: 0)
                case 3: byteArray.insert(.ascii.three,  at: 0)
                case 4: byteArray.insert(.ascii.four,   at: 0)
                case 5: byteArray.insert(.ascii.five,   at: 0)
                case 6: byteArray.insert(.ascii.six,    at: 0)
                case 7: byteArray.insert(.ascii.seven,  at: 0)
                case 8: byteArray.insert(.ascii.eight,  at: 0)
                case 9: byteArray.insert(.ascii.nine,   at: 0)
                default: break
                }
                if digitsProcessed > 0 && (digitsProcessed % 3) == 0 && workingInteger > 0 && encodeWithDigitGroupSeparator {
                    byteArray.insert(digitGroupSeparator, at: 1)
                }
                digitsProcessed += 1
                workingInteger /= 10
            }
            if fixedWidthInteger < 0 { byteArray.insert(.ascii.hyphen, at: 0) }
            return byteArray
        }
        
        public func bytes(from double: Double) -> [UInt8] {
            bytes(from: double, precision: 3)
        }
        
        public func bytes(from double: Double, precision: Int = 3) -> [UInt8] {
            var workingInteger = Int(double).magnitude
            var workingFractional = modf(abs(double)).1
            var byteArray: [UInt8] = []
            var digitsProcessed: Int = 0
            var fractionalsProcessed: Int = 0
            
            while workingInteger > 0 {
                switch workingInteger % 10 {
                case 0: byteArray.insert(.ascii.zero,   at: 0)
                case 1: byteArray.insert(.ascii.one,    at: 0)
                case 2: byteArray.insert(.ascii.two,    at: 0)
                case 3: byteArray.insert(.ascii.three,  at: 0)
                case 4: byteArray.insert(.ascii.four,   at: 0)
                case 5: byteArray.insert(.ascii.five,   at: 0)
                case 6: byteArray.insert(.ascii.six,    at: 0)
                case 7: byteArray.insert(.ascii.seven,  at: 0)
                case 8: byteArray.insert(.ascii.eight,  at: 0)
                case 9: byteArray.insert(.ascii.nine,   at: 0)
                default: break
                }
                if digitsProcessed > 0 && (digitsProcessed % 3) == 0 && workingInteger > 0 && encodeWithDigitGroupSeparator {
                    byteArray.insert(digitGroupSeparator, at: 1)
                }
                digitsProcessed += 1
                workingInteger /= 10
            }
            
            if workingFractional > pow(10, Double((precision) * -1)) {
                byteArray.append(fractionalSeparator)
                while workingFractional > pow(10, Double(precision * -1)) && fractionalsProcessed < precision {
                    workingFractional *= 10
                    let workingDigit = Int(workingFractional.rounded(.toNearestOrAwayFromZero)).magnitude
                    switch workingDigit {
                    case 0: byteArray.append(.ascii.zero)
                    case 1: byteArray.append(.ascii.one)
                    case 2: byteArray.append(.ascii.two)
                    case 3: byteArray.append(.ascii.three)
                    case 4: byteArray.append(.ascii.four)
                    case 5: byteArray.append(.ascii.five)
                    case 6: byteArray.append(.ascii.six)
                    case 7: byteArray.append(.ascii.seven)
                    case 8: byteArray.append(.ascii.eight)
                    case 9: byteArray.append(.ascii.nine)
                    default: break
                    }
                    fractionalsProcessed += 1
                    workingFractional -= Double(workingDigit)
                }
            }
            if double < 0 { byteArray.insert(.ascii.hyphen, at: 0) }
            return byteArray
        }

        public func decodeInt(from bytes: Deque<UInt8>) throws -> Int { try decode(from: bytes, intPrimitive: Int.self) }
        public func decodeInt8(from bytes: Deque<UInt8>) throws -> Int8 { try decode(from: bytes, intPrimitive: Int8.self) }
        public func decodeInt16(from bytes: Deque<UInt8>) throws -> Int16 { try decode(from: bytes, intPrimitive: Int16.self) }
        public func decodeInt32(from bytes: Deque<UInt8>) throws -> Int32 { try decode(from: bytes, intPrimitive: Int32.self) }
        public func decodeInt64(from bytes: Deque<UInt8>) throws -> Int64 { try decode(from: bytes, intPrimitive: Int64.self) }
        
        public func decodeUInt(from bytes: Deque<UInt8>) throws -> UInt { try decode(from: bytes, uintPrimitive: UInt.self) }
        public func decodeUInt8(from bytes: Deque<UInt8>) throws -> UInt8 { try decode(from: bytes, uintPrimitive: UInt8.self) }
        public func decodeUInt16(from bytes: Deque<UInt8>) throws -> UInt16 { try decode(from: bytes, uintPrimitive: UInt16.self) }
        public func decodeUInt32(from bytes: Deque<UInt8>) throws -> UInt32 { try decode(from: bytes, uintPrimitive: UInt32.self) }
        public func decodeUInt64(from bytes: Deque<UInt8>) throws -> UInt64 { try decode(from: bytes, uintPrimitive: UInt64.self) }
        
        public func decodeDouble(from bytes: Deque<UInt8>) throws -> Double { try decode(from: bytes, doublePrimitive: Double.self) }
        public func decodeFloat(from bytes: Deque<UInt8>) throws -> Float { try decode(from: bytes, floatPrimitive: Float.self) }
        
        fileprivate func decode<P: SignedInteger & FixedWidthInteger>(from bytes: Deque<UInt8>, intPrimitive integerType: P.Type = P.self) throws -> P {
            let count: Int = bytes.endIndex
            var result: P = 0
            let negative = bytes.first == UInt8.ascii.hyphen
            let direction: P = negative ? -1 : 1
            var iterator: Int = negative ? bytes.startIndex + 1 : bytes.startIndex
            
            while iterator < count {
                switch bytes[iterator] {
                case UInt8.ascii.zero:           result = result &* 10
                case UInt8.ascii.one:            result = (result &* 10) &+ 1
                case UInt8.ascii.two:            result = (result &* 10) &+ 2
                case UInt8.ascii.three:          result = (result &* 10) &+ 3
                case UInt8.ascii.four:           result = (result &* 10) &+ 4
                case UInt8.ascii.five:           result = (result &* 10) &+ 5
                case UInt8.ascii.six:            result = (result &* 10) &+ 6
                case UInt8.ascii.seven:          result = (result &* 10) &+ 7
                case UInt8.ascii.eight:          result = (result &* 10) &+ 8
                case UInt8.ascii.nine:           result = (result &* 10) &+ 9
                case fractionalSeparator: iterator = count
                default: throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Could not decode \(P.self) from CSV bytes '\(bytes)'"))
                }
                iterator += 1
            }
            return result &* direction
        }
        
        fileprivate func decode<P: UnsignedInteger & FixedWidthInteger>(from bytes: Deque<UInt8>, uintPrimitive integerType: P.Type = P.self) throws -> P {
            let count: Int = bytes.endIndex
            var result: P = 0
            var iterator: Int = bytes.startIndex
            
            while iterator < count {
                switch bytes[iterator] {
                case UInt8.ascii.zero:           result = result &* 10
                case UInt8.ascii.one:            result = (result &* 10) &+ 1
                case UInt8.ascii.two:            result = (result &* 10) &+ 2
                case UInt8.ascii.three:          result = (result &* 10) &+ 3
                case UInt8.ascii.four:           result = (result &* 10) &+ 4
                case UInt8.ascii.five:           result = (result &* 10) &+ 5
                case UInt8.ascii.six:            result = (result &* 10) &+ 6
                case UInt8.ascii.seven:          result = (result &* 10) &+ 7
                case UInt8.ascii.eight:          result = (result &* 10) &+ 8
                case UInt8.ascii.nine:           result = (result &* 10) &+ 9
                case fractionalSeparator: iterator = count
                case digitGroupSeparator: break
                case .ascii.forwardSlash: break
                default: break
                }
                iterator += 1
            }
            return result
        }
        
        
        fileprivate func decode<P>(from bytes: Deque<UInt8>, floatPrimitive: P.Type = Float.self) throws -> P {
            let count: Int = bytes.endIndex
            var result: Int = 0
            var fractional: Int = 1
            var fractionalObserved = false
            let negative = bytes.first == UInt8.ascii.hyphen
            var iterator: Int = negative ? bytes.startIndex + 1 : bytes.startIndex
            
            while iterator < count {
                switch bytes[iterator] {
                case UInt8.ascii.zero:           result = result &* 10
                case UInt8.ascii.one:            result = (result &* 10) &+ 1
                case UInt8.ascii.two:            result = (result &* 10) &+ 2
                case UInt8.ascii.three:          result = (result &* 10) &+ 3
                case UInt8.ascii.four:           result = (result &* 10) &+ 4
                case UInt8.ascii.five:           result = (result &* 10) &+ 5
                case UInt8.ascii.six:            result = (result &* 10) &+ 6
                case UInt8.ascii.seven:          result = (result &* 10) &+ 7
                case UInt8.ascii.eight:          result = (result &* 10) &+ 8
                case UInt8.ascii.nine:           result = (result &* 10) &+ 9
                case fractionalSeparator:
                    guard !fractionalObserved else {
                        throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Could not decode Float from CSV bytes '\(bytes)'"))
                    }
                    fractional = try Int.pow10((count - 1 - iterator))
                    fractionalObserved = true
                case digitGroupSeparator: break
                default: throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Could not decode Float from CSV bytes '\(bytes)'"))
                }
                iterator += 1
            }
            if negative { result.negate() }
            return Float(result) / Float(fractional) as! P
        }
        
        fileprivate func decode<P>(from bytes: Deque<UInt8>, doublePrimitive: P.Type = Double.self) throws -> P {            let count: Int = bytes.endIndex
            var result: Int = 0
            var fractional: Int = 1
            var fractionalObserved = false
            let negative = bytes.first == UInt8.ascii.hyphen
            var iterator: Int = negative ? bytes.startIndex + 1 : bytes.startIndex
            
            while iterator < count {
                switch bytes[iterator] {
                case UInt8.ascii.zero:           result = result &* 10
                case UInt8.ascii.one:            result = (result &* 10) &+ 1
                case UInt8.ascii.two:            result = (result &* 10) &+ 2
                case UInt8.ascii.three:          result = (result &* 10) &+ 3
                case UInt8.ascii.four:           result = (result &* 10) &+ 4
                case UInt8.ascii.five:           result = (result &* 10) &+ 5
                case UInt8.ascii.six:            result = (result &* 10) &+ 6
                case UInt8.ascii.seven:          result = (result &* 10) &+ 7
                case UInt8.ascii.eight:          result = (result &* 10) &+ 8
                case UInt8.ascii.nine:           result = (result &* 10) &+ 9
                case UInt8.ascii.forwardSlash: break
                case fractionalSeparator:
                    guard !fractionalObserved else {
                        throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Could not decode Double from CSV bytes 3 '\(bytes)'"))
                    }
                    fractional = try Int.pow10((count - 1 - iterator))
                    fractionalObserved = true
                case digitGroupSeparator: break
                default: break
                }
                iterator += 1
            }
            if negative { result.negate() }
            return Double(result) / Double(fractional) as! P
        }
    }
}

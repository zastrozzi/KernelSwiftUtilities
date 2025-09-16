//
//  File.swift
//
//
//  Created by Jonathan Forbes on 19/09/2023.
//

import Foundation

extension UInt8 {
    public typealias cbor = CBOR
    
    public enum CBOR {
        // CONTROL
        public typealias initialByte = InitialByte
        public typealias initialByteMask = InitialByteMask
        
        public enum InitialByte {
            public static let integer: Range<UInt8> = .init(0x00...0x17)
            public static let uint8: UInt8 = 0x18
            public static let uint16: UInt8 = 0x19
            public static let uint32: UInt8 = 0x1a
            public static let uint64: UInt8 = 0x1b
            
            public static let negativeInteger: Range<UInt8> = .init(0x20...0x37)
            public static let negativeUInt8: UInt8 = 0x38
            public static let negativeUInt16: UInt8 = 0x39
            public static let negativeUInt32: UInt8 = 0x3a
            public static let negativeUInt64: UInt8 = 0x3b
            
            public static let byteString: Range<UInt8> = .init(0x40...0x57)
            public static let byteStringUInt8Length: UInt8 = 0x58
            public static let byteStringUInt16Length: UInt8 = 0x59
            public static let byteStringUInt32Length: UInt8 = 0x5a
            public static let byteStringUInt64Length: UInt8 = 0x5b
            public static let byteStringWithTerminator: UInt8 = 0x5f
            
            public static let utf8String: Range<UInt8> = .init(0x60...0x77)
            public static let utf8StringUInt8Length: UInt8 = 0x78
            public static let utf8StringUInt16Length: UInt8 = 0x79
            public static let utf8StringUInt32Length: UInt8 = 0x7a
            public static let utf8StringUInt64Length: UInt8 = 0x7b
            public static let utf8StringWithTerminator: UInt8 = 0x7f
            
            public static let array: Range<UInt8> = .init(0x80...0x97)
            public static let arrayUInt8Length: UInt8 = 0x98
            public static let arrayUInt16Length: UInt8 = 0x99
            public static let arrayUInt32Length: UInt8 = 0x9a
            public static let arrayUInt64Length: UInt8 = 0x9b
            public static let arrayWithTerminator: UInt8 = 0x9f
            
            public static let map: Range<UInt8> = .init(0xa0...0xb7)
            public static let mapUInt8Length: UInt8 = 0xb8
            public static let mapUInt16Length: UInt8 = 0xb9
            public static let mapUInt32Length: UInt8 = 0xba
            public static let mapUInt64Length: UInt8 = 0xbb
            public static let mapWithTerminator: UInt8 = 0xbf
            
            public static let textBasedDateTime: UInt8 = 0xc0
            public static let epochBasedDateTime: UInt8 = 0xc1
            public static let positiveBignum: UInt8 = 0xc2
            public static let negativeBignum: UInt8 = 0xc3
            public static let decimalFraction: UInt8 = 0xc4
            public static let bigFloat: UInt8 = 0xc5
            
            public static let taggedItem: Range<UInt8> = .init(0xc6...0xd4)
            public static let expectedConversion: Range<UInt8> = .init(0xd5...0xd7)
            public static let moreTaggedItems: Range<UInt8> = .init(0xd8...0xdb)
            
            public static let simpleValue: Range<UInt8> = .init(0xe0...0xf3)
            public static let `false`: UInt8 = 0xf4
            public static let `true`: UInt8 = 0xf5
            public static let null: UInt8 = 0xf6
            public static let undefined: UInt8 = 0xf7
            public static let simpleValueOneByte: UInt8 = 0xf8
            public static let halfPrecisionFloat: UInt8 = 0xf9
            public static let singlePrecisionFloat: UInt8 = 0xfa
            public static let doublePrecisionFloat: UInt8 = 0xfb
            
            public static let `break`: UInt8 = 0xff
        }
        
        public enum InitialByteMask {
            public static let integer: UInt8 = 0x00
            public static let negativeInteger: UInt8 = 0x20
            public static let byteString: UInt8 = 0x40
            public static let utf8String: UInt8 = 0x60
            public static let array: UInt8 = 0x80
            public static let map: UInt8 = 0xa0
            public static let tagged: UInt8 = 0xc0
            public static let moreTagged: UInt8 = 0xd8
            public static let simple: UInt8 = 0xe0
        }
    }
}

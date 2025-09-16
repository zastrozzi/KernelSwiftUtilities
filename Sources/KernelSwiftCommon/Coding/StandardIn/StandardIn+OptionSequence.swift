//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 18/11/2023.
//

import Foundation

extension UInt8.StandardIn {
    public enum OptionSequence: RawRepresentable, CaseIterable, Sendable {
        public typealias RawValue = UInt8.StandardIn
        
        case o1
        case o2
        case o3
        case o4
        case o5
        case o6
        case o7
        case o8
        case o9
        case o0
        case o_minus
        case o_equals
        case o_q
        case o_w
        case o_e
        case o_r
        case o_t
        case o_y
        case o_u
        case o_i
        case o_o
        case o_p
        case o_a
        case o_s
        case o_d
        case o_f
        case o_g
        case o_h
        case o_j
        case o_k
        case o_l
        case o_semicolon
        case o_singleQuote
        case o_backSlash
        //            case o_grave
        case o_z
        case o_x
        case o_c
        case o_v
        case o_b
        case o_n
        case o_m
        case o_comma
        case o_period
        case o_forwardSlash
        
        case none
        
        public init(rawValue: UInt8.StandardIn) {
            switch rawValue {
            case Self.opt_1, Self.nonmeta_opt_1                         : self = .o1
            case Self.opt_2, Self.nonmeta_opt_2                         : self = .o2
            case Self.opt_3, Self.nonmeta_opt_3                         : self = .o3
            case Self.opt_4, Self.nonmeta_opt_4                         : self = .o4
            case Self.opt_5, Self.nonmeta_opt_5                         : self = .o5
            case Self.opt_6, Self.nonmeta_opt_6                         : self = .o6
            case Self.opt_7, Self.nonmeta_opt_7                         : self = .o7
            case Self.opt_8, Self.nonmeta_opt_8                         : self = .o8
            case Self.opt_9, Self.nonmeta_opt_9                         : self = .o9
            case Self.opt_0, Self.nonmeta_opt_0                         : self = .o0
            case Self.opt_minus, Self.nonmeta_opt_minus                 : self = .o_minus
            case Self.opt_equals, Self.nonmeta_opt_equals               : self = .o_equals
            case Self.opt_q, Self.nonmeta_opt_q                         : self = .o_q
            case Self.opt_w, Self.nonmeta_opt_w                         : self = .o_w
            case Self.opt_e, Self.nonmeta_opt_e                         : self = .o_e
            case Self.opt_r, Self.nonmeta_opt_r                         : self = .o_r
            case Self.opt_t, Self.nonmeta_opt_t                         : self = .o_t
            case Self.opt_y, Self.nonmeta_opt_y                         : self = .o_y
            case Self.opt_u, Self.nonmeta_opt_u                         : self = .o_u
            case Self.opt_i, Self.nonmeta_opt_i                         : self = .o_i
            case Self.opt_o, Self.nonmeta_opt_o                         : self = .o_o
            case Self.opt_p, Self.nonmeta_opt_p                         : self = .o_p
            case Self.opt_a, Self.nonmeta_opt_a                         : self = .o_a
            case Self.opt_s, Self.nonmeta_opt_s                         : self = .o_s
            case Self.opt_d, Self.nonmeta_opt_d                         : self = .o_d
            case Self.opt_f, Self.nonmeta_opt_f                         : self = .o_f
            case Self.opt_g, Self.nonmeta_opt_g                         : self = .o_g
            case Self.opt_h, Self.nonmeta_opt_h                         : self = .o_h
            case Self.opt_j, Self.nonmeta_opt_j                         : self = .o_j
            case Self.opt_k, Self.nonmeta_opt_k                         : self = .o_k
            case Self.opt_l, Self.nonmeta_opt_l                         : self = .o_l
            case Self.opt_semicolon, Self.nonmeta_opt_semicolon         : self = .o_semicolon
            case Self.opt_singleQuote, Self.nonmeta_opt_singleQuote     : self = .o_singleQuote
            case Self.opt_backSlash, Self.nonmeta_opt_backSlash         : self = .o_backSlash
            case Self.opt_z, Self.nonmeta_opt_z                         : self = .o_z
            case Self.opt_x, Self.nonmeta_opt_x                         : self = .o_x
            case Self.opt_c, Self.nonmeta_opt_c                         : self = .o_c
            case Self.opt_v, Self.nonmeta_opt_v                         : self = .o_v
            case Self.opt_b, Self.nonmeta_opt_b                         : self = .o_b
            case Self.opt_n, Self.nonmeta_opt_n                         : self = .o_n
            case Self.opt_m, Self.nonmeta_opt_m                         : self = .o_m
            case Self.opt_comma, Self.nonmeta_opt_comma                 : self = .o_comma
            case Self.opt_period, Self.nonmeta_opt_period               : self = .o_period
            case Self.opt_forwardSlash, Self.nonmeta_opt_forwardSlash   : self = .o_forwardSlash
                
            default: self = .none
            }
        }
        
        public var rawValue: UInt8.StandardIn {
            switch self {
            case .o1                    : Self.opt_1
            case .o2                    : Self.opt_2
            case .o3                    : Self.opt_3
            case .o4                    : Self.opt_4
            case .o5                    : Self.opt_5
            case .o6                    : Self.opt_6
            case .o7                    : Self.opt_7
            case .o8                    : Self.opt_8
            case .o9                    : Self.opt_9
            case .o0                    : Self.opt_0
            case .o_minus               : Self.opt_minus
            case .o_equals              : Self.opt_equals
            case .o_q                   : Self.opt_q
            case .o_w                   : Self.opt_w
            case .o_e                   : Self.opt_e
            case .o_r                   : Self.opt_r
            case .o_t                   : Self.opt_t
            case .o_y                   : Self.opt_y
            case .o_u                   : Self.opt_u
            case .o_i                   : Self.opt_i
            case .o_o                   : Self.opt_o
            case .o_p                   : Self.opt_p
            case .o_a                   : Self.opt_a
            case .o_s                   : Self.opt_s
            case .o_d                   : Self.opt_d
            case .o_f                   : Self.opt_f
            case .o_g                   : Self.opt_g
            case .o_h                   : Self.opt_h
            case .o_j                   : Self.opt_j
            case .o_k                   : Self.opt_k
            case .o_l                   : Self.opt_l
            case .o_semicolon           : Self.opt_semicolon
            case .o_singleQuote         : Self.opt_singleQuote
            case .o_backSlash           : Self.opt_backSlash
                //                case Self.opt_grave         : self = .o_grave
            case .o_z                   : Self.opt_z
            case .o_x                   : Self.opt_x
            case .o_c                   : Self.opt_c
            case .o_v                   : Self.opt_v
            case .o_b                   : Self.opt_b
            case .o_n                   : Self.opt_n
            case .o_m                   : Self.opt_m
            case .o_comma               : Self.opt_comma
            case .o_period              : Self.opt_period
            case .o_forwardSlash        : Self.opt_forwardSlash
                
            case .none                  : .oneByte(.ascii.null)
            }
        }
        
        public var description: String {
            switch self {
            case .o1: "OPT+1"
            case .o2: "OPT+2"
            case .o3: "OPT+3"
            case .o4: "OPT+4"
            case .o5: "OPT+5"
            case .o6: "OPT+6"
            case .o7: "OPT+7"
            case .o8: "OPT+8"
            case .o9: "OPT+9"
            case .o0: "OPT+0"
            case .o_minus: "OPT+minus"
            case .o_equals: "OPT+equals"
            case .o_q: "OPT+q"
            case .o_w: "OPT+w"
            case .o_e: "OPT+e"
            case .o_r: "OPT+r"
            case .o_t: "OPT+t"
            case .o_y: "OPT+y"
            case .o_u: "OPT+u"
            case .o_i: "OPT+i"
            case .o_o: "OPT+o"
            case .o_p: "OPT+p"
            case .o_a: "OPT+a"
            case .o_s: "OPT+s"
            case .o_d: "OPT+d"
            case .o_f: "OPT+f"
            case .o_g: "OPT+g"
            case .o_h: "OPT+h"
            case .o_j: "OPT+j"
            case .o_k: "OPT+k"
            case .o_l: "OPT+l"
            case .o_semicolon: "OPT+semicolon"
            case .o_singleQuote: "OPT+singleQuote"
            case .o_backSlash: "OPT+backSlash"
                //                case .o_grave: "OPT+grave"
            case .o_z: "OPT+z"
            case .o_x: "OPT+x"
            case .o_c: "OPT+c"
            case .o_v: "OPT+v"
            case .o_b: "OPT+b"
            case .o_n: "OPT+n"
            case .o_m: "OPT+m"
            case .o_comma: "OPT+comma"
            case .o_period: "OPT+period"
            case .o_forwardSlash: "OPT+forwardSlash"
                
            case .none: ""
            }
        }
        
        public static let nonmeta_opt_1: UInt8.StandardIn               = .twoByte(.init(0xc2, 0xa1))
        public static let nonmeta_opt_2: UInt8.StandardIn               = .threeByte(.init(0xe2, 0x84, 0xa2))
        public static let nonmeta_opt_3: UInt8.StandardIn               = .twoByte(.init(0xc2, 0xa3))
        public static let nonmeta_opt_4: UInt8.StandardIn               = .twoByte(.init(0xc2, 0xa2))
        public static let nonmeta_opt_5: UInt8.StandardIn               = .threeByte(.init(0xe2, 0x88, 0x9e))
        public static let nonmeta_opt_6: UInt8.StandardIn               = .twoByte(.init(0xc2, 0xa7))
        public static let nonmeta_opt_7: UInt8.StandardIn               = .twoByte(.init(0xc2, 0xb6))
        public static let nonmeta_opt_8: UInt8.StandardIn               = .threeByte(.init(0xe2, 0x80, 0xa2))
        public static let nonmeta_opt_9: UInt8.StandardIn               = .twoByte(.init(0xc2, 0xaa))
        public static let nonmeta_opt_0: UInt8.StandardIn               = .twoByte(.init(0xc2, 0xba))
        public static let nonmeta_opt_minus: UInt8.StandardIn           = .threeByte(.init(0xe2, 0x80, 0x93))
        public static let nonmeta_opt_equals: UInt8.StandardIn          = .threeByte(.init(0xe2, 0x89, 0xa0))
        public static let nonmeta_opt_q: UInt8.StandardIn               = .twoByte(.init(0xc5, 0x93))
        public static let nonmeta_opt_w: UInt8.StandardIn               = .threeByte(.init(0xe2, 0x88, 0x91))
        public static let nonmeta_opt_e: UInt8.StandardIn               = .twoByte(.init(0xc2, 0xb4))
        public static let nonmeta_opt_r: UInt8.StandardIn               = .twoByte(.init(0xc2, 0xae))
        public static let nonmeta_opt_t: UInt8.StandardIn               = .threeByte(.init(0xe2, 0x80, 0xa0))
        public static let nonmeta_opt_y: UInt8.StandardIn               = .twoByte(.init(0xc2, 0xa5))
        public static let nonmeta_opt_u: UInt8.StandardIn               = .twoByte(.init(0xc2, 0xa8))
        public static let nonmeta_opt_i: UInt8.StandardIn               = .twoByte(.init(0xcb, 0x86))
        public static let nonmeta_opt_o: UInt8.StandardIn               = .twoByte(.init(0xc3, 0xb8))
        public static let nonmeta_opt_p: UInt8.StandardIn               = .twoByte(.init(0xcf, 0x80))
        public static let nonmeta_opt_leftBracket: UInt8.StandardIn     = .threeByte(.init(0xe2, 0x80, 0x9c))
        public static let nonmeta_opt_rightBracket: UInt8.StandardIn    = .threeByte(.init(0xe2, 0x80, 0x98))
        public static let nonmeta_opt_a: UInt8.StandardIn               = .twoByte(.init(0xc3, 0xa5))
        public static let nonmeta_opt_s: UInt8.StandardIn               = .twoByte(.init(0xc3, 0x9f))
        public static let nonmeta_opt_d: UInt8.StandardIn               = .threeByte(.init(0xe2, 0x88, 0x82))
        public static let nonmeta_opt_f: UInt8.StandardIn               = .twoByte(.init(0xc6, 0x92))
        public static let nonmeta_opt_g: UInt8.StandardIn               = .twoByte(.init(0xc2, 0xa9))
        public static let nonmeta_opt_h: UInt8.StandardIn               = .twoByte(.init(0xcb, 0x99))
        public static let nonmeta_opt_j: UInt8.StandardIn               = .threeByte(.init(0xe2, 0x88, 0x86))
        public static let nonmeta_opt_k: UInt8.StandardIn               = .twoByte(.init(0xcb, 0x9a))
        public static let nonmeta_opt_l: UInt8.StandardIn               = .twoByte(.init(0xc2, 0xac))
        public static let nonmeta_opt_semicolon: UInt8.StandardIn       = .threeByte(.init(0xe2, 0x80, 0xa6))
        public static let nonmeta_opt_singleQuote: UInt8.StandardIn     = .twoByte(.init(0xc3, 0xa6))
        public static let nonmeta_opt_backSlash: UInt8.StandardIn       = .twoByte(.init(0xc2, 0xab))
        //            public static let opt_grave: StandardIn         = .twoByte(.init(0xc2, 0xaa))
        public static let nonmeta_opt_z: UInt8.StandardIn               = .twoByte(.init(0xce, 0xa9))
        public static let nonmeta_opt_x: UInt8.StandardIn               = .threeByte(.init(0xe2, 0x89, 0x88))
        public static let nonmeta_opt_c: UInt8.StandardIn               = .twoByte(.init(0xc3, 0xa7))
        public static let nonmeta_opt_v: UInt8.StandardIn               = .threeByte(.init(0xe2, 0x88, 0x9a))
        public static let nonmeta_opt_b: UInt8.StandardIn               = .threeByte(.init(0xe2, 0x88, 0xab))
        public static let nonmeta_opt_n: UInt8.StandardIn               = .twoByte(.init(0xcb, 0x9c))
        public static let nonmeta_opt_m: UInt8.StandardIn               = .twoByte(.init(0xc2, 0xb5))
        public static let nonmeta_opt_comma: UInt8.StandardIn           = .threeByte(.init(0xe2, 0x89, 0xa4))
        public static let nonmeta_opt_period: UInt8.StandardIn          = .threeByte(.init(0xe2, 0x89, 0xa5))
        public static let nonmeta_opt_forwardSlash: UInt8.StandardIn    = .twoByte(.init(0xc3, 0xb7))
        
        public static let opt_1: UInt8.StandardIn               = .escaped(.oneByte(.ascii.one))
        public static let opt_2: UInt8.StandardIn               = .escaped(.oneByte(.ascii.two))
        public static let opt_3: UInt8.StandardIn               = .escaped(.oneByte(.ascii.three))
        public static let opt_4: UInt8.StandardIn               = .escaped(.oneByte(.ascii.four))
        public static let opt_5: UInt8.StandardIn               = .escaped(.oneByte(.ascii.five))
        public static let opt_6: UInt8.StandardIn               = .escaped(.oneByte(.ascii.six))
        public static let opt_7: UInt8.StandardIn               = .escaped(.oneByte(.ascii.seven))
        public static let opt_8: UInt8.StandardIn               = .escaped(.oneByte(.ascii.eight))
        public static let opt_9: UInt8.StandardIn               = .escaped(.oneByte(.ascii.nine))
        public static let opt_0: UInt8.StandardIn               = .escaped(.oneByte(.ascii.zero))
        public static let opt_minus: UInt8.StandardIn           = .escaped(.oneByte(.ascii.hyphen))
        public static let opt_equals: UInt8.StandardIn          = .escaped(.oneByte(.ascii.equals))
        public static let opt_q: UInt8.StandardIn               = .escaped(.oneByte(.ascii.q))
        public static let opt_w: UInt8.StandardIn               = .escaped(.oneByte(.ascii.w))
        public static let opt_e: UInt8.StandardIn               = .escaped(.oneByte(.ascii.e))
        public static let opt_r: UInt8.StandardIn               = .escaped(.oneByte(.ascii.r))
        public static let opt_t: UInt8.StandardIn               = .escaped(.oneByte(.ascii.t))
        public static let opt_y: UInt8.StandardIn               = .escaped(.oneByte(.ascii.y))
        public static let opt_u: UInt8.StandardIn               = .escaped(.oneByte(.ascii.u))
        public static let opt_i: UInt8.StandardIn               = .escaped(.oneByte(.ascii.i))
        public static let opt_o: UInt8.StandardIn               = .escaped(.oneByte(.ascii.o))
        public static let opt_p: UInt8.StandardIn               = .escaped(.oneByte(.ascii.p))
        public static let opt_a: UInt8.StandardIn               = .escaped(.oneByte(.ascii.a))
        public static let opt_s: UInt8.StandardIn               = .escaped(.oneByte(.ascii.s))
        public static let opt_d: UInt8.StandardIn               = .escaped(.oneByte(.ascii.d))
        public static let opt_f: UInt8.StandardIn               = .escaped(.oneByte(.ascii.f))
        public static let opt_g: UInt8.StandardIn               = .escaped(.oneByte(.ascii.g))
        public static let opt_h: UInt8.StandardIn               = .escaped(.oneByte(.ascii.h))
        public static let opt_j: UInt8.StandardIn               = .escaped(.oneByte(.ascii.j))
        public static let opt_k: UInt8.StandardIn               = .escaped(.oneByte(.ascii.k))
        public static let opt_l: UInt8.StandardIn               = .escaped(.oneByte(.ascii.l))
        public static let opt_semicolon: UInt8.StandardIn       = .escaped(.oneByte(.ascii.semicolon))
        public static let opt_singleQuote: UInt8.StandardIn     = .escaped(.oneByte(.ascii.singleQuote))
        public static let opt_backSlash: UInt8.StandardIn       = .escaped(.oneByte(.ascii.backSlash))
        //            public static let opt_grave: StandardIn         = .twoByte(.init(0xc2, 0xaa))
        public static let opt_z: UInt8.StandardIn               = .escaped(.oneByte(.ascii.z))
        public static let opt_x: UInt8.StandardIn               = .escaped(.oneByte(.ascii.x))
        public static let opt_c: UInt8.StandardIn               = .escaped(.oneByte(.ascii.c))
        public static let opt_v: UInt8.StandardIn               = .escaped(.oneByte(.ascii.v))
        public static let opt_b: UInt8.StandardIn               = .escaped(.oneByte(.ascii.b))
        public static let opt_n: UInt8.StandardIn               = .escaped(.oneByte(.ascii.n))
        public static let opt_m: UInt8.StandardIn               = .escaped(.oneByte(.ascii.m))
        public static let opt_comma: UInt8.StandardIn           = .escaped(.oneByte(.ascii.comma))
        public static let opt_period: UInt8.StandardIn          = .escaped(.oneByte(.ascii.period))
        public static let opt_forwardSlash: UInt8.StandardIn    = .escaped(.oneByte(.ascii.forwardSlash))
        
        nonisolated(unsafe) public static var allCasesStdIn: [UInt8.StandardIn] = [
            opt_0,  opt_1,  opt_2,  opt_3,  opt_4,  opt_5,  opt_6,  opt_7,      opt_8,      opt_9,          opt_0,              opt_minus,      opt_equals,
            opt_q,  opt_w,  opt_e,  opt_r,  opt_t,  opt_y,  opt_u,  opt_i,      opt_o,      opt_p,          //opt_leftBracket,    opt_rightBracket,
            opt_a,  opt_s,  opt_d,  opt_f,  opt_g,  opt_h,  opt_j,  opt_k,      opt_l,      opt_semicolon,  opt_singleQuote,    opt_backSlash,
            opt_z,  opt_x,  opt_c,  opt_v,  opt_b,  opt_n,  opt_m,  opt_comma,  opt_period, opt_forwardSlash,
            
            nonmeta_opt_0,  nonmeta_opt_1,  nonmeta_opt_2,  nonmeta_opt_3,  nonmeta_opt_4,  
            nonmeta_opt_5,  nonmeta_opt_6,  nonmeta_opt_7,  nonmeta_opt_8,  nonmeta_opt_9,
            nonmeta_opt_0,  nonmeta_opt_minus,              nonmeta_opt_equals,
            nonmeta_opt_q,  nonmeta_opt_w,  nonmeta_opt_e,  nonmeta_opt_r,  nonmeta_opt_t,
            nonmeta_opt_y,  nonmeta_opt_u,  nonmeta_opt_i,  nonmeta_opt_o,  nonmeta_opt_p,
            nonmeta_opt_a,  nonmeta_opt_s,  nonmeta_opt_d,  nonmeta_opt_f,  nonmeta_opt_g,
            nonmeta_opt_h,  nonmeta_opt_j,  nonmeta_opt_k,  nonmeta_opt_l,  nonmeta_opt_semicolon,
            nonmeta_opt_singleQuote,        nonmeta_opt_backSlash,
            nonmeta_opt_z,  nonmeta_opt_x,  nonmeta_opt_c,  nonmeta_opt_v,  nonmeta_opt_b,
            nonmeta_opt_n,  nonmeta_opt_m,
            nonmeta_opt_comma,  nonmeta_opt_period, nonmeta_opt_forwardSlash
        ]
    }
}

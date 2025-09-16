//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 15/10/2023.
//

import Foundation

extension UInt8 {
    public typealias val = ConstantValues
    
    public static let one   : UInt8 = val.base10.one
    public static let two   : UInt8 = val.base10.two
    public static let three : UInt8 = val.base10.three
    public static let four  : UInt8 = val.base10.four
    public static let five  : UInt8 = val.base10.five
    public static let six   : UInt8 = val.base10.six
    public static let seven : UInt8 = val.base10.seven
    public static let eight : UInt8 = val.base10.eight
    public static let nine  : UInt8 = val.base10.nine
    
    public enum ConstantValues {
        public typealias base10 = Base10ConstantValues
        public typealias base16 = Base16ConstantValues
        
        public enum Base10ConstantValues {
            public static let zero                      : UInt8 = 0x00; public static let ten                       : UInt8 = 0x0a
            public static let one                       : UInt8 = 0x01; public static let eleven                    : UInt8 = 0x0b
            public static let two                       : UInt8 = 0x02; public static let twelve                    : UInt8 = 0x0c
            public static let three                     : UInt8 = 0x03; public static let thirteen                  : UInt8 = 0x0d
            public static let four                      : UInt8 = 0x04; public static let fourteen                  : UInt8 = 0x0e
            public static let five                      : UInt8 = 0x05; public static let fifteen                   : UInt8 = 0x0f
            public static let six                       : UInt8 = 0x06; public static let sixteen                   : UInt8 = 0x10
            public static let seven                     : UInt8 = 0x07; public static let seventeen                 : UInt8 = 0x11
            public static let eight                     : UInt8 = 0x08; public static let eighteen                  : UInt8 = 0x12
            public static let nine                      : UInt8 = 0x09; public static let nineteen                  : UInt8 = 0x13
            
            public static let twenty                    : UInt8 = 0x14; public static let thirty                    : UInt8 = 0x1e
            public static let twentyOne                 : UInt8 = 0x15; public static let thirtyOne                 : UInt8 = 0x1f
            public static let twentyTwo                 : UInt8 = 0x16; public static let thirtyTwo                 : UInt8 = 0x20
            public static let twentyThree               : UInt8 = 0x17; public static let thirtyThree               : UInt8 = 0x21
            public static let twentyFour                : UInt8 = 0x18; public static let thirtyFour                : UInt8 = 0x22
            public static let twentyFive                : UInt8 = 0x19; public static let thirtyFive                : UInt8 = 0x23
            public static let twentySix                 : UInt8 = 0x1a; public static let thirtySix                 : UInt8 = 0x24
            public static let twentySeven               : UInt8 = 0x1b; public static let thirtySeven               : UInt8 = 0x25
            public static let twentyEight               : UInt8 = 0x1c; public static let thirtyEight               : UInt8 = 0x26
            public static let twentyNine                : UInt8 = 0x1d; public static let thirtyNine                : UInt8 = 0x27
            
            public static let forty                     : UInt8 = 0x28; public static let fifty                     : UInt8 = 0x32
            public static let fortyOne                  : UInt8 = 0x29; public static let fiftyOne                  : UInt8 = 0x33
            public static let fortyTwo                  : UInt8 = 0x2a; public static let fiftyTwo                  : UInt8 = 0x34
            public static let fortyThree                : UInt8 = 0x2b; public static let fiftyThree                : UInt8 = 0x35
            public static let fortyFour                 : UInt8 = 0x2c; public static let fiftyFour                 : UInt8 = 0x36
            public static let fortyFive                 : UInt8 = 0x2d; public static let fiftyFive                 : UInt8 = 0x37
            public static let fortySix                  : UInt8 = 0x2e; public static let fiftySix                  : UInt8 = 0x38
            public static let fortySeven                : UInt8 = 0x2f; public static let fiftySeven                : UInt8 = 0x39
            public static let fortyEight                : UInt8 = 0x30; public static let fiftyEight                : UInt8 = 0x3a
            public static let fortyNine                 : UInt8 = 0x31; public static let fiftyNine                 : UInt8 = 0x3b
            
            public static let sixty                     : UInt8 = 0x3c; public static let seventy                   : UInt8 = 0x46
            public static let sixtyOne                  : UInt8 = 0x3d; public static let seventyOne                : UInt8 = 0x47
            public static let sixtyTwo                  : UInt8 = 0x3e; public static let seventyTwo                : UInt8 = 0x48
            public static let sixtyThree                : UInt8 = 0x3f; public static let seventyThree              : UInt8 = 0x49
            public static let sixtyFour                 : UInt8 = 0x40; public static let seventyFour               : UInt8 = 0x4a
            public static let sixtyFive                 : UInt8 = 0x41; public static let seventyFive               : UInt8 = 0x4b
            public static let sixtySix                  : UInt8 = 0x42; public static let seventySix                : UInt8 = 0x4c
            public static let sixtySeven                : UInt8 = 0x43; public static let seventySeven              : UInt8 = 0x4d
            public static let sixtyEight                : UInt8 = 0x44; public static let seventyEight              : UInt8 = 0x4e
            public static let sixtyNine                 : UInt8 = 0x45; public static let seventyNine               : UInt8 = 0x4f
            
            public static let eighty                    : UInt8 = 0x50; public static let ninety                    : UInt8 = 0x5a
            public static let eightyOne                 : UInt8 = 0x51; public static let ninetyOne                 : UInt8 = 0x5b
            public static let eightyTwo                 : UInt8 = 0x52; public static let ninetyTwo                 : UInt8 = 0x5c
            public static let eightyThree               : UInt8 = 0x53; public static let ninetyThree               : UInt8 = 0x5d
            public static let eightyFour                : UInt8 = 0x54; public static let ninetyFour                : UInt8 = 0x5e
            public static let eightyFive                : UInt8 = 0x55; public static let ninetyFive                : UInt8 = 0x5f
            public static let eightySix                 : UInt8 = 0x56; public static let ninetySix                 : UInt8 = 0x60
            public static let eightySeven               : UInt8 = 0x57; public static let ninetySeven               : UInt8 = 0x61
            public static let eightyEight               : UInt8 = 0x58; public static let ninetyEight               : UInt8 = 0x62
            public static let eightyNine                : UInt8 = 0x59; public static let ninetyNine                : UInt8 = 0x63
            
            public static let oneHundred                : UInt8 = 0x64; public static let oneHundredTen             : UInt8 = 0x6e
            public static let oneHundredOne             : UInt8 = 0x65; public static let oneHundredEleven          : UInt8 = 0x6f
            public static let oneHundredTwo             : UInt8 = 0x66; public static let oneHundredTwelve          : UInt8 = 0x70
            public static let oneHundredThree           : UInt8 = 0x67; public static let oneHundredThirteen        : UInt8 = 0x71
            public static let oneHundredFour            : UInt8 = 0x68; public static let oneHundredFourteen        : UInt8 = 0x72
            public static let oneHundredFive            : UInt8 = 0x69; public static let oneHundredFifteen         : UInt8 = 0x73
            public static let oneHundredSix             : UInt8 = 0x6a; public static let oneHundredSixteen         : UInt8 = 0x74
            public static let oneHundredSeven           : UInt8 = 0x6b; public static let oneHundredSeventeen       : UInt8 = 0x75
            public static let oneHundredEight           : UInt8 = 0x6c; public static let oneHundredEighteen        : UInt8 = 0x76
            public static let oneHundredNine            : UInt8 = 0x6d; public static let oneHundredNineteen        : UInt8 = 0x77
            
            public static let oneHundredTwenty          : UInt8 = 0x78; public static let oneHundredThirty          : UInt8 = 0x82
            public static let oneHundredTwentyOne       : UInt8 = 0x79; public static let oneHundredThirtyOne       : UInt8 = 0x83
            public static let oneHundredTwentyTwo       : UInt8 = 0x7a; public static let oneHundredThirtyTwo       : UInt8 = 0x84
            public static let oneHundredTwentyThree     : UInt8 = 0x7b; public static let oneHundredThirtyThree     : UInt8 = 0x85
            public static let oneHundredTwentyFour      : UInt8 = 0x7c; public static let oneHundredThirtyFour      : UInt8 = 0x86
            public static let oneHundredTwentyFive      : UInt8 = 0x7d; public static let oneHundredThirtyFive      : UInt8 = 0x87
            public static let oneHundredTwentySix       : UInt8 = 0x7e; public static let oneHundredThirtySix       : UInt8 = 0x88
            public static let oneHundredTwentySeven     : UInt8 = 0x7f; public static let oneHundredThirtySeven     : UInt8 = 0x89
            public static let oneHundredTwentyEight     : UInt8 = 0x80; public static let oneHundredThirtyEight     : UInt8 = 0x8a
            public static let oneHundredTwentyNine      : UInt8 = 0x81; public static let oneHundredThirtyNine      : UInt8 = 0x8b
            
            public static let oneHundredForty           : UInt8 = 0x8c; public static let oneHundredFifty           : UInt8 = 0x96
            public static let oneHundredFortyOne        : UInt8 = 0x8d; public static let oneHundredFiftyOne        : UInt8 = 0x97
            public static let oneHundredFortyTwo        : UInt8 = 0x8e; public static let oneHundredFiftyTwo        : UInt8 = 0x98
            public static let oneHundredFortyThree      : UInt8 = 0x8f; public static let oneHundredFiftyThree      : UInt8 = 0x99
            public static let oneHundredFortyFour       : UInt8 = 0x90; public static let oneHundredFiftyFour       : UInt8 = 0x9a
            public static let oneHundredFortyFive       : UInt8 = 0x91; public static let oneHundredFiftyFive       : UInt8 = 0x9b
            public static let oneHundredFortySix        : UInt8 = 0x92; public static let oneHundredFiftySix        : UInt8 = 0x9c
            public static let oneHundredFortySeven      : UInt8 = 0x93; public static let oneHundredFiftySeven      : UInt8 = 0x9d
            public static let oneHundredFortyEight      : UInt8 = 0x94; public static let oneHundredFiftyEight      : UInt8 = 0x9e
            public static let oneHundredFortyNine       : UInt8 = 0x95; public static let oneHundredFiftyNine       : UInt8 = 0x9f
            
            public static let oneHundredSixty           : UInt8 = 0xa0; public static let oneHundredSeventy         : UInt8 = 0xaa
            public static let oneHundredSixtyOne        : UInt8 = 0xa1; public static let oneHundredSeventyOne      : UInt8 = 0xab
            public static let oneHundredSixtyTwo        : UInt8 = 0xa2; public static let oneHundredSeventyTwo      : UInt8 = 0xac
            public static let oneHundredSixtyThree      : UInt8 = 0xa3; public static let oneHundredSeventyThree    : UInt8 = 0xad
            public static let oneHundredSixtyFour       : UInt8 = 0xa4; public static let oneHundredSeventyFour     : UInt8 = 0xae
            public static let oneHundredSixtyFive       : UInt8 = 0xa5; public static let oneHundredSeventyFive     : UInt8 = 0xaf
            public static let oneHundredSixtySix        : UInt8 = 0xa6; public static let oneHundredSeventySix      : UInt8 = 0xb0
            public static let oneHundredSixtySeven      : UInt8 = 0xa7; public static let oneHundredSeventySeven    : UInt8 = 0xb1
            public static let oneHundredSixtyEight      : UInt8 = 0xa8; public static let oneHundredSeventyEight    : UInt8 = 0xb2
            public static let oneHundredSixtyNine       : UInt8 = 0xa9; public static let oneHundredSeventyNine     : UInt8 = 0xb3
            
            public static let oneHundredEighty          : UInt8 = 0xb4; public static let oneHundredNinety          : UInt8 = 0xbe
            public static let oneHundredEightyOne       : UInt8 = 0xb5; public static let oneHundredNinetyOne       : UInt8 = 0xbf
            public static let oneHundredEightyTwo       : UInt8 = 0xb6; public static let oneHundredNinetyTwo       : UInt8 = 0xc0
            public static let oneHundredEightyThree     : UInt8 = 0xb7; public static let oneHundredNinetyThree     : UInt8 = 0xc1
            public static let oneHundredEightyFour      : UInt8 = 0xb8; public static let oneHundredNinetyFour      : UInt8 = 0xc2
            public static let oneHundredEightyFive      : UInt8 = 0xb9; public static let oneHundredNinetyFive      : UInt8 = 0xc3
            public static let oneHundredEightySix       : UInt8 = 0xba; public static let oneHundredNinetySix       : UInt8 = 0xc4
            public static let oneHundredEightySeven     : UInt8 = 0xbb; public static let oneHundredNinetySeven     : UInt8 = 0xc5
            public static let oneHundredEightyEight     : UInt8 = 0xbc; public static let oneHundredNinetyEight     : UInt8 = 0xc6
            public static let oneHundredEightyNine      : UInt8 = 0xbd; public static let oneHundredNinetyNine      : UInt8 = 0xc7
            
            public static let twoHundred                : UInt8 = 0xc8; public static let twoHundredTen             : UInt8 = 0xd2
            public static let twoHundredOne             : UInt8 = 0xc9; public static let twoHundredEleven          : UInt8 = 0xd3
            public static let twoHundredTwo             : UInt8 = 0xca; public static let twoHundredTwelve          : UInt8 = 0xd4
            public static let twoHundredThree           : UInt8 = 0xcb; public static let twoHundredThirteen        : UInt8 = 0xd5
            public static let twoHundredFour            : UInt8 = 0xcc; public static let twoHundredFourteen        : UInt8 = 0xd6
            public static let twoHundredFive            : UInt8 = 0xcd; public static let twoHundredFifteen         : UInt8 = 0xd7
            public static let twoHundredSix             : UInt8 = 0xce; public static let twoHundredSixteen         : UInt8 = 0xd8
            public static let twoHundredSeven           : UInt8 = 0xcf; public static let twoHundredSeventeen       : UInt8 = 0xd9
            public static let twoHundredEight           : UInt8 = 0xd0; public static let twoHundredEighteen        : UInt8 = 0xda
            public static let twoHundredNine            : UInt8 = 0xd1; public static let twoHundredNineteen        : UInt8 = 0xdb
            
            public static let twoHundredTwenty          : UInt8 = 0xdc; public static let twoHundredThirty          : UInt8 = 0xe6
            public static let twoHundredTwentyOne       : UInt8 = 0xdd; public static let twoHundredThirtyOne       : UInt8 = 0xe7
            public static let twoHundredTwentyTwo       : UInt8 = 0xde; public static let twoHundredThirtyTwo       : UInt8 = 0xe8
            public static let twoHundredTwentyThree     : UInt8 = 0xdf; public static let twoHundredThirtyThree     : UInt8 = 0xe9
            public static let twoHundredTwentyFour      : UInt8 = 0xe0; public static let twoHundredThirtyFour      : UInt8 = 0xea
            public static let twoHundredTwentyFive      : UInt8 = 0xe1; public static let twoHundredThirtyFive      : UInt8 = 0xeb
            public static let twoHundredTwentySix       : UInt8 = 0xe2; public static let twoHundredThirtySix       : UInt8 = 0xec
            public static let twoHundredTwentySeven     : UInt8 = 0xe3; public static let twoHundredThirtySeven     : UInt8 = 0xed
            public static let twoHundredTwentyEight     : UInt8 = 0xe4; public static let twoHundredThirtyEight     : UInt8 = 0xee
            public static let twoHundredTwentyNine      : UInt8 = 0xe5; public static let twoHundredThirtyNine      : UInt8 = 0xef
            
            public static let twoHundredForty           : UInt8 = 0xf0; public static let twoHundredFifty           : UInt8 = 0xfa
            public static let twoHundredFortyOne        : UInt8 = 0xf1; public static let twoHundredFiftyOne        : UInt8 = 0xfb
            public static let twoHundredFortyTwo        : UInt8 = 0xf2; public static let twoHundredFiftyTwo        : UInt8 = 0xfc
            public static let twoHundredFortyThree      : UInt8 = 0xf3; public static let twoHundredFiftyThree      : UInt8 = 0xfd
            public static let twoHundredFortyFour       : UInt8 = 0xf4; public static let twoHundredFiftyFour       : UInt8 = 0xfe
            public static let twoHundredFortyFive       : UInt8 = 0xf5; public static let twoHundredFiftyFive       : UInt8 = 0xff
            public static let twoHundredFortySix        : UInt8 = 0xf6
            public static let twoHundredFortySeven      : UInt8 = 0xf7
            public static let twoHundredFortyEight      : UInt8 = 0xf8
            public static let twoHundredFortyNine       : UInt8 = 0xf9
        }
        
        public enum Base16ConstantValues {
            public static let zero                      : UInt8 = 0x00; public static let ten                       : UInt8 = 0x10
            public static let one                       : UInt8 = 0x01; public static let eleven                    : UInt8 = 0x11
            public static let two                       : UInt8 = 0x02; public static let twelve                    : UInt8 = 0x12
            public static let three                     : UInt8 = 0x03; public static let thirteen                  : UInt8 = 0x13
            public static let four                      : UInt8 = 0x04; public static let fourteen                  : UInt8 = 0x14
            public static let five                      : UInt8 = 0x05; public static let fifteen                   : UInt8 = 0x15
            public static let six                       : UInt8 = 0x06; public static let sixteen                   : UInt8 = 0x16
            public static let seven                     : UInt8 = 0x07; public static let seventeen                 : UInt8 = 0x17
            public static let eight                     : UInt8 = 0x08; public static let eighteen                  : UInt8 = 0x18
            public static let nine                      : UInt8 = 0x09; public static let nineteen                  : UInt8 = 0x19
            public static let ae                        : UInt8 = 0x0a; public static let abteen                    : UInt8 = 0x1a
            public static let bee                       : UInt8 = 0x0b; public static let bibteen                   : UInt8 = 0x1b
            public static let cee                       : UInt8 = 0x0c; public static let cibteen                   : UInt8 = 0x1c
            public static let dee                       : UInt8 = 0x0d; public static let dibbleteen                : UInt8 = 0x1d
            public static let ee                        : UInt8 = 0x0e; public static let ebbleteen                 : UInt8 = 0x1e
            public static let eff                       : UInt8 = 0x0f; public static let fleventeen                : UInt8 = 0x1f
            
            public static let twenty                    : UInt8 = 0x20; public static let thirty                    : UInt8 = 0x30
            public static let twentyOne                 : UInt8 = 0x21; public static let thirtyOne                 : UInt8 = 0x31
            public static let twentyTwo                 : UInt8 = 0x22; public static let thirtyTwo                 : UInt8 = 0x32
            public static let twentyThree               : UInt8 = 0x23; public static let thirtyThree               : UInt8 = 0x33
            public static let twentyFour                : UInt8 = 0x24; public static let thirtyFour                : UInt8 = 0x34
            public static let twentyFive                : UInt8 = 0x25; public static let thirtyFive                : UInt8 = 0x35
            public static let twentySix                 : UInt8 = 0x26; public static let thirtySix                 : UInt8 = 0x36
            public static let twentySeven               : UInt8 = 0x27; public static let thirtySeven               : UInt8 = 0x37
            public static let twentyEight               : UInt8 = 0x28; public static let thirtyEight               : UInt8 = 0x38
            public static let twentyNine                : UInt8 = 0x29; public static let thirtyNine                : UInt8 = 0x39
            public static let twentyAe                  : UInt8 = 0x2a; public static let thirtyAe                  : UInt8 = 0x3a
            public static let twentyBee                 : UInt8 = 0x2b; public static let thirtyBee                 : UInt8 = 0x3b
            public static let twentyCee                 : UInt8 = 0x2c; public static let thirtyCee                 : UInt8 = 0x3c
            public static let twentyDee                 : UInt8 = 0x2d; public static let thirtyDee                 : UInt8 = 0x3d
            public static let twentyEe                  : UInt8 = 0x2e; public static let thirtyEe                  : UInt8 = 0x3e
            public static let twentyEff                 : UInt8 = 0x2f; public static let thirtyEff                 : UInt8 = 0x3f
            
            public static let forty                     : UInt8 = 0x40; public static let fifty                     : UInt8 = 0x50
            public static let fortyOne                  : UInt8 = 0x41; public static let fiftyOne                  : UInt8 = 0x51
            public static let fortyTwo                  : UInt8 = 0x42; public static let fiftyTwo                  : UInt8 = 0x52
            public static let fortyThree                : UInt8 = 0x43; public static let fiftyThree                : UInt8 = 0x53
            public static let fortyFour                 : UInt8 = 0x44; public static let fiftyFour                 : UInt8 = 0x54
            public static let fortyFive                 : UInt8 = 0x45; public static let fiftyFive                 : UInt8 = 0x55
            public static let fortySix                  : UInt8 = 0x46; public static let fiftySix                  : UInt8 = 0x56
            public static let fortySeven                : UInt8 = 0x47; public static let fiftySeven                : UInt8 = 0x57
            public static let fortyEight                : UInt8 = 0x48; public static let fiftyEight                : UInt8 = 0x58
            public static let fortyNine                 : UInt8 = 0x49; public static let fiftyNine                 : UInt8 = 0x59
            public static let fortyAe                   : UInt8 = 0x4a; public static let fiftyAe                   : UInt8 = 0x5a
            public static let fortyBee                  : UInt8 = 0x4b; public static let fiftyBee                  : UInt8 = 0x5b
            public static let fortyCee                  : UInt8 = 0x4c; public static let fiftyCee                  : UInt8 = 0x5c
            public static let fortyDee                  : UInt8 = 0x4d; public static let fiftyDee                  : UInt8 = 0x5d
            public static let fortyEe                   : UInt8 = 0x4e; public static let fiftyEe                   : UInt8 = 0x5e
            public static let fortyEff                  : UInt8 = 0x4f; public static let fiftyEff                  : UInt8 = 0x5f
            
            public static let sixty                     : UInt8 = 0x60; public static let seventy                   : UInt8 = 0x70
            public static let sixtyOne                  : UInt8 = 0x61; public static let seventyOne                : UInt8 = 0x71
            public static let sixtyTwo                  : UInt8 = 0x62; public static let seventyTwo                : UInt8 = 0x72
            public static let sixtyThree                : UInt8 = 0x63; public static let seventyThree              : UInt8 = 0x73
            public static let sixtyFour                 : UInt8 = 0x64; public static let seventyFour               : UInt8 = 0x74
            public static let sixtyFive                 : UInt8 = 0x65; public static let seventyFive               : UInt8 = 0x75
            public static let sixtySix                  : UInt8 = 0x66; public static let seventySix                : UInt8 = 0x76
            public static let sixtySeven                : UInt8 = 0x67; public static let seventySeven              : UInt8 = 0x77
            public static let sixtyEight                : UInt8 = 0x68; public static let seventyEight              : UInt8 = 0x78
            public static let sixtyNine                 : UInt8 = 0x69; public static let seventyNine               : UInt8 = 0x79
            public static let sixtyAe                   : UInt8 = 0x6a; public static let seventyAe                 : UInt8 = 0x7a
            public static let sixtyBee                  : UInt8 = 0x6b; public static let seventyBee                : UInt8 = 0x7b
            public static let sixtyCee                  : UInt8 = 0x6c; public static let seventyCee                : UInt8 = 0x7c
            public static let sixtyDee                  : UInt8 = 0x6d; public static let seventyDee                : UInt8 = 0x7d
            public static let sixtyEe                   : UInt8 = 0x6e; public static let seventyEe                 : UInt8 = 0x7e
            public static let sixtyEff                  : UInt8 = 0x6f; public static let seventyEff                : UInt8 = 0x7f
            
            public static let eighty                    : UInt8 = 0x80; public static let ninety                    : UInt8 = 0x90
            public static let eightyOne                 : UInt8 = 0x81; public static let ninetyOne                 : UInt8 = 0x91
            public static let eightyTwo                 : UInt8 = 0x82; public static let ninetyTwo                 : UInt8 = 0x92
            public static let eightyThree               : UInt8 = 0x83; public static let ninetyThree               : UInt8 = 0x93
            public static let eightyFour                : UInt8 = 0x84; public static let ninetyFour                : UInt8 = 0x94
            public static let eightyFive                : UInt8 = 0x85; public static let ninetyFive                : UInt8 = 0x95
            public static let eightySix                 : UInt8 = 0x86; public static let ninetySix                 : UInt8 = 0x96
            public static let eightySeven               : UInt8 = 0x87; public static let ninetySeven               : UInt8 = 0x97
            public static let eightyEight               : UInt8 = 0x88; public static let ninetyEight               : UInt8 = 0x98
            public static let eightyNine                : UInt8 = 0x89; public static let ninetyNine                : UInt8 = 0x99
            public static let eightyAe                  : UInt8 = 0x8a; public static let ninetyAe                  : UInt8 = 0x9a
            public static let eightyBee                 : UInt8 = 0x8b; public static let ninetyBee                 : UInt8 = 0x9b
            public static let eightyCee                 : UInt8 = 0x8c; public static let ninetyCee                 : UInt8 = 0x9c
            public static let eightyDee                 : UInt8 = 0x8d; public static let ninetyDee                 : UInt8 = 0x9d
            public static let eightyEe                  : UInt8 = 0x8e; public static let ninetyEe                  : UInt8 = 0x9e
            public static let eightyEff                 : UInt8 = 0x8f; public static let ninetyEff                 : UInt8 = 0x9f
            
            public static let atta                      : UInt8 = 0xa0; public static let bitta                     : UInt8 = 0xb0
            public static let attaOne                   : UInt8 = 0xa1; public static let bittaOne                  : UInt8 = 0xb1
            public static let attaTwo                   : UInt8 = 0xa2; public static let bittaTwo                  : UInt8 = 0xb2
            public static let attaThree                 : UInt8 = 0xa3; public static let bittaThree                : UInt8 = 0xb3
            public static let attaFour                  : UInt8 = 0xa4; public static let bittaFour                 : UInt8 = 0xb4
            public static let attaFive                  : UInt8 = 0xa5; public static let bittaFive                 : UInt8 = 0xb5
            public static let attaSix                   : UInt8 = 0xa6; public static let bittaSix                  : UInt8 = 0xb6
            public static let attaSeven                 : UInt8 = 0xa7; public static let bittaSeven                : UInt8 = 0xb7
            public static let attaEight                 : UInt8 = 0xa8; public static let bittaEight                : UInt8 = 0xb8
            public static let attaNine                  : UInt8 = 0xa9; public static let bittaNine                 : UInt8 = 0xb9
            public static let attaAe                    : UInt8 = 0xaa; public static let bittaAe                   : UInt8 = 0xba
            public static let attaBee                   : UInt8 = 0xab; public static let bittaBee                  : UInt8 = 0xbb
            public static let attaCee                   : UInt8 = 0xac; public static let bittaCee                  : UInt8 = 0xbc
            public static let attaDee                   : UInt8 = 0xad; public static let bittaDee                  : UInt8 = 0xbd
            public static let attaEe                    : UInt8 = 0xae; public static let bittaEe                   : UInt8 = 0xbe
            public static let attaEff                   : UInt8 = 0xaf; public static let bittaEff                  : UInt8 = 0xbf
            
            public static let citta                     : UInt8 = 0xc0; public static let dickety                   : UInt8 = 0xd0
            public static let cittaOne                  : UInt8 = 0xc1; public static let dicketyOne                : UInt8 = 0xd1
            public static let cittaTwo                  : UInt8 = 0xc2; public static let dicketyTwo                : UInt8 = 0xd2
            public static let cittaThree                : UInt8 = 0xc3; public static let dicketyThree              : UInt8 = 0xd3
            public static let cittaFour                 : UInt8 = 0xc4; public static let dicketyFour               : UInt8 = 0xd4
            public static let cittaFive                 : UInt8 = 0xc5; public static let dicketyFive               : UInt8 = 0xd5
            public static let cittaSix                  : UInt8 = 0xc6; public static let dicketySix                : UInt8 = 0xd6
            public static let cittaSeven                : UInt8 = 0xc7; public static let dicketySeven              : UInt8 = 0xd7
            public static let cittaEight                : UInt8 = 0xc8; public static let dicketyEight              : UInt8 = 0xd8
            public static let cittaNine                 : UInt8 = 0xc9; public static let dicketyNine               : UInt8 = 0xd9
            public static let cittaAe                   : UInt8 = 0xca; public static let dicketyAe                 : UInt8 = 0xda
            public static let cittaBee                  : UInt8 = 0xcb; public static let dicketyBee                : UInt8 = 0xdb
            public static let cittaCee                  : UInt8 = 0xcc; public static let dicketyCee                : UInt8 = 0xdc
            public static let cittaDee                  : UInt8 = 0xcd; public static let dicketyDee                : UInt8 = 0xdd
            public static let cittaEe                   : UInt8 = 0xce; public static let dicketyEe                 : UInt8 = 0xde
            public static let cittaEff                  : UInt8 = 0xcf; public static let dicketyEff                : UInt8 = 0xdf
            
            public static let eckity                    : UInt8 = 0xe0; public static let fleventy                  : UInt8 = 0xf0
            public static let eckityOne                 : UInt8 = 0xe1; public static let fleventyOne               : UInt8 = 0xf1
            public static let eckityTwo                 : UInt8 = 0xe2; public static let fleventyTwo               : UInt8 = 0xf2
            public static let eckityThree               : UInt8 = 0xe3; public static let fleventyThree             : UInt8 = 0xf3
            public static let eckityFour                : UInt8 = 0xe4; public static let fleventyFour              : UInt8 = 0xf4
            public static let eckityFive                : UInt8 = 0xe5; public static let fleventyFive              : UInt8 = 0xf5
            public static let eckitySix                 : UInt8 = 0xe6; public static let fleventySix               : UInt8 = 0xf6
            public static let eckitySeven               : UInt8 = 0xe7; public static let fleventySeven             : UInt8 = 0xf7
            public static let eckityEight               : UInt8 = 0xe8; public static let fleventyEight             : UInt8 = 0xf8
            public static let eckityNine                : UInt8 = 0xe9; public static let fleventyNine              : UInt8 = 0xf9
            public static let eckityAe                  : UInt8 = 0xea; public static let fleventyAe                : UInt8 = 0xfa
            public static let eckityBee                 : UInt8 = 0xeb; public static let fleventyBee               : UInt8 = 0xfb
            public static let eckityCee                 : UInt8 = 0xec; public static let fleventyCee               : UInt8 = 0xfc
            public static let eckityDee                 : UInt8 = 0xed; public static let fleventyDee               : UInt8 = 0xfd
            public static let eckityEe                  : UInt8 = 0xee; public static let fleventyEe                : UInt8 = 0xfe
            public static let eckityEff                 : UInt8 = 0xef; public static let fleventyEff               : UInt8 = 0xff
            
        }
        
        public static let max1bit       : UInt8 = 0x01
        public static let max2bit       : UInt8 = 0x03
        public static let max3bit       : UInt8 = 0x07
        public static let max4bit       : UInt8 = 0x0f
        public static let max5bit       : UInt8 = 0x1f
        public static let max6bit       : UInt8 = 0x3f
        public static let max7bit       : UInt8 = 0x7f
        public static let max8bit       : UInt8 = 0xff
        
    }
}

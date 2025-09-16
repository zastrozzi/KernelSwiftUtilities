//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 26/11/2023.
//

import Testing
import KernelSwiftCommon

@Suite
struct RGBAColorTests {
//    func testHexConversion() {
//        hexConversionForColor("#FFC61A") // 255,    198,    26
//        hexConversionForColor("#00ced1") // 0,      206,    209
//    }
    
    
    @Test(arguments: [
        "#FFC61A",
        "#00ced1",
    ])
    func hexConversionForColor(_ color: String) {
        let color = color.removingCharacters(notIn: .hexadecimalDigits).prefix(6)
        let hexColor6: String = "#\(color)"
        let hexColor8: String = "#\(color)ff"
        let hexColor8_alpha20: String = "#\(color)33"
        let hexColor8_alpha40: String = "#\(color)66"
        let hexColor8_alpha60: String = "#\(color)99"
        let hexColor8_alpha80: String = "#\(color)cc"
        
        let color6: KernelSwiftCommon.RGBAColor = .init(fromHex: hexColor6)
        let color8: KernelSwiftCommon.RGBAColor = .init(fromHex: hexColor8)
        let color8_alpha20: KernelSwiftCommon.RGBAColor = .init(fromHex: hexColor8_alpha20)
        let color8_alpha40: KernelSwiftCommon.RGBAColor = .init(fromHex: hexColor8_alpha40)
        let color8_alpha60: KernelSwiftCommon.RGBAColor = .init(fromHex: hexColor8_alpha60)
        let color8_alpha80: KernelSwiftCommon.RGBAColor = .init(fromHex: hexColor8_alpha80)
        
        print(
            color6,
            color6.toHexString(truncated: true),
            color6.toHexString(withAlpha: false),
            color6.toHexString()
        )
        print(
            color8,
            color8.toHexString(truncated: true),
            color8.toHexString(withAlpha: false),
            color8.toHexString()
        )
        print(
            color8.darker(by: 10),
            color8.darker(by: 10).toHexString(truncated: true),
            color8.darker(by: 10).toHexString(withAlpha: false),
            color8.darker(by: 10).toHexString()
        )
        print(
            color8.lighter(by: 10),
            color8.lighter(by: 10).toHexString(truncated: true),
            color8.lighter(by: 10).toHexString(withAlpha: false),
            color8.lighter(by: 10).toHexString()
        )
        print(
            color8_alpha20,
            color8_alpha20.toHexString(truncated: true),
            color8_alpha20.toHexString(withAlpha: false),
            color8_alpha20.toHexString(hashPrefixed: false)
        )
        print(
            color8_alpha40,
            color8_alpha40.toHexString(truncated: true),
            color8_alpha40.toHexString(withAlpha: false),
            color8_alpha40.toHexString(hashPrefixed: false)
        )
        print(
            color8_alpha60,
            color8_alpha60.toHexString(truncated: true),
            color8_alpha60.toHexString(withAlpha: false),
            color8_alpha60.toHexString(hashPrefixed: false)
        )
        print(
            color8_alpha80,
            color8_alpha80.toHexString(truncated: true),
            color8_alpha80.toHexString(withAlpha: false),
            color8_alpha80.toHexString(hashPrefixed: false)
        )
    }
}

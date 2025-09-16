//
//  File.swift
//
//
//  Created by Abdullah Chaudhry on 17/05/2022.
//

import Foundation

struct KebabCaseKey: CodingKey {
    let stringValue: String
    let intValue: Int?
    
    init(stringValue: String) {
        self.stringValue = stringValue.split(separator: "-").joined(separator: "_")
        intValue = nil
    }
    
    init(intValue: Int) {
        stringValue = String(intValue)
        self.intValue = intValue
    }
}

extension JSONDecoder.KeyDecodingStrategy {
    public static var convertFromKebabCase: Self {
        .custom { keys in
            KebabCaseKey(stringValue: keys.last!.stringValue)
        }
    }
}

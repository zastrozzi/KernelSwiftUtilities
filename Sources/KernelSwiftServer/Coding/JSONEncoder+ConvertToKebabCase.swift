//
//  File.swift
//
//
//  Created by Abdullah Chaudhry on 19/05/2022.
//

import Foundation

struct KebabCaseEncodeKey: CodingKey {
    let stringValue: String
    let intValue: Int?

    init(stringValue: String) {
        self.stringValue = stringValue.split(separator: "_").joined(separator: "-")
        intValue = nil
    }

    init(intValue: Int) {
        stringValue = String(intValue)
        self.intValue = intValue
    }
}

extension JSONEncoder.KeyEncodingStrategy {
    public static var convertToKebabCase: Self {
        .custom { keys in
            KebabCaseEncodeKey(stringValue: keys.last!.stringValue)
        }
    }
}

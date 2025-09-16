//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 13/05/2023.
//

import Foundation

extension Array where Element == UInt8 {
    public func escaping(_ utf8Character: UInt8?) -> [UInt8] {
        guard let utf8Character else { return self }
        let contents = self.contains(utf8Character) ? Array(self.split(separator: utf8Character, omittingEmptySubsequences: false).joined(separator: [utf8Character, utf8Character])) : self
        return Array([[utf8Character], contents, [utf8Character]].joined())
    }
}

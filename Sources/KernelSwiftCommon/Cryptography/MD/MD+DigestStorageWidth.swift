//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 09/10/2023.
//

import Foundation

extension KernelSwiftCommon.Cryptography.MD {
    public enum DigestStorageWidth {
        case word
        case doubleWord
    }
}

extension KernelSwiftCommon.Cryptography.MD.DigestStorageWidth {
    public var byteWidth: Int {
        switch self {
        case .word: 4
        case .doubleWord: 8
        }
    }
}

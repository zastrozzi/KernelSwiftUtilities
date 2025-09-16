//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 06/11/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCryptography.ChaCha {
    public typealias val = ConstantValues
    
    public enum ConstantValues {
        public static let chacha20StateSeed: KernelNumerics.Words128 = (0x61707865, 0x3320646e, 0x79622d32, 0x6b206574)
        public static let poly1305: KernelNumerics.DoubleWords192 = (0xfffffffffffffffb, 0xffffffffffffffff, 0x0000000000000003)
        public static let polyZero: KernelNumerics.DoubleWords192 = (.zero, .zero, .zero)
    }
}

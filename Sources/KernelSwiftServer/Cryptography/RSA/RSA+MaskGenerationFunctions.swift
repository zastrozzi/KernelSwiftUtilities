//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 11/10/2023.
//

import Foundation

extension KernelCryptography.RSA {
    public enum MaskGeneration {}
}

extension KernelCryptography.RSA.MaskGeneration {
    public static func mgf1(
        _ algorithm: KernelCryptography.Algorithms.MessageDigestAlgorithm,
        mgfSeed: [UInt8],
        maskLen: Int
    ) -> [UInt8] {
        guard maskLen > 0 else { return [] }
        var digest: KernelCryptography.MD.Digest = .init(algorithm)
        var t: [UInt8] = []
        var cntr: [UInt8] = .init(repeating: 0x00, count: 4)
        let len = (maskLen - 1) / algorithm.outputSizeBytes + 1
        for _ in .zero ..< len {
            digest.update(mgfSeed)
            digest.update(cntr)
            t.append(contentsOf: digest.digest())
            cntr[3] &+= 1
            if cntr[3] == .zero {
                cntr[2] &+= 1
                if cntr[2] == .zero {
                    cntr[1] &+= 1
                    if cntr[1] == .zero {
                        cntr[0] &+= 1
                    }
                }
            }
        }
        return .init(t[.zero ..< maskLen])
    }
}

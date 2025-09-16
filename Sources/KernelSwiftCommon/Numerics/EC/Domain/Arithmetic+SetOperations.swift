//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 30/09/2023.
//

import Foundation

extension KernelNumerics.EC.Domain {
    public enum SetOperations {
        @_documentation(visibility: private)
        public typealias Arithmetic = KernelNumerics.EC.Arithmetic
        
        public static func contains(
            _ p: KernelNumerics.EC.Point,
            d: borrowing KernelNumerics.EC.Domain
        ) -> Bool {
            if p.isInfinite { return true }
            let xCubic = Arithmetic.Barrett.addMod(
                Arithmetic.Barrett.multiplyMod(Arithmetic.Barrett.squareMod(p.x, d: d), p.x, d: d),
                Arithmetic.Barrett.addMod(Arithmetic.Barrett.multiplyMod(p.x, d.a, d: d), d.b, d: d),
                d: d
            )
            let ySquare = Arithmetic.Barrett.squareMod(p.y, d: d)
            return xCubic == ySquare
        }
    }
}

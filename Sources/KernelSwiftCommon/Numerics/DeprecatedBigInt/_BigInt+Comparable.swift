//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/06/2023.
//

extension KernelNumerics._BigInt: Equatable, Comparable {
    public static func ==(a: Self, b: Self) -> Bool {
            return a.sign == b.sign && a.magnitude == b.magnitude
        }

        /// Return true iff `a` is less than `b`.
        public static func <(a: Self, b: Self) -> Bool {
            switch (a.sign, b.sign) {
            case (.plus, .plus):
                return a.magnitude < b.magnitude
            case (.plus, .minus):
                return false
            case (.minus, .plus):
                return true
            case (.minus, .minus):
                return a.magnitude > b.magnitude
            }
        }
}

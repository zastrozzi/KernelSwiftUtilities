//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/06/2023.
//

extension KernelNumerics._BigInt {
    public init() {
        self.init(sign: .plus, magnitude: 0)
    }

    /// Initializes a new signed big integer with the same value as the specified unsigned big integer.
    public init(_ integer: KernelNumerics.BigUInt) {
        self.magnitude = integer
        self.sign = .plus
    }

    public init<T>(_ source: T) where T : BinaryInteger {
        if source >= (0 as T) {
            self.init(sign: .plus, magnitude: KernelNumerics.BigUInt(source))
        }
        else {
            var words = Array(source.words)
            words.twosComplement()
            self.init(sign: .minus, magnitude: KernelNumerics.BigUInt(words: words))
        }
    }

    public init?<T>(exactly source: T) where T : BinaryInteger {
        self.init(source)
    }

    public init<T>(clamping source: T) where T : BinaryInteger {
        self.init(source)
    }

    public init<T>(truncatingIfNeeded source: T) where T : BinaryInteger {
        self.init(source)
    }
}

extension KernelNumerics._BigInt: ExpressibleByIntegerLiteral {
    /// Initialize a new big integer from an integer literal.
    public init(integerLiteral value: Int64) {
        self.init(value)
    }
}

//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/06/2023.
//

extension KernelNumerics {
    public struct _BigInt {
        public enum Sign {
            case plus
            case minus
        }

        public typealias Magnitude = BigUInt
        public typealias Word = BigUInt.Word

        public static var isSigned: Bool {
            return true
        }

        public var magnitude: BigUInt

        public var sign: Sign

        public init(sign: Sign, magnitude: BigUInt) {
            self.sign = (magnitude.isZero ? .plus : sign)
            self.magnitude = magnitude
        }
        
        public var isZero: Bool {
            return magnitude.isZero
        }
        
        public func signum() -> Self {
            switch sign {
            case .plus:
                return isZero ? 0 : 1
            case .minus:
                return -1
            }
        }
        
        public var bitWidth: Int {
            guard !magnitude.isZero else { return 0 }
            return magnitude.bitWidth + 1
        }

        public var trailingZeroBitCount: Int {
            // Amazingly, this works fine for negative numbers
            return magnitude.trailingZeroBitCount
        }
        
        public struct Words: RandomAccessCollection {
            public typealias Indices = CountableRange<Int>

            private let value: KernelNumerics._BigInt
            private let decrementLimit: Int

            fileprivate init(_ value: KernelNumerics._BigInt) {
                self.value = value
                switch value.sign {
                case .plus:
                    self.decrementLimit = 0
                case .minus:
                    assert(!value.magnitude.isZero)
                    self.decrementLimit = value.magnitude.words.firstIndex(where: { $0 != 0 })!
                }
            }

            public var count: Int {
                switch value.sign {
                case .plus:
                    if let high = value.magnitude.words.last, high >> (Word.bitWidth - 1) != 0 {
                        return value.magnitude.count + 1
                    }
                    return value.magnitude.count
                case .minus:
                    let high = value.magnitude.words.last!
                    if high >> (Word.bitWidth - 1) != 0 {
                        return value.magnitude.count + 1
                    }
                    return value.magnitude.count
                }
            }

            public var indices: Indices { return 0 ..< count }
            public var startIndex: Int { return 0 }
            public var endIndex: Int { return count }

            public subscript(_ index: Int) -> UInt {
                // Note that indices above `endIndex` are accepted.
                if value.sign == .plus {
                    return value.magnitude[index]
                }
                if index <= decrementLimit {
                    return ~(value.magnitude[index] &- 1)
                }
                return ~value.magnitude[index]
            }
        }

        public var words: Words {
            return Words(self)
        }

        public init<S: Sequence>(words: S) where S.Element == Word {
            var words = Array(words)
            if (words.last ?? 0) >> (Word.bitWidth - 1) == 0 {
                self.init(sign: .plus, magnitude: KernelNumerics.BigUInt(words: words))
            }
            else {
                words.twosComplement()
                self.init(sign: .minus, magnitude: KernelNumerics.BigUInt(words: words))
            }
        }
    }
}

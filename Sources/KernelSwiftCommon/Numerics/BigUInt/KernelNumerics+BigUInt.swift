//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/06/2023.
//

import Collections

extension KernelNumerics {
    public struct BigUInt: UnsignedInteger, Sendable {
        public typealias Word = UInt
        
        @usableFromInline
        enum Kind: Hashable, Sendable {
            case inline(Word, Word)
            case slice(from: Int, to: Int)
            case deque
        }
        
        @usableFromInline
        var kind: Kind
        
        @usableFromInline
        var storage: Deque<Word>
        
        public init() {
            self.kind = .inline(0, 0)
            self.storage = []
        }
        
        public init(words: Deque<Word>) {
            self.kind = .deque
            self.storage = words
            normalise()
        }
        
        @inlinable
        init(word: Word) {
            self.kind = .inline(word, 0)
            self.storage = []
        }
        
        @inlinable
        init(low: Word, high: Word) {
            self.kind = .inline(low, high)
            self.storage = []
        }
        
        @inlinable
        init(words: Deque<Word>, from startIndex: Int, to endIndex: Int) {
            self.kind = .slice(from: startIndex, to: endIndex)
            self.storage = words
            normalise()
        }
        
        public func hash(into hasher: inout Hasher) {
            for word in words { hasher.combine(word) }
        }
        
        @usableFromInline
        var capacity: Int {
            guard case .deque = kind else { return 0 }
            return storage.count
        }
        
        @usableFromInline
        var isZero: Bool {
            switch kind {
            case .inline(0, 0): return true
            case .deque: return storage.isEmpty
            default:
                return false
            }
        }
        
        @inlinable
        public var count: Int {
            switch kind {
            case .inline(let w0, let w1): return w1 != 0 ? 2 : w0 != 0 ? 1 : 0
            case .slice(let from, let to): return to - from
            case .deque: return storage.count
            }
        }

        @inlinable
        var split: (high: KernelNumerics.BigUInt, low: KernelNumerics.BigUInt) {
            precondition(count > 1)
            let mid = middleIndex
            return (extract(mid...), extract(..<mid))
        }
        
        @inlinable
        var middleIndex: Int { (count + 1) / 2 }
        
        @inlinable
        var low: KernelNumerics.BigUInt { extract(0..<middleIndex) }
        
        @inlinable
        var high: KernelNumerics.BigUInt { extract(middleIndex..<count) }
    }
}




// MARK: - Numeric


// MARK: - BinaryInteger
extension KernelNumerics.BigUInt {
    public struct Words: RandomAccessCollection {
        @usableFromInline
        internal let value: KernelNumerics.BigUInt

        @inlinable
        init(_ value: KernelNumerics.BigUInt) { self.value = value }

        @inlinable
        public var startIndex: Int { return 0 }
        
        @inlinable
        public var endIndex: Int { return value.count }

        @inlinable
        public subscript(_ index: Int) -> Word {
            return value[index]
        }
    }
}

extension KernelNumerics.BigUInt {
    public init<WS: Sequence>(words: WS) where WS.Element == Word {
        let underCount = words.underestimatedCount
        guard underCount <= 2 else { self.init(words: .init(words)); return }
        var iter = words.makeIterator()
        guard let w0 = iter.next() else { self.init(); return }
        guard let w1 = iter.next() else { self.init(word: w0); return }
        guard let w2 = iter.next() else { self.init(low: w0, high: w1); return }
        var words: Deque<UInt> = .init(minimumCapacity: Swift.max(underCount, 3))
        words.append(contentsOf: [w0, w1, w2])
        while let word = iter.next() { words.append(word) }
        self.init(words: words)
    }
    
    @inlinable
    public var words: Words { return Words(self) }
    
    @inlinable
    public var bitWidth: Int {
        guard count > 0 else { return 0 }
        return count * Word.bitWidth - self[count - 1].leadingZeroBitCount
    }
    
    @inlinable
    var byteWidth: Int {
        let bytes = self.bitWidth / 8
        return self.bitWidth % 8 == 0 ? bytes : bytes + 1
    }
    
    public var leadingZeroBitCount: Int {
        guard count > 0 else { return 0 }
        return self[count - 1].leadingZeroBitCount
    }
    
    @inlinable
    public var trailingZeroBitCount: Int {
        guard count > 0 else { return 0 }
        let i = self.words.firstIndex { $0 != 0 }!
        return i * Word.bitWidth + self[i].trailingZeroBitCount
    }
    
    @inlinable
    public func signum() -> KernelNumerics.BigUInt {
        return isZero ? 0 : 1
    }
    
    
}


// MARK: - FixedWidthInteger
extension KernelNumerics.BigUInt {
////    @inlinable
//    public var leadingZeroBitCount: Int {
//        guard count > 0 else { return 0 }
//        return self[count - 1].leadingZeroBitCount
//    }
}


// MARK: - Bit Shiftable
extension KernelNumerics.BigUInt {
    @inlinable
    internal mutating func shiftRight(byWords amount: Int) {
        assert(amount >= 0)
        guard amount > 0 else { return }
        switch kind {
        case let .inline(_, w1) where amount == 1:
            kind = .inline(w1, 0)
        case .inline(_, _):
            kind = .inline(0, 0)
        case let .slice(from: start, to: end):
            let s = start + amount
            if s >= end {
                kind = .inline(0, 0)
            }
            else {
                kind = .slice(from: s, to: end)
                normalise()
            }
        case .deque:
            if amount >= storage.count {
                storage.removeAll(keepingCapacity: true)
            }
            else {
                storage.removeFirst(amount)
            }
        }
    }

    @inlinable
    internal mutating func shiftLeft(byWords amount: Int) {
        assert(amount >= 0)
        guard amount > 0 else { return }
        guard !isZero else { return }
        switch kind {
        case let .inline(w0, 0) where amount == 1:
            kind = .inline(0, w0)
        case let .inline(w0, w1):
            let c = (w1 == 0 ? 1 : 2)
            storage.reserveCapacity(amount + c)
            storage.append(contentsOf: repeatElement(0, count: amount))
            storage.append(w0)
            if w1 != 0 {
                storage.append(w1)
            }
            kind = .deque
        case let .slice(from: start, to: end):
            var words: Deque<Word> = []
            words.reserveCapacity(amount + count)
            words.append(contentsOf: repeatElement(0, count: amount))
            words.append(contentsOf: storage[start ..< end])
            storage = words
            kind = .deque
        case .deque:
            storage.insert(contentsOf: repeatElement(0, count: amount), at: 0)
        }
    }

    @inlinable
    internal func shiftedLeft(by amount: Word) -> KernelNumerics.BigUInt {
        guard amount > 0 else { return self }
        
        let ext = Int(amount / Word(Word.bitWidth)) // External shift amount (new words)
        let up = Word(amount % Word(Word.bitWidth)) // Internal shift amount (subword shift)
        let down = Word(Word.bitWidth) - up
        
        var result = KernelNumerics.BigUInt()
        if up > 0 {
            var i = 0
            var lowbits: Word = 0
            while i < self.count || lowbits > 0 {
                let word = self[i]
                result[i + ext] = word << up | lowbits
                lowbits = word >> down
                i += 1
            }
        }
        else {
            for i in 0 ..< self.count {
                result[i + ext] = self[i]
            }
        }
        return result
    }
    
    @inlinable
    internal mutating func shiftLeft(by amount: Word) {
        guard amount > 0 else { return }
        
        let ext = Int(amount / Word(Word.bitWidth)) // External shift amount (new words)
        let up = Word(amount % Word(Word.bitWidth)) // Internal shift amount (subword shift)
        let down = Word(Word.bitWidth) - up
        
        if up > 0 {
            var i = 0
            var lowbits: Word = 0
            while i < self.count || lowbits > 0 {
                let word = self[i]
                self[i] = word << up | lowbits
                lowbits = word >> down
                i += 1
            }
        }
        if ext > 0 && self.count > 0 {
            self.shiftLeft(byWords: ext)
        }
    }
    
    @inlinable
    internal func shiftedRight(by amount: Word) -> KernelNumerics.BigUInt {
        guard amount > 0 else { return self }
        guard amount < self.bitWidth else { return 0 }
        
        let ext = Int(amount / Word(Word.bitWidth)) // External shift amount (new words)
        let down = Word(amount % Word(Word.bitWidth)) // Internal shift amount (subword shift)
        let up = Word(Word.bitWidth) - down
        
        var result = KernelNumerics.BigUInt()
        if down > 0 {
            var highbits: Word = 0
            for i in (ext ..< self.count).reversed() {
                let word = self[i]
                result[i - ext] = highbits | word >> down
                highbits = word << up
            }
        }
        else {
            for i in (ext ..< self.count).reversed() {
                result[i - ext] = self[i]
            }
        }
        return result
    }

    @inlinable
    internal mutating func shiftRight(by amount: Word) {
        guard amount > 0 else { return }
        guard amount < self.bitWidth else { self.clear(); return }
        
        let ext = Int(amount / Word(Word.bitWidth)) // External shift amount (new words)
        let down = Word(amount % Word(Word.bitWidth)) // Internal shift amount (subword shift)
        let up = Word(Word.bitWidth) - down
        
        if ext > 0 {
            self.shiftRight(byWords: ext)
        }
        if down > 0 {
            var i = self.count - 1
            var highbits: Word = 0
            while i >= 0 {
                let word = self[i]
                self[i] = highbits | word >> down
                highbits = word << up
                i -= 1
            }
        }
    }
    
//    @inlinable
    public static func >>=<Other: BinaryInteger>(lhs: inout KernelNumerics.BigUInt, rhs: Other) {
        if rhs < (0 as Other) {
            lhs <<= (0 - rhs)
        }
        else if rhs >= lhs.bitWidth {
            lhs.clear()
        }
        else {
            lhs.shiftRight(by: UInt(rhs))
        }
    }
    
//    @inlinable
    public static func <<=<Other: BinaryInteger>(lhs: inout KernelNumerics.BigUInt, rhs: Other) {
        if rhs < (0 as Other) {
            lhs >>= (0 - rhs)
            return
        }
        lhs.shiftLeft(by: Word(exactly: rhs)!)
    }

//    @inlinable
    public static func >><Other: BinaryInteger>(lhs: KernelNumerics.BigUInt, rhs: Other) -> KernelNumerics.BigUInt {
        if rhs < (0 as Other) {
            return lhs << (0 - rhs)
        }
        if rhs > Word.max {
            return 0
        }
        return lhs.shiftedRight(by: UInt(rhs))
    }

//    @inlinable
    public static func <<<Other: BinaryInteger>(lhs: KernelNumerics.BigUInt, rhs: Other) -> KernelNumerics.BigUInt {
        if rhs < (0 as Other) {
            return lhs >> (0 - rhs)
        }
        return lhs.shiftedLeft(by: Word(exactly: rhs)!)
    }
}

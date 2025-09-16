//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/06/2023.
//

import Collections

extension KernelNumerics.BigUInt {
    @inlinable
    func extract(_ bounds: Range<Int>) -> KernelNumerics.BigUInt {
        switch kind {
        case let .inline(w0, w1):
            let bounds = bounds.clamped(to: 0 ..< 2)
            if bounds == 0 ..< 2 {
                return KernelNumerics.BigUInt(low: w0, high: w1)
            }
            else if bounds == 0 ..< 1 {
                return KernelNumerics.BigUInt(word: w0)
            }
            else if bounds == 1 ..< 2 {
                return KernelNumerics.BigUInt(word: w1)
            }
            else {
                return KernelNumerics.BigUInt()
            }
        case let .slice(from: start, to: end):
            let s = Swift.min(end, start + Swift.max(bounds.lowerBound, 0))
            let e = Swift.max(s, (bounds.upperBound > end - start ? end : start + bounds.upperBound))
            return KernelNumerics.BigUInt(words: storage, from: s, to: e)
        case .deque:
            let b = bounds.clamped(to: storage.startIndex ..< storage.endIndex)
            return KernelNumerics.BigUInt(words: storage, from: b.lowerBound, to: b.upperBound)
        }
    }

    @inlinable
    func extract<Bounds: RangeExpression>(_ bounds: Bounds) -> KernelNumerics.BigUInt where Bounds.Bound == Int {
        return self.extract(bounds.relative(to: 0 ..< Int.max))
    }
    
    @inlinable
    mutating func normalise() {
        switch kind {
        case .slice(from: let start, to: var end):
            assert(start >= 0 && end <= storage.count && start <= end)
            while start < end, storage[end - 1] == 0 {
                end -= 1
            }
            switch end - start {
            case 0:
                kind = .inline(0, 0)
                storage = []
            case 1:
                kind = .inline(storage[start], 0)
                storage = []
            case 2:
                kind = .inline(storage[start], storage[start + 1])
                storage = []
            case storage.count:
                assert(start == 0)
                kind = .deque
            default:
                kind = .slice(from: start, to: end)
            }
        case .deque where storage.last == 0:
            while storage.last == 0 {
                storage.removeLast()
            }
        default:
            break
        }
    }
    
    @inlinable
    mutating func ensureDeque() {
        switch kind {
        case let .inline(w0, w1):
            kind = .deque
            storage = w1 != 0 ? [w0, w1] : w0 != 0 ? [w0] : []
        case let .slice(from: start, to: end):
            kind = .deque
            storage = .init(storage[start ..< end])
        case .deque: break
        }
    }
    
    public mutating func reserveCapacityAndZero(_ minimumCapacity: Int) {
        reserveCapacity(minimumCapacity)
        while count < minimumCapacity { storage.append(.zero) }
    }
    
    @inlinable
    public static func reserveCapacity(for x: inout KernelNumerics.BigUInt, _ minimumCapacity: Int) {
        switch x.kind {
        case let .inline(w0, w1):
            x.kind = .deque
            x.storage.reserveCapacity(minimumCapacity)
            if w1 != 0 {
                x.storage.append(w0)
                x.storage.append(w1)
            }
            else if w0 != 0 {
                x.storage.append(w0)
            }
        case let .slice(from: start, to: end):
            x.kind = .deque
            var words: Deque<Word> = []
            words.reserveCapacity(Swift.max(end - start, minimumCapacity))
            words.append(contentsOf: x.storage[start ..< end])
            x.storage = words
        case .deque: x.storage.reserveCapacity(minimumCapacity)
        }
    }
    
    @inlinable
    public mutating func reserveCapacity(_ minimumCapacity: Int) {
        switch kind {
        case let .inline(w0, w1):
            kind = .deque
            storage.reserveCapacity(minimumCapacity)
            if w1 != 0 {
                storage.append(w0)
                storage.append(w1)
            }
            else if w0 != 0 {
                storage.append(w0)
            }
        case let .slice(from: start, to: end):
            kind = .deque
            var words: Deque<Word> = []
            words.reserveCapacity(Swift.max(end - start, minimumCapacity))
            words.append(contentsOf: storage[start ..< end])
            storage = words
        case .deque: storage.reserveCapacity(minimumCapacity)
        }
    }
    
    @inlinable
    mutating func replace(at index: Int, with word: Word) {
        ensureDeque()
        precondition(index < storage.count)
        storage[index] = word
        if word == 0, index == storage.count - 1 {
            normalise()
        }
    }

    @inlinable
    mutating func extend(at index: Int, with word: Word) {
        guard word != 0 else { return }
        reserveCapacity(index + 1)
        precondition(index >= storage.count)
        storage.append(contentsOf: repeatElement(0, count: index - storage.count))
        storage.append(word)
    }
    
    @inlinable
    mutating func clear() {
        self.load(0)
    }

    @inlinable
    mutating func load(_ value: KernelNumerics.BigUInt) {
        switch kind {
        case .inline, .slice:
            self = value
        case .deque:
            self.storage.removeAll(keepingCapacity: true)
            self.storage.append(contentsOf: value.words)
        }
    }
}

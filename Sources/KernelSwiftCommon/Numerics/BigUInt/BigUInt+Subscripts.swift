//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/06/2023.
//

import Collections

extension KernelNumerics.BigUInt {
    public subscript(_ index: Int) -> Word {
        get {
            precondition(index >= 0)
            switch (kind, index) {
            case (.inline(let w0, _), 0): return w0
            case (.inline(_, let w1), 1): return w1
            case (.slice(from: let start, to: let end), _) where index < end - start: return storage[start + index]
            case (.deque, _) where index < storage.count: return storage[index]
            default: return 0
            }
        }
        
        set(word) {
            precondition(index >= 0)
            switch (kind, index) {
            case let (.inline(_, w1), 0): kind = .inline(word, w1)
            case let (.inline(w0, _), 1): kind = .inline(w0, word)
            case let (.slice(from: start, to: end), _) where index < end - start: replace(at: index, with: word)
            case (.deque, _) where index < storage.count: replace(at: index, with: word)
            default: extend(at: index, with: word)
            }
        }
    }
}

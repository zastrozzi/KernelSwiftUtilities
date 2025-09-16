//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 23/05/2023.
//

import Foundation

extension Substring {
    public func characterRange(from set: KernelUnicodeScalarSet, options: String.CompareOptions) -> Range<Index>? {
        
        fatalError("KERNEL UNICODE SCALARS DISABLED")
//        guard !isEmpty else { return nil }
//        return unicodeScalars.characterRange(anchored: options.contains(.anchored), backwards: options.contains(.backwards), matchingPredicate: set.contains)
    }
}

extension Substring.UnicodeScalarView {
    public func characterRange(anchored: Bool, backwards: Bool, matchingPredicate predicate: (Unicode.Scalar) -> Bool) -> Range<Index>? {
        
        fatalError("KERNEL UNICODE SCALARS DISABLED")
//        guard !isEmpty else { return nil }
//        let from: String.Index, to: String.Index, step: Int
//        if backwards {
//            from = index(before: endIndex)
//            to = anchored ? from : startIndex
//            step = -1
//        } else {
//            from = startIndex
//            to = anchored ?from : index(before: endIndex)
//            step = 1
//        }
//        var done: Bool = false
//        var found: Bool = false
//        var workingIndex: String.Index = from
//        while !done {
//            let char = self[workingIndex]
//            if predicate(char) {
//                done = true
//                found = true
//            } else if workingIndex == to {
//                done = true
//            } else {
//                formIndex(&workingIndex, offsetBy: step)
//            }
//        }
//        guard found else { return nil }
//        return workingIndex..<index(after: workingIndex)
    }
}

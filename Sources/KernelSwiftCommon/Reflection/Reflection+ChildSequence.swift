//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/02/2025.
//

import Foundation

extension KernelSwiftCommon.Reflection {
    public struct ChildSequence: Sequence {
        private let children: Mirror.Children
        
        public init(subject: AnyObject) {
            self.children = Mirror(reflecting: subject).children
        }
        
        public func makeIterator() -> ChildIterator {
            .init(iterator: self.children.makeIterator())
        }
    }
}

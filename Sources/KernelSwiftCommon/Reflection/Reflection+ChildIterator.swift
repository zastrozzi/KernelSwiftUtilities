//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/02/2025.
//

import Foundation

extension KernelSwiftCommon.Reflection {
    public struct ChildIterator: IteratorProtocol {
        private var iterator: Mirror.Children.Iterator
        private var storage: CStringStorage?
        
        init(iterator: Mirror.Children.Iterator) {
            self.iterator = iterator
        }
        
        init(subject: AnyObject) {
            self.init(iterator: Mirror(reflecting: subject).children.makeIterator())
        }
        
        public mutating func next() -> (name: UnsafePointer<CChar>?, child: Any)? {
            guard let child = self.iterator.next() else {
                self.storage = nil
                return nil
            }
            if var label = child.label {
                let nameC = label.withUTF8 { labelPtr in
                    let buff = UnsafeMutableBufferPointer<CChar>.allocate(capacity: labelPtr.count + 1)
                    buff.initialize(repeating: 0)
                    _ = labelPtr.withMemoryRebound(to: CChar.self) { buff.update(fromContentsOf: $0) }
                    return buff.baseAddress!
                }
                self.storage = .init(ptr: UnsafePointer(nameC), freeFunction: { $0?.deallocate() })
                return (name: UnsafePointer(nameC), child: child.value)
            } else {
                self.storage = nil
                return (name: nil, child: child.value)
            }
        }
    }
}

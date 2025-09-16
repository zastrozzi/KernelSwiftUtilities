//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/02/2025.
//

import Foundation

extension KernelSwiftCommon.Reflection {
    public final class CStringStorage {
        let ptr: UnsafePointer<CChar>
        let freeFunction: (@convention(c) (UnsafePointer<CChar>?) -> Void)
        
        init(ptr: UnsafePointer<CChar>, freeFunction: @escaping @convention(c) (UnsafePointer<CChar>?) -> Void) {
            self.ptr = ptr
            self.freeFunction = freeFunction
        }
        
        deinit {
            self.freeFunction(self.ptr)
        }
    }
}

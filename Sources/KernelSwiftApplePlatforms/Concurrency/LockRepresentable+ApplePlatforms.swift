//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/10/2023.
//

import Foundation
import KernelSwiftCommon

extension LockRepresentable {
    public static func fromUnderlying() -> Self {
        return NSRecursiveLock() as! Self
    }
}
//
//extension LockRepresentable {
//    public init() {
//        fatalError()
//    }
//}

extension NSRecursiveLock: LockRepresentable {
    //    public init() {
    //
    //    }
}


//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 28/09/2023.
//

import Foundation
import KernelSwiftCommon
import NIOConcurrencyHelpers

//extension NIOLock: @retroactive LockRepresentable {}
extension NIOLock: LockRepresentable {}

extension LockRepresentable {
    public static func fromUnderlying() -> Self {
        return NIOLock() as! Self
    }
}

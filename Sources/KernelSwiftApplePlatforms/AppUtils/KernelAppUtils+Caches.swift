//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/10/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelAppUtils {
    public typealias SimpleMemoryCache<K: Hashable, V: Sendable> = KernelSwiftCommon.SimpleMemoryCache<K, V, NSRecursiveLock>
    public typealias LabelledMemoryCache<K: LabelRepresentable> = KernelSwiftCommon.LabelledMemoryCache<K, NSRecursiveLock>
    public typealias TaggedMemoryCache<T: Hashable & CaseIterable & Equatable, K: Hashable & Equatable, V: Sendable> = KernelSwiftCommon.TaggedMemoryCache<T, K, V, NSRecursiveLock>
}

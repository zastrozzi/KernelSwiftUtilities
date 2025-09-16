//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/10/2023.
//

import Foundation
import KernelSwiftCommon
import NIOConcurrencyHelpers

extension KernelServerPlatform {
    public typealias SimpleMemoryCache<K: Hashable, V: Sendable> = KernelSwiftCommon.SimpleMemoryCache<K, V, NIOLock>
    public typealias LabelledMemoryCache<K: LabelRepresentable> = KernelSwiftCommon.LabelledMemoryCache<K, NIOLock>
    public typealias TaggedMemoryCache<T: Hashable & CaseIterable & Equatable, K: Hashable & Equatable, V: Sendable> = KernelSwiftCommon.TaggedMemoryCache<T, K, V, NIOLock>
    public typealias TaggedDatedMemoryCache<T: Hashable & CaseIterable & Equatable, K: Hashable & Equatable, V: Sendable> = KernelSwiftCommon.TaggedDatedMemoryCache<T, K, V, NIOLock>
}

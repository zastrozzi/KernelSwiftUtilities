//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/04/2025.
//

extension KernelGoogleCloud {
    public struct Services: Sendable {
        public var cloudStorage: CloudStorageService
        public var storageBucket: StorageBucketService
        public var storageObject: StorageObjectService
        
        public init() {
            cloudStorage = .init()
            storageBucket = .init()
            storageObject = .init()
        }
    }
}

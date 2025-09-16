//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 09/04/2025.
//

@preconcurrency import Storage

extension KernelGoogleCloud.Core {
    public enum ClientAPIModel {}
}

extension KernelGoogleCloud.Core.ClientAPIModel {
    public typealias GCStorageBucketResponse = GoogleCloudStorageBucket
    public typealias GCStorageBucketListResponse = GoogleCloudStorageBucketList
    public typealias GCStorageObjectResponse = GoogleCloudStorageObject
    public typealias GCStorageObjectListResponse = StorageObjectList
}

extension KernelGoogleCloud.Core.ClientAPIModel.GCStorageBucketResponse: @retroactive @unchecked Sendable {}
extension KernelGoogleCloud.Core.ClientAPIModel.GCStorageBucketListResponse: @retroactive @unchecked Sendable {}
extension KernelGoogleCloud.Core.ClientAPIModel.GCStorageObjectResponse: @retroactive @unchecked Sendable {}
extension KernelGoogleCloud.Core.ClientAPIModel.GCStorageObjectListResponse: @retroactive @unchecked Sendable {}

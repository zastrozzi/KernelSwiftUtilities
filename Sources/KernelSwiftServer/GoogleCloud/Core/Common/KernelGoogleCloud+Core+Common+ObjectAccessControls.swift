//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/04/2025.
//

import struct Storage.ObjectAccessControls
import KernelSwiftCommon

extension KernelGoogleCloud.Core.Common {
    public struct ObjectAccessControls: OpenAPIContent {
        public var kind: String?
        public var id: String?
        public var selfLink: String?
        public var bucket: String?
        public var object: String?
        public var generation: String?
        public var entity: String?
        public var role: String?
        public var email: String?
        public var entityId: String?
        public var domain: String?
        public var projectTeam: ProjectTeam?
        public var etag: String?
        
        public init(
            kind: String? = nil,
            id: String? = nil,
            selfLink: String? = nil,
            bucket: String? = nil,
            object: String? = nil,
            generation: String? = nil,
            entity: String? = nil,
            role: String? = nil,
            email: String? = nil,
            entityId: String? = nil,
            domain: String? = nil,
            projectTeam: ProjectTeam? = nil,
            etag: String? = nil
        ) {
            self.kind = kind
            self.id = id
            self.selfLink = selfLink
            self.bucket = bucket
            self.object = object
            self.generation = generation
            self.entity = entity
            self.role = role
            self.email = email
            self.entityId = entityId
            self.domain = domain
            self.projectTeam = projectTeam
            self.etag = etag
        }
    }
}

extension Storage.ObjectAccessControls {
    public func toKernelGoogleCloud() -> KernelGoogleCloud.Core.Common.ObjectAccessControls {
        .init(
            kind: self.kind,
            id: self.id,
            selfLink: self.selfLink,
            bucket: self.bucket,
            object: self.object,
            generation: self.generation,
            entity: self.entity,
            role: self.role,
            email: self.email,
            entityId: self.entityId,
            domain: self.domain,
            projectTeam: self.projectTeam?.toKernelGoogleCloud(),
            etag: self.etag
        )
    }
}

//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/04/2025.
//

import struct Storage.ProjectTeam
import KernelSwiftCommon

extension KernelGoogleCloud.Core.Common {
    public struct ProjectTeam: OpenAPIContent {
        public var projectNumber: String?
        public var team: String?
        
        public init(
            projectNumber: String? = nil,
            team: String? = nil
        ) {
            self.projectNumber = projectNumber
            self.team = team
        }
    }
}

extension Storage.ProjectTeam {
    public func toKernelGoogleCloud() -> KernelGoogleCloud.Core.Common.ProjectTeam {
        .init(
            projectNumber: self.projectNumber,
            team: self.team
        )
    }
}

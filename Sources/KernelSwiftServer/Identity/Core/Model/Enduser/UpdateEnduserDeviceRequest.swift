//
//  File.swift
//
//
//  Created by Jonathan Forbes on 4/5/24.
//

import KernelSwiftCommon
import Vapor

extension KernelIdentity.Core.Model {
    public struct UpdateEnduserDeviceRequest: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public var localDeviceIdentifier: String?
     
        public init(
            localDeviceIdentifier: String? = nil
        ) {
            self.localDeviceIdentifier = localDeviceIdentifier
        }
    }
}

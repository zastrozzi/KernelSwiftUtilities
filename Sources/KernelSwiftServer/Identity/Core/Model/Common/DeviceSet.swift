//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 19/06/2024.
//

import KernelSwiftCommon
import Vapor

extension KernelIdentity.Core.Model {
    public enum DeviceSet: RawRepresentable, Codable, LosslessStringConvertible, Sendable {
        public var description: String { self.rawValue }
        
        case all
        case others
        case id(deviceId: UUID)
        
        public var rawValue: String {
            switch self {
            case .all: "all"
            case .others: "others"
            case let .id(deviceId): deviceId.uuidString
            }
        }
        
        public static let allCases: [KernelIdentity.Core.Model.DeviceSet] = [.all, .others]
        
        public init?(rawValue: String) {
            if let found = Self.allCases.first(where: { $0.rawValue == rawValue }) { self = found }
            else if let asUUID = UUID(uuidString: rawValue) { self = .id(deviceId: asUUID) }
            else { return nil }
        }
        
        public init?(_ description: String) {
            self.init(rawValue: description)
        }
    }
}


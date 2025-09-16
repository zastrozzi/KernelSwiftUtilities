//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/06/2024.
//

import KernelSwiftCommon

extension KernelFluentModel.Audit {
    public enum EventActionType: String, Codable, Equatable, CaseIterable, FluentStringEnum, LosslessStringConvertible {
        public var description: String { self.rawValue }
        public init?(_ description: String) {
            self.init(rawValue: description)
        }
        
        public static let fluentEnumName: String = "ksc-audit_event_action_type"
        
        case create
        case save
        case update
        case delete
        case restore
    }
}

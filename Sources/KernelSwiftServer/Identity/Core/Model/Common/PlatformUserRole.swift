//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 7/5/24.
//

import Foundation

extension KernelIdentity.Core.Model {
    public enum PlatformUserRole: String, Codable, Equatable, CaseIterable, FluentStringEnum {
        public static let fluentEnumName: String = "k_id-_platform_user_role"
        
        case enduser
        case adminUser
    }

}

//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 4/5/24.
//

import KernelSwiftCommon
import Vapor

extension KernelIdentity.Core.Model {
    public enum LoggableAdminUserActionType: String, Codable, Equatable, CaseIterable, FluentStringEnum {
        public static let fluentEnumName: String = "k_id-admin_user_action_type"
        case ADMIN_USER_SESSION_REGISTER
        case ADMIN_USER_SESSION_LOGIN
        case ADMIN_USER_SESSION_LOGOUT_CURRENT
        case ADMIN_USER_SESSION_LOGOUT_ALL
        case ADMIN_USER_SESSION_LOGOUT_BY_ID
        case ADMIN_USER_SESSION_REFRESH_CLOSE
        case ADMIN_USER_SESSION_REFRESH_OPEN
    }
}

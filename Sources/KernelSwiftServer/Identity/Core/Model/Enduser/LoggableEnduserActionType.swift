//
//  File.swift
//
//
//  Created by Jonathan Forbes on 4/5/24.
//

import KernelSwiftCommon
import Vapor

extension KernelIdentity.Core.Model {
    public enum LoggableEnduserActionType: String, Codable, Equatable, CaseIterable, FluentStringEnum {
        public static let fluentEnumName: String = "k_id-enduser_action_type"
        case ENDUSER_SESSION_REGISTER
        case ENDUSER_SESSION_LOGIN
        case ENDUSER_SESSION_LOGOUT_CURRENT
        case ENDUSER_SESSION_LOGOUT_ALL
        case ENDUSER_SESSION_LOGOUT_BY_ID
        case ENDUSER_SESSION_REFRESH_CLOSE
        case ENDUSER_SESSION_REFRESH_OPEN
    }
}

//
//  File.swift
//
//
//  Created by Jonathan Forbes on 30/4/24.
//

extension KernelIdentity {
    public enum Fluent: KernelServerPlatform.FluentContainer {}
}

extension KernelIdentity.Fluent {
    public enum SchemaName: String, KernelFluentNamespacedSchemaName {
        public static let namespace: String = "k_id"
        
        case adminUser = "admin_user"
        case adminUserCredential = "admin_user_credential"
        case adminUserDevice = "admin_user_device"
        case adminUserEmail = "admin_user_email"
        case adminUserPhone = "admin_user_phone"
        case adminUserSession = "admin_user_session"
        case adminUserAction = "admin_user_action"

        case enduser = "enduser"
        case enduserAddress = "enduser_address"
        case enduserCredential = "enduser_credential"
        case enduserDevice = "enduser_device"
        case enduserEmail = "enduser_email"
        case enduserPhone = "enduser_phone"
        case enduserSession = "enduser_session"
        case enduserAction = "enduser_action"
        
        case externalUser = "ext_user"
        case externalUserType = "ext_user_type"
        case externalUserAddress = "ext_user_address"
        case externalUserCredential = "ext_user_credential"
        case externalUserDevice = "ext_user_device"
        case externalUserEmail = "ext_user_email"
        case externalUserPhone = "ext_user_phone"
        case externalUserSession = "ext_user_session"
    }
}

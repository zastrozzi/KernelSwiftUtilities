//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 5/5/24.
//

import Foundation

extension KernelIdentity.Core.Model {
    public enum CredentialType: String, FluentStringEnum {
        public static let fluentEnumName: String = "k_id-credential_type"
        
        case emailPassword
        case googleOAuth
    }
}

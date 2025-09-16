//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 5/5/24.
//

extension KernelIdentity.Core.Model {
    public enum PhoneContactMethod: String, FluentStringEnum {
        public static let fluentEnumName: String = "k_id-phone_contact_method"
        case sms
        case whatsapp
        case voice
    }
}

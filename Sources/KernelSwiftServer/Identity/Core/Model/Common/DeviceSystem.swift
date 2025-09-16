//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 5/5/24.
//


extension KernelIdentity.Core.Model {
    public enum DeviceSystem: String, FluentStringEnum {
        public static let fluentEnumName: String = "k_id-device_system"
        
        case iOS
        case android
        case web
        case other
    }
}

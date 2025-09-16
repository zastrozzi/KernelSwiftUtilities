//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 23/06/2023.
//

import Vapor
import KernelSwiftCommon

//extension KernelCryptography {
//    public struct ServicesStorageKey: StorageKey {
//        public typealias Value = KernelCryptography.Services
//    }
//}

extension KernelCryptography {
    public enum ConfigKeys: LabelRepresentable {
        case keyGenCoreAllowance
        case defaultDatabaseID
        
        public var label: String {
            switch self {
            case .keyGenCoreAllowance: "keyGenCoreAllowance"
            case .defaultDatabaseID: "defaultDatabaseID"
            }
        }
    }
}

extension KernelCryptography {
    public struct Configuration {}
}

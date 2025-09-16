//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 03/07/2023.
//

extension KernelX509 {
    public enum Fluent: KernelServerPlatform.FluentContainer {}
}

extension KernelX509.Fluent {
    public enum SchemaName: String, KernelFluentNamespacedSchemaName {
        public static let namespace: String = "k_x509"
        
        case csrInfo = "csr_info"
        case rdnItem = "rdn_item"
        case v3Extension = "v3_ext"
        case certificate = "cert"
    }
}

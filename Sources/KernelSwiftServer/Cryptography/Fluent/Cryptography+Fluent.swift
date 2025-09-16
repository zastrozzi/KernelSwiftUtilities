//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 03/07/2023.
//

extension KernelCryptography {
    public enum Fluent: KernelServerPlatform.FluentContainer {}
}

extension KernelCryptography.Fluent {
    public enum SchemaName: String, KernelFluentNamespacedSchemaName, Sendable {
        public static let namespace: String = "k_crypto"
        
        case rsaSet = "rsa_set"
        case ecSet = "ec_set"
        case publicKey = "public_key"
        case privateKey = "private_key"
        case pkcs8EncryptionSet = "pkcs8_enc_set"
    }
}

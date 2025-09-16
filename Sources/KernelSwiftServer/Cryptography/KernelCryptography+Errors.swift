//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 27/06/2023.
//

import Vapor
import KernelSwiftCommon
/// TODO add  any other ecdsa speccific errors
extension KernelCryptography: ErrorTypeable {
    public enum ErrorTypes: String, KernelSwiftCommon.ErrorTypes {
        case invalidKeyLength
        case invalidAESBufferLength
        
        case rsaSetNotFound
        case ecSetNotFound
        
        case decodingRSAPrivateKeyFailed
        case decodingRSAPublicKeyFailed
        case decryptionFailed
        case encryptionFailed
        case signatureFailed
        case verificationFailed
        case rsaGenerationFailed
        
        case implementationMissing
        
        public var httpStatus: KernelSwiftCommon.Networking.HTTP.ResponseStatus {
            switch self {
            case .invalidKeyLength: .unprocessableEntity
            case .invalidAESBufferLength: .unprocessableEntity
                
            case .rsaSetNotFound: .notFound
            case .ecSetNotFound: .notFound
                
            case .decodingRSAPrivateKeyFailed: .internalServerError
            case .decodingRSAPublicKeyFailed: .internalServerError
            case .decryptionFailed: .internalServerError
            case .encryptionFailed: .internalServerError
            case .signatureFailed: .internalServerError
            case .verificationFailed: .internalServerError
            case .rsaGenerationFailed: .internalServerError
                
            case .implementationMissing: .notImplemented
            }
        }
        
        public var httpReason: String {
            switch self {
            case .invalidKeyLength: "Invalid Key Length"
            case .invalidAESBufferLength: "Invalid AES Buffer Length"
                
            case .rsaSetNotFound: "RSA Set Not Found"
            case .ecSetNotFound: "EC Set Not Found"
                
            case .decodingRSAPrivateKeyFailed: "Decoding RSA Private Key Failed"
            case .decodingRSAPublicKeyFailed: "Decoding RSA Public Key Failed"
            case .decryptionFailed: "Decryption Failed"
            case .encryptionFailed: "Encryption Failed"
            case .signatureFailed: "Signature Failed"
            case .verificationFailed: "Verification Failed"
            case .rsaGenerationFailed: "RSA Generation Failed"
                
            default: ""
            }
        }
    }
}

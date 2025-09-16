//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 27/04/2023.
//

import Foundation
import Vapor

public struct JSONWebKeyGeneratorServiceStorageKey: StorageKey {
    public typealias Value = JSONWebKeyGeneratorService
}

extension Application {
    public var jsonWebKeyGeneratorService: JSONWebKeyGeneratorService {
        get {
            guard let _jsonWebKeyGeneratorService: JSONWebKeyGeneratorService = self.storage[JSONWebKeyGeneratorServiceStorageKey.self] else {
                fatalError("JSONWebKeyGeneratorService not initialised")
            }
            return _jsonWebKeyGeneratorService
        }
        
        set {
            self.storage[JSONWebKeyGeneratorServiceStorageKey.self] = newValue
        }
    }
}

public final class JSONWebKeyGeneratorService: Sendable {
    let application: Application
    
    public init(
        application: Application
    ) {
        self.application = application
    }
    
    public func generateRSAPair(alg: RSAJSONWebKey.EncryptionAlgorithm) throws -> RSAJSONWebKey {
        
        fatalError("not complete")
    }
    
    public func generateRSAPair(alg: RSAJSONWebKey.SignatureAlgorithm) throws -> RSAJSONWebKey {
//        let x = kSecAttrKeyTypeRSA
        fatalError("Not implemented")
    }
}

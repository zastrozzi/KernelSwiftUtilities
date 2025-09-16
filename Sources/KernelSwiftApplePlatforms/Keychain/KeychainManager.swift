//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/04/2025.
//

import Foundation
import Security
import KernelSwiftCommon

extension KernelDI.Injector {
    public var keychainManager: KernelAppUtils.KeychainManager {
        get { self[KernelAppUtils.KeychainManager.Token.self] }
        set { self[KernelAppUtils.KeychainManager.Token.self] = newValue }
    }
}

extension KernelAppUtils {
    public final class KeychainManager: KernelDI.Injectable, KernelDI.ServiceLoggable, @unchecked Sendable {
        public typealias FeatureContainer = KernelAppUtils
        
        nonisolated required public init() {
            Self.logger.debug("Initialising KeychainManager")
        }
        
        enum KeychainError: Error {
            case duplicateEntry
            case unknown(OSStatus)
        }
        
        public func addToken(_ token: String, forKey key: String) throws {
            if let data = token.data(using: .utf8) {
                let query: [String: Any] = [
                    kSecClass as String: kSecClassGenericPassword,
                    kSecAttrAccount as String: key,
                    kSecValueData as String: data,
                    kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
                ]
                let status = SecItemAdd(query as CFDictionary, nil)
                guard status != errSecDuplicateItem else {
                    throw KeychainError.duplicateEntry
                }
                guard status == errSecSuccess else {
                    throw KeychainError.unknown(status)
                }
            }
        }
        
        public func upsertToken(_ token: String, forKey key: String) throws {
            if let _ = getToken(forKey: key) { try deleteToken(forKey: key) }
            try addToken(token, forKey: key)
        }
        
        public func getToken(forKey key: String) -> String? {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecReturnData as String: true,
                kSecMatchLimit as String: kSecMatchLimitOne
            ]
            var dataTypeRef: AnyObject?
            let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
            if status == errSecSuccess, let data = dataTypeRef as? Data {
                return String(data: data, encoding: .utf8)
            }
            return nil
        }
        
        public func deleteToken(forKey key: String) throws {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key
            ]
            let status = SecItemDelete(query as CFDictionary)
            guard status == errSecSuccess else {
                throw KeychainError.unknown(status)
            }
        }
    }
}

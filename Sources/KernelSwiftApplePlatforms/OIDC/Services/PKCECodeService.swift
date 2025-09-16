//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 06/09/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelDI.Injector {
    @available(iOS 17.0, macOS 14.0, *)
    public var oidcPKCECodeService: KernelAppUtils.OIDC.PKCECodeService {
        get { self[KernelAppUtils.OIDC.PKCECodeService.Token.self] }
        set { self[KernelAppUtils.OIDC.PKCECodeService.Token.self] = newValue }
    }
}

extension KernelAppUtils.OIDC {
    @Observable
    @available(iOS 17.0, macOS 14.0, *)
    public class PKCECodeService: KernelDI.Injectable, @unchecked Sendable {
        @ObservationIgnored
        private var storage: KernelAppUtils.SimpleMemoryCache<UUID, [UInt8]> = .init()
        
        required public init() {}
        
        public func generate(for context: UUID) throws {
            let bytes: [UInt8] = .generateSecRandom(count: 32)
//            guard SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes) == errSecSuccess else { throw TypedError(.pkceCodeGeneratorFailure) }
            storage.set(context, value: bytes)
//            guard let encoded: String = .init(bytes: encodeBase64(bytes, type: .url), encoding: .ascii) else { throw Error(.pkceCodeGeneratorFailure) }
//            return encoded
        }
        
        public func getChallenge(for context: UUID) throws -> String {
            guard let bytes = storage.get(context) else { throw TypedError(.pkceCodeGeneratorFailure) }
            let hash = KernelSwiftCommon.Cryptography.MD.hash(.SHA2_256, bytes)
            guard let encoded: String = .init(
                bytes: KernelSwiftCommon.Coding.Base64.encode(
                    Array<UInt8>.init(hash),
                    type: .url
                ),
                encoding: .utf8
            ) else { throw TypedError(.pkceCodeGeneratorFailure) }
            return encoded
        }
        
        public func getVerifier(for context: UUID) throws -> String {
            guard let bytes = storage.get(context) else { throw TypedError(.pkceCodeGeneratorFailure) }
            guard let encoded: String = .init(
                bytes: KernelSwiftCommon.Coding.Base64.encode(bytes, type: .url),
                encoding: .utf8
            ) else { throw TypedError(.pkceCodeGeneratorFailure) }
            return encoded
        }
    }
}

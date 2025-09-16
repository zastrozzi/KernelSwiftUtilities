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
    public var oidcCodeGeneratorService: KernelAppUtils.OIDC.CodeGeneratorService {
        get { self[KernelAppUtils.OIDC.CodeGeneratorService.Token.self] }
        set { self[KernelAppUtils.OIDC.CodeGeneratorService.Token.self] = newValue }
    }
    
//    @available(iOS 17.0, macOS 14.0, *)
//    public var oidcOldPKCECodeService: KernelAppUtils.OIDC.OldPKCECodeService {
//        get { self[KernelAppUtils.OIDC.OldPKCECodeService.Token.self] }
//        set { self[KernelAppUtils.OIDC.OldPKCECodeService.Token.self] = newValue }
//    }
}


extension KernelAppUtils.OIDC {
    @Observable
    @available(iOS 17.0, macOS 14.0, *)
    public class CodeGeneratorService: KernelDI.Injectable, @unchecked Sendable {
        @ObservationIgnored
        private var storage: KernelAppUtils.SimpleMemoryCache<UUID, [UInt8]> = .init()
        
        required public init() {}
        
        public func generate(for context: UUID) throws {
//            var bytes: [UInt8] = .zeroes(32)
//            guard SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes) == errSecSuccess else { throw TypedError(.pkceCodeGeneratorFailure) }
            let bytes: [UInt8] = .generateSecRandom(count: 32)
            storage.set(context, value: KernelSwiftCommon.Coding.Base64.encode(bytes, type: KernelSwiftCommon.Coding.Base64.Encoding.url))
        }
        
        public func getChallenge(for context: UUID) throws -> String {
            guard let bytes = storage.get(context) else { throw TypedError(.pkceCodeGeneratorFailure) }
            let hash = KernelSwiftCommon.Cryptography.MD.hash(.SHA2_256, bytes)
            guard let encoded: String = .init(bytes: KernelSwiftCommon.Coding.Base64.encode(hash, type: .url), encoding: .utf8) else {
                throw TypedError(.pkceCodeGeneratorFailure)
            }
            return encoded
        }
        
        public func getVerifier(for context: UUID) throws -> String {
            guard let bytes = storage.get(context) else { throw TypedError(.pkceCodeGeneratorFailure) }
            guard let encoded: String = .init(bytes: bytes, encoding: .utf8) else { throw TypedError(.pkceCodeGeneratorFailure) }
            return encoded
        }
    }
}

//extension KernelAppUtils.OIDC {
//    @Observable
//    @available(iOS 17.0, macOS 14.0, *)
//    public class OldPKCECodeService: KernelDI.Injectable, @unchecked Sendable {
//        @ObservationIgnored
//        private var storage: KernelAppUtils.SimpleMemoryCache<UUID, String> = .init()
//        
//        required public init() {}
//        
//        public func generate(for context: UUID) throws {
//            let bytes: [UInt8] = .generateSecRandom(count: 32)
////            guard SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes) == errSecSuccess else { throw TypedError(.pkceCodeGeneratorFailure) }
//            let verifier = Data(bytes).base64EncodedString()
//                .replacingOccurrences(of: "+", with: "-")
//                .replacingOccurrences(of: "/", with: "_")
//                .replacingOccurrences(of: "=", with: "")
//                .trimmingCharacters(in: .whitespaces)
//            storage.set(context, value: verifier)
//        }
//        
//        public func getChallenge(for context: UUID) throws -> String {
//            guard let verifier = storage.get(context) else { throw TypedError(.pkceCodeGeneratorFailure) }
//            let hash = KernelSwiftCommon.Cryptography.MD.hash(.SHA2_256, verifier.utf8Bytes)
//            guard let encoded: String = .init(bytes: KernelSwiftCommon.Coding.Base64.encode(hash, type: .url), encoding: .utf8) else {
//                throw TypedError(.pkceCodeGeneratorFailure)
//            }
//            return encoded
////                
////            
////            if let challenge = challenge {
////                return challenge
////            } else {
////                throw TypedError(.pkceCodeGeneratorFailure)
////            }
//        }
//        
//        public func getVerifier(for context: UUID) throws -> String {
//            guard let verifier = storage.get(context) else { throw TypedError(.pkceCodeGeneratorFailure) }
//            return verifier
//        }
//        
//        private func base64URLEncode<S>(octets: S) -> String where S : Sequence, UInt8 == S.Element {
//            let data = Data(octets)
//            return data
//                .base64EncodedString()
//                .replacingOccurrences(of: "=", with: "")
//                .replacingOccurrences(of: "+", with: "-")
//                .replacingOccurrences(of: "/", with: "_")
//                .trimmingCharacters(in: .whitespaces)
//        }
//    }
//}
//

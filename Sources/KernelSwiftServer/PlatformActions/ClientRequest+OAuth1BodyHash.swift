//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 18/11/2024.
//

import Vapor
import KernelSwiftCommon

extension ClientRequest {
    public mutating func addOAuth1AuthorisationHeader(
        consumerKey: String,
        signingPrivateKey: KernelCryptography.RSA.PrivateKey,
        alg: KernelSwiftCommon.Cryptography.Algorithms.MessageDigestAlgorithm
    ) throws {
        headers.add(
            contentsOf: try oAuth1AuthorisationHeaders(
                consumerKey: consumerKey,
                signingPrivateKey: signingPrivateKey,
                alg: alg
            )
        )
    }
    
    public func oAuth1AuthorisationHeaders(
        consumerKey: String,
        signingPrivateKey: KernelCryptography.RSA.PrivateKey,
        alg: KernelSwiftCommon.Cryptography.Algorithms.MessageDigestAlgorithm
    ) throws -> HTTPHeaders {
        var oAuth1Params = oAuth1Parameters(withKey: consumerKey, alg: alg)
        let sbs = try oAuth1SignatureBaseString(consumerKey: consumerKey, alg: alg, oAuth1Params: oAuth1Params)
        let signature = try signOAuth1SignatureBaseString(sbs: sbs, signingKey: signingPrivateKey, alg: alg)
        oAuth1Params["oauth_signature"] = signature
        var newHeaders = HTTPHeaders()
        newHeaders.add(name: .authorization, value: oAuth1AuthorisationString(oAuth1Params: oAuth1Params))
        return newHeaders
    }
    
    private func oAuth1AuthorisationString(oAuth1Params: [String: String]) -> String {
        var header = "OAuth "
        for (key, value) in oAuth1Params.sorted(by: {$0.0 < $1.0}) {
            header.append("\(key)=\"\(value)\",")
        }
        return String(header.dropLast())
    }
    
    private func signOAuth1SignatureBaseString(
        sbs: String,
        signingKey: KernelCryptography.RSA.PrivateKey,
        alg: KernelSwiftCommon.Cryptography.Algorithms.MessageDigestAlgorithm
    ) throws -> String {
        try signingKey.sign(.pkcs1, algorithm: alg, message: sbs.utf8Bytes).base64String().addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
    }
    
    private func oAuth1SignatureBaseString(
        consumerKey: String,
        alg: KernelSwiftCommon.Cryptography.Algorithms.MessageDigestAlgorithm,
        oAuth1Params: [String: String]
    ) throws -> String {
        let paramString = oAuth1ParamString(forQueryParameters: try uniqueQueryParams(), oAuth1Parameters: oAuth1Params)
        
        let generalDelimitersToEncode = ":#[]@/?"
        let subDelimitersToEncode = "!$&'()*+,;="
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        let escapedBaseUri = url.string.split(separator: "?").first!.lowercased().addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? ""
        
        return "\(method.rawValue)&\(escapedBaseUri)&\(paramString)"
    }
    
    private func oAuth1Parameters(withKey consumerKey: String, alg: KernelSwiftCommon.Cryptography.Algorithms.MessageDigestAlgorithm) -> [String: String] {
        var oAuthParams = [String: String]()
        let payload = body?.string ?? ""
        oAuthParams["oauth_body_hash"] = KernelSwiftCommon.Cryptography.MD.hash(
            alg,
            payload.utf8Bytes
        ).base64String()
        oAuthParams["oauth_consumer_key"] = consumerKey
        oAuthParams["oauth_nonce"] = makeOAuth1Nonce()
        oAuthParams["oauth_signature_method"] = alg.oAuthMethod
        oAuthParams["oauth_timestamp"] = currentOAuth1UnixTimestamp()
        oAuthParams["oauth_version"] = "1.0"
        return oAuthParams
    }
    
    private func oAuth1ParamString(
        forQueryParameters queryParameters: [String: Set<String>]?,
        oAuth1Parameters: [String: String]
    ) -> String {
        var allParameters = [(key: String, values: [String])]()
        
        let sortedOauthParams = oAuth1Parameters.sorted { $0.0 < $1.0 }.map { (key: $0.key, values: [$0.value])}
        allParameters += sortedOauthParams
        
        if let queryParams = queryParameters {
            allParameters += queryParams.sorted { $0.0 < $1.0 }.map {(key: $0.0, values: Array($0.value)) }
        }
        
        allParameters = allParameters.sorted { $0.0 < $1.0 }.map {(key: $0.0, values: Array($0.values)) }
        
        var paramString = allParameters.reduce(into: "") { combined, keyPair in
            keyPair.values.sorted().forEach { value in
                combined.append("\(keyPair.key)=\(value)&")
            }
        }
        
        if paramString.last! == "&" {
            paramString = String(paramString.dropLast())
        }
        
        var allowed = CharacterSet.alphanumerics
        allowed.insert(charactersIn: "-._~")
        return paramString.addingPercentEncoding(withAllowedCharacters: allowed) ?? ""
    }
    
    private func makeOAuth1Nonce() -> String { String.random(length: 16) }
    private func currentOAuth1UnixTimestamp() -> String { .init(Int(Date.now.timeIntervalSince1970)) }
    
    private func uniqueQueryParams() throws -> [String: Set<String>] {
        var queryParams = try query.decode([String: Set<String>].self)
        url.query?.split(separator: "&").forEach { queryParam in
            let keyValue = queryParam.split(separator: "=")
            let key = String(keyValue.first!)
            let value = String(keyValue.last!)
            queryParams[key, default: []].insert(value)
        }
        return queryParams
    }
}

extension KernelSwiftCommon.Cryptography.Algorithms.MessageDigestAlgorithm {
    public var oAuthMethod: String {
        switch self {
        case .SHA1: "HMAC-SHA1"
        case .SHA2_224: "RSA-SHA224"
        case .SHA2_256: "RSA-SHA256"
        case .SHA2_384: "RSA-SHA384"
        case .SHA2_512: "RSA-SHA512"
        case .SHA3_224: "RSA-SHA224"
        case .SHA3_256: "RSA-SHA256"
        case .SHA3_384: "RSA-SHA384"
        case .SHA3_512: "RSA-SHA512"
        }
    }
}

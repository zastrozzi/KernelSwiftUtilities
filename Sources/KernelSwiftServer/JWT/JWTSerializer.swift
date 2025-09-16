//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 27/10/2022.
//

import Foundation
//
//public struct JWTSerializer {
//    public func sign<Header: JWTHeaderProtocol, Claims: JWTPayload>(header: Header, claims: Claims, using signer: JWTSigner) throws -> String {
//        var mutatedHeader = header
//        mutatedHeader.alg = signer.algorithm.name
//        
//        let encoder = JSONEncoder()
//        encoder.dateEncodingStrategy = .custom({ (date, encoder) in
//            var container = encoder.singleValueContainer()
//            try container.encode(Int(date.timeIntervalSince1970))
//        })
//
//        let headerData = try encoder.encode(mutatedHeader)
//        let encodedHeader = headerData.base64URLEncodedBytes()
//
//        let payloadData = try encoder.encode(claims)
//        let encodedPayload = payloadData.base64URLEncodedBytes()
//
//        let signatureData = try signer.algorithm.sign(encodedHeader + [.ascii.period] + encodedPayload)
//
//        let bytes = encodedHeader + [.ascii.period] + encodedPayload + [.ascii.period] + signatureData.base64URLEncodedBytes()
//        return String(decoding: bytes, as: UTF8.self)
//    }
//}

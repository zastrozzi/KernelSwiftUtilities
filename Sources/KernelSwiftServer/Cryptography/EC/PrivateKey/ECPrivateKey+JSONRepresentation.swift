//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 16/11/2023.
//

import Foundation
import KernelSwiftCommon
import Vapor

extension KernelCryptography.EC.PrivateKey {
    public struct JSONRepresentation: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public var domain: KernelNumerics.EC.Curve
        public var secret: String
        public var x: String
        public var y: String
        
        public init(
            domain: KernelNumerics.EC.Curve,
            secret: String,
            x: String,
            y: String
        ) {
            self.domain = domain
            self.secret = secret
            self.x = x
            self.y = y
        }

        public init(from privateKey: KernelCryptography.EC.PrivateKey) {
            let p = privateKey.domain.generatePointForSecret(privateKey.s)
            self.domain = .oid(privateKey.domain.oid)
            self.secret = privateKey.s.toString()
            self.x = p.x.toString()
            self.y = p.y.toString()
        }
    }
}
//
//extension KernelCryptography.EC.PrivateKey.JSONRepresentation {
//    public static var sample: KernelCryptography.EC.PrivateKey.JSONRepresentation = {
//        let dom: KernelNumerics.EC.Domain = try! .init(fromOID: .x962Prime256v1)
//        let (sec, point) = dom.generateSecretAndPoint()
//        return .init(
//            domain: .oid(dom.oid),
//            secret: sec.toString(),
//            x: point.x.toString(),
//            y: point.y.toString()
//        )
//    }()
//}

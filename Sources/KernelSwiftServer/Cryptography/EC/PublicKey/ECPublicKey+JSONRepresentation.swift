//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 16/11/2023.
//

import Foundation
import KernelSwiftCommon
import Vapor

extension KernelCryptography.EC.PublicKey {
    public struct JSONRepresentation: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public var domain: KernelNumerics.EC.Curve
        public var x: String
        public var y: String
        
        public init(
            domain: KernelNumerics.EC.Curve,
            x: String,
            y: String
        ) {
            self.domain = domain
            self.x = x
            self.y = y
        }
        
        public init(from publicKey: KernelCryptography.EC.PublicKey) {
            self.domain = .oid(publicKey.domain.oid)
            self.x = publicKey.point.x.toString()
            self.y = publicKey.point.y.toString()
        }
    }
}

//extension KernelCryptography.EC.PublicKey.JSONRepresentation {
//    public static var sample: KernelCryptography.EC.PublicKey.JSONRepresentation = {
//        let dom: KernelNumerics.EC.Domain = try! .init(fromOID: .x962Prime256v1)
//        let (_, point) = dom.generateSecretAndPoint()
//        return .init(
//            domain: .oid(dom.oid),
//            x: point.x.toString(),
//            y: point.y.toString()
//        )
//    }()
//}

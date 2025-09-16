//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 24/09/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelSwiftCommon.Cryptography.Algorithms {
    public struct AlgorithmIdentifier: Sendable {
        public var algorithm: KernelASN1.ASN1AlgorithmIdentifier
        public var parameters: KernelASN1.ASN1Type?
        
        public init(
            algorithm: KernelASN1.ASN1AlgorithmIdentifier,
            parameters: KernelASN1.ASN1Type? = nil
        ) {
            self.algorithm = algorithm
            self.parameters = parameters
        }
        
    }
}

extension KernelSwiftCommon.Cryptography.Algorithms.AlgorithmIdentifier: ASN1Buildable {
    public func buildASN1Type() -> KernelASN1.ASN1Type {
        if let parameters {
            .sequence([
                algorithm.buildASN1Type(),
                parameters
            ])
        } else {
            .sequence([
                algorithm.buildASN1Type()
            ])
        }
    }
}

extension KernelSwiftCommon.Cryptography.Algorithms.AlgorithmIdentifier: ASN1Decodable {
    public init(from asn1Type: KernelASN1.ASN1Type) throws {
        guard case let .sequence(sequenceItems) = asn1Type else { throw Self.decodingError(.sequence, asn1Type) }
        if sequenceItems.count == 1 {
            self.algorithm = try .init(from: sequenceItems[0])
            self.parameters = nil
        }
        else if sequenceItems.count == 2 {
            self.algorithm = try .init(from: sequenceItems[0])
            self.parameters = sequenceItems[1]
        }
        else { throw Self.decodingError(.sequence, asn1Type) }
    }
}

extension KernelCryptography.Algorithms {
    public typealias AlgorithmIdentifier = KernelSwiftCommon.Cryptography.Algorithms.AlgorithmIdentifier
}

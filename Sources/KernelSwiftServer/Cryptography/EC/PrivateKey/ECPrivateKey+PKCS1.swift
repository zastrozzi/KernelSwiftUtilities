//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/11/2023.
//

import KernelSwiftCommon

extension KernelCryptography.EC.PrivateKey {
    public init(
        pkcs1 sequence: [KernelASN1.ASN1Type],
        domainOID: KernelSwiftCommon.ObjectID? = nil,
        keyFormat: KernelCryptography.EC.KeyFormat = .pkcs1
    ) throws {
        var domainOID = domainOID
        guard
            case let .integer(version)              = sequence[0],
            version.int                             == .one,
            case let .octetString(sOctet)           = sequence[1],
            case let .tagged(1, taggedPointType)    = domainOID == nil ? sequence[3] : sequence[2],
            case let .constructed(pointItems)       = taggedPointType,
            !pointItems.isEmpty,
            case let .bitString(pointBitStr)        = pointItems[0]
        else { throw Self.decodingError(.sequence, .sequence(sequence)) }
        
        if domainOID == nil {
            guard
                case let .tagged(0, taggedDomainType)   = sequence[2],
                case let .constructed(domainItems)      = taggedDomainType,
                !domainItems.isEmpty,
                case let .objectIdentifier(domainID)   = domainItems[0],
                domainID.oid != nil
            else { throw Self.decodingError(.sequence, .sequence(sequence)) }
            domainOID = domainID.oid
        }
        guard let domainOID else { throw Self.decodingError(.sequence, .sequence(sequence)) }
        let domain: KernelNumerics.EC.Domain = try .init(fromOID: domainOID)
        let point = try domain.decode(pointBitStr.value)
        guard domain.contains(point) else { throw KernelCryptography.TypedError(.verificationFailed) }
        self.init(domain: domain, s: .init(magnitudeBytes: sOctet.value), keyFormat: keyFormat)
    }
    
    public func buildASN1TypePKCS1(skipDomain: Bool = false) -> KernelASN1.ASN1Type {
        let encodedP = domain.encode(domain.generatePointForSecret(s))
        if skipDomain {
            return .sequence([
                .integer(.init(data: [0x01])),
                .octetString(.init(data: Array(s.magnitudeBytes()))),
                .tagged(1, .constructed([.bitString(.init(unusedBits: 0, data: encodedP))]))
            ])
        } else {
            return .sequence([
                .integer(.init(data: [0x01])),
                .octetString(.init(data: Array(s.magnitudeBytes()))),
                .tagged(0, .constructed([.objectIdentifier(.init(oid: domain.oid))])),
                .tagged(1, .constructed([.bitString(.init(unusedBits: 0, data: encodedP))]))
            ])
        }
        
    }
}

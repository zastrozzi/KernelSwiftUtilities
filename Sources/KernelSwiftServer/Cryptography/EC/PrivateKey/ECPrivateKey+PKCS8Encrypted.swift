//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/11/2023.
//

import KernelSwiftCommon

extension KernelCryptography.EC.PrivateKey {
    public init(pkcs8Encrypted asn1Type: KernelASN1.ASN1Type, password: [UInt8]) throws {
        guard
            case let .sequence(sequence)            = asn1Type,
            case let .sequence(encryptSeq)          = sequence[0],
            case let .octetString(pkcs8OctStr)      = sequence[1]
        else { throw Self.decodingError(.sequence, asn1Type) }
        
        guard
            case let .objectIdentifier(pbesOID)     = encryptSeq[0],
            pbesOID.oid                             == .pkcs5PBES2,
            case let .sequence(pbesSeq)             = encryptSeq[1]
        else { throw Self.decodingError(.sequence, .sequence(encryptSeq)) }
        
        guard
            case let .sequence(pbkdfSeq)            = pbesSeq[0],
            case let .sequence(cbcSeq)              = pbesSeq[1],
            case let .objectIdentifier(pbkdfOID)    = pbkdfSeq[0],
            pbkdfOID.oid                            == .pkcs5PBKDF2
        else { throw Self.decodingError(.sequence, .sequence(encryptSeq)) }
        
        guard
            case let .sequence(saltSeq)             = pbkdfSeq[1],
            case let .octetString(saltOctStr)       = saltSeq[0],
            case let .objectIdentifier(cbcID)       = cbcSeq[0],
            let cbcOID = cbcID.oid,
            case let .octetString(vecOctStr)        = cbcSeq[1]
        else { throw Self.decodingError(.sequence, .sequence(encryptSeq)) }
        
        let aes: KernelCryptography.AES.KeySize = try .init(oid: cbcOID)
        let key = KernelCryptography.HMAC.deriveKeySHA1(password, saltOctStr.value, aes.byteWidth)
        var cipher = KernelCryptography.Cipher.initialise(kdf: false, aes, KernelCryptography.Cipher.CBC.self, key, [], vecOctStr.value)
        var pkcsBytes = pkcs8OctStr.value
        try cipher.decrypt(&pkcsBytes)
        
        guard case let .sequence(pkcs8Seq) = try KernelASN1.ASN1Parser4.objectFromBytes(pkcsBytes).asn1() else {
            throw Self.decodingError(.sequence, .sequence(encryptSeq))
        }
        
        try self.init(pkcs8: pkcs8Seq, keyFormat: .pkcs8Encrypted(password: password, aes: aes))
    }
    
    public func buildEncryptedPKCS8(password: [UInt8], aes: KernelCryptography.AES.KeySize) -> KernelASN1.ASN1Type {
        let salt: [UInt8] = .generateSecRandom(count: 8)
        let key = KernelCryptography.HMAC.deriveKeySHA1(password, salt, aes.byteWidth)
        let vec: [UInt8] = .generateSecRandom(count: KernelCryptography.AES.val.blockSize)
        var cipher = KernelCryptography.Cipher.initialise(kdf: false, aes, KernelCryptography.Cipher.CBC.self, key, [], vec)
        var pkcs8Bytes = KernelASN1.ASN1Writer.dataFromObject(buildASN1TypePKCS8(pkcs8Domain: true))
        do { try cipher.encrypt(&pkcs8Bytes) }
        catch {
            print(error.localizedDescription)
            pkcs8Bytes = []
        }
        
        return .sequence([
            .sequence([
                .objectIdentifier(.init(oid: .pkcs5PBES2)),
                .sequence([
                    .sequence([
                        .objectIdentifier(.init(oid: .pkcs5PBKDF2)),
                        .sequence([
                            .octetString(.init(data: salt)),
                            .integer(.init(int: .init(KernelCryptography.AES.val.keyDerivationIterations)))
                        ])
                    ]),
                    .sequence([
                        .objectIdentifier(.init(oid: aes.cbc_oid)),
                        .octetString(.init(data: vec))
                    ])
                ])
            ]),
            .octetString(.init(data: pkcs8Bytes))
        ])
    }
}

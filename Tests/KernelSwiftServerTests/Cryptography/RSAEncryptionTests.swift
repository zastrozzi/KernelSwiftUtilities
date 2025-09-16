//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 13/10/2023.
//

import Testing
import KernelSwiftServer
import KernelSwiftCommon
import Foundation

@Suite
public struct RSAEncryptionTests {
    @Test(
        arguments: [
            KernelCryptography.RSA.KeySize.b512,
            KernelCryptography.RSA.KeySize.b768,
            KernelCryptography.RSA.KeySize.b1024,
            KernelCryptography.RSA.KeySize.b1280,
            KernelCryptography.RSA.KeySize.b1536,
            KernelCryptography.RSA.KeySize.b2048,
            KernelCryptography.RSA.KeySize.b3072,
            KernelCryptography.RSA.KeySize.b4096
        ],
        [2]
    )
    public func rsaEncryptionPKCS1(keySize: KernelCryptography.RSA.KeySize, rounds: Int = 10) async throws {
        let publicPKCS1 = keySize.testSamplePublicKey
        let privatePKCS1 = keySize.testSamplePrivateKey
//        KernelASN1.ASN1Printer.printObjectVerbose(pkcs1Parsed, decodedOctets: true, decodedBits: true)
        lengthLoop: for l in [0, KernelCryptography.RSA.EncryptionMode.pkcs1.maximumMessageSize(for: keySize)] {
            let s = ProcessInfo.processInfo.systemUptime
            for r in 0..<rounds {
                let message: [UInt8] = .fill(l, with: .random(in: .min...(.max)))
                do {
                    let encrypted = try publicPKCS1.encrypt(.pkcs1, message: message)
                    let decrypted = try privatePKCS1.decrypt(.pkcs1, cipher: encrypted)
                    #expect(message == decrypted)
                } catch {
                    print("PKCS1 RSA\(keySize.intValue) - [L: \(l), R: \(r)] ERROR", error.localizedDescription)
                    continue lengthLoop
                }
            }
            print("PKCS1 RSA\(keySize.intValue) - [L: \(l)] AVERAGE", (ProcessInfo.processInfo.systemUptime - s) / .init(rounds))
        }
        
    }

    @Test(
        arguments: [
            KernelCryptography.RSA.KeySize.b512,
            KernelCryptography.RSA.KeySize.b768,
            KernelCryptography.RSA.KeySize.b1024,
            KernelCryptography.RSA.KeySize.b1280,
            KernelCryptography.RSA.KeySize.b1536,
            KernelCryptography.RSA.KeySize.b2048,
            KernelCryptography.RSA.KeySize.b3072,
            KernelCryptography.RSA.KeySize.b4096
        ],
        KernelCryptography.Algorithms.MessageDigestAlgorithm.allCases
    )
    public func rsaEncryptionOAEPAllAlgs(keySize: KernelCryptography.RSA.KeySize, alg: KernelCryptography.Algorithms.MessageDigestAlgorithm) async throws {
        let rounds: Int = 2
        let publicPKCS1 = keySize.testSamplePublicKey
        let privatePKCS1 = keySize.testSamplePrivateKey
//        algsLoop: for alg in Self.encAlgs {
            lengthLoop: for l in [0, KernelCryptography.RSA.EncryptionMode.oaep(algorithm: alg).maximumMessageSize(for: keySize)] {
                let s = ProcessInfo.processInfo.systemUptime
                for r in 0..<rounds {
                    let message: [UInt8] = .fill(l, with: .random(in: .min...(.max)))
                    do {
                        let encrypted = try publicPKCS1.encrypt(.oaep(algorithm: alg), message: message)
                        let decrypted = try privatePKCS1.decrypt(.oaep(algorithm: alg), cipher: encrypted)
                        #expect(message == decrypted)
                    } catch {
                        print("OAEP RSA\(keySize.intValue) \(alg.rawValue) - [L: \(l), R: \(r)] ERROR", error.localizedDescription)
//                        continue algsLoop
                    }
                }
                print("OAEP RSA\(keySize.intValue) \(alg.rawValue) - [L: \(l)] AVERAGE", (ProcessInfo.processInfo.systemUptime - s) / .init(rounds))
//            }
        }
    }
}

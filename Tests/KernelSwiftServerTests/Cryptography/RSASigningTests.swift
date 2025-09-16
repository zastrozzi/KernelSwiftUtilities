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
public struct RSASignatureTests {
    
//    public func testRSASignaturePKCS1AllAlgs512() async throws { try await rsaSignaturePKCS1AllAlgs(keySize: .b512,  rounds: 2) }
//    public func testRSASignaturePKCS1AllAlgs768() async throws { try await rsaSignaturePKCS1AllAlgs(keySize: .b768,  rounds: 2) }
//    public func testRSASignaturePKCS1AllAlgs1024() async throws { try await rsaSignaturePKCS1AllAlgs(keySize: .b1024, rounds: 2) }
//    public func testRSASignaturePKCS1AllAlgs1280() async throws { try await rsaSignaturePKCS1AllAlgs(keySize: .b1280, rounds: 2) }
//    public func testRSASignaturePKCS1AllAlgs1536() async throws { try await rsaSignaturePKCS1AllAlgs(keySize: .b1536, rounds: 2) }
//    public func testRSASignaturePKCS1AllAlgs2048() async throws { try await rsaSignaturePKCS1AllAlgs(keySize: .b2048, rounds: 2) }
//    public func testRSASignaturePKCS1AllAlgs3072() async throws { try await rsaSignaturePKCS1AllAlgs(keySize: .b3072, rounds: 2) }
//    public func testRSASignaturePKCS1AllAlgs4096() async throws { try await rsaSignaturePKCS1AllAlgs(keySize: .b4096, rounds: 2) }
//    
//    public func testRSASignaturePSSAllAlgs512() async throws { try await rsaSignaturePSSAllAlgs(keySize: .b512,  rounds: 2) }
//    public func testRSASignaturePSSAllAlgs768() async throws { try await rsaSignaturePSSAllAlgs(keySize: .b768,  rounds: 2) }
//    public func testRSASignaturePSSAllAlgs1024() async throws { try await rsaSignaturePSSAllAlgs(keySize: .b1024, rounds: 2) }
//    public func testRSASignaturePSSAllAlgs1280() async throws { try await rsaSignaturePSSAllAlgs(keySize: .b1280, rounds: 2) }
//    public func testRSASignaturePSSAllAlgs1536() async throws { try await rsaSignaturePSSAllAlgs(keySize: .b1536, rounds: 2) }
//    public func testRSASignaturePSSAllAlgs2048() async throws { try await rsaSignaturePSSAllAlgs(keySize: .b2048, rounds: 2) }
//    public func testRSASignaturePSSAllAlgs3072() async throws { try await rsaSignaturePSSAllAlgs(keySize: .b3072, rounds: 2) }
//    public func testRSASignaturePSSAllAlgs4096() async throws { try await rsaSignaturePSSAllAlgs(keySize: .b4096, rounds: 2) }
    
    #if DEBUG
    public static let sigAlgs: [KernelCryptography.Algorithms.MessageDigestAlgorithm] = [.SHA1]
    #else
    public static let sigAlgs = KernelCryptography.Algorithms.MessageDigestAlgorithm.allCases
    #endif
    
    
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
    public func rsaSignatureAllAlgs(keySize: KernelCryptography.RSA.KeySize, rounds: Int) async throws {
        let publicPKCS1 = keySize.testSamplePublicKey
        let privatePKCS1 = keySize.testSamplePrivateKey
        algsLoop: for alg in Self.sigAlgs {
            var sSum: Double = 0
            var vSum: Double = 0
            for _ in 0..<rounds {
                let message: [UInt8] = .init(fromHexString: "10000000000000000000000000000000000000000000000000000000000000000000000000000000")!
                do {
                    let s = ProcessInfo.processInfo.systemUptime
                    let signature = try privatePKCS1.sign(algorithm: alg, message: message)
                    sSum += (ProcessInfo.processInfo.systemUptime - s) / .init(rounds)
                    let v = ProcessInfo.processInfo.systemUptime
                    let verified = publicPKCS1.verify(algorithm: alg, signature: signature, message: message)
                    vSum += (ProcessInfo.processInfo.systemUptime - v) / .init(rounds)
                    #expect(verified)
                } catch {
                    print("\(alg.signatureMode) RSA\(keySize.intValue) - \(alg.rawValue) ERROR", error.localizedDescription)
                    continue algsLoop
                }
                
            }
            print("\(alg.signatureMode) RSA\(keySize.intValue) - \(alg.rawValue) AVERAGES: S - \(sSum) | V - \(vSum)")
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
        [2]
    )
    public func rsaSignaturePKCS1AllAlgs(keySize: KernelCryptography.RSA.KeySize, rounds: Int) async throws {
        let publicPKCS1 = keySize.testSamplePublicKey
        let privatePKCS1 = keySize.testSamplePrivateKey
        algsLoop: for alg in Self.sigAlgs {
            lengthLoop: for l in [0, KernelCryptography.RSA.EncryptionMode.pkcs1.maximumMessageSize(for: keySize)] {
                var sSum: Double = 0
                var vSum: Double = 0
                for r in 0..<rounds {
                    let message: [UInt8] = .fill(l, with: .random(in: .min...(.max)))
                    do {
                        let s = ProcessInfo.processInfo.systemUptime
                        let signature = try privatePKCS1.sign(.pkcs1, algorithm: alg, message: message)
                        sSum += (ProcessInfo.processInfo.systemUptime - s) / .init(rounds)
                        let v = ProcessInfo.processInfo.systemUptime
                        let verified = publicPKCS1.verify(.pkcs1, algorithm: alg, signature: signature, message: message)
                        vSum += (ProcessInfo.processInfo.systemUptime - v) / .init(rounds)
                        #expect(verified)
                    } catch {
                        print("PKCS1 RSA\(keySize.intValue) - \(alg.rawValue) [L: \(l), R: \(r)] ERROR", error.localizedDescription)
                        continue algsLoop
                    }
                }
                print("PKCS1 RSA\(keySize.intValue) - \(alg.rawValue) [L: \(l)] AVERAGES: S - \(sSum) | V - \(vSum)")
            }
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
        [2]
    )
    public func rsaSignaturePSSAllAlgs(keySize: KernelCryptography.RSA.KeySize, rounds: Int) async throws {
        let publicPKCS1 = keySize.testSamplePublicKey
        let privatePKCS1 = keySize.testSamplePrivateKey
        algsLoop: for alg in Self.sigAlgs {
            lengthLoop: for l in [0, KernelCryptography.RSA.EncryptionMode.pkcs1.maximumMessageSize(for: keySize)] {
                var sSum: Double = 0
                var vSum: Double = 0
                for r in 0..<rounds {
                    let message: [UInt8] = .fill(l, with: .random(in: .min...(.max)))
                    do {
                        let s = ProcessInfo.processInfo.systemUptime
                        let signature = try privatePKCS1.sign(.pss, algorithm: alg, message: message)
                        sSum += (ProcessInfo.processInfo.systemUptime - s) / .init(rounds)
                        let v = ProcessInfo.processInfo.systemUptime
                        let verified = publicPKCS1.verify(.pss, algorithm: alg, signature: signature, message: message)
                        vSum += (ProcessInfo.processInfo.systemUptime - v) / .init(rounds)
                        #expect(verified)
                    } catch {
                        print("PSS RSA\(keySize.intValue) - \(alg.rawValue) [L: \(l), R: \(r)] ERROR", error.localizedDescription)
                        continue algsLoop
                    }
                }
                print("PSS RSA\(keySize.intValue) - \(alg.rawValue) [L: \(l)] AVERAGES: S - \(sSum) | V - \(vSum)")
            }
        }
    }
}


//
//  File.swift
//
//
//  Created by Jonathan Forbes on 14/09/2023.
//

//import XCTest
import Testing
import KernelSwiftServer
import KernelSwiftCommon
//import Vapor


@Suite
public struct RSATests {
    #if DEBUG
    static let rsaKeySizes: [KernelCryptography.RSA.KeySize] = [.b256, .b512, .b768, .b1024]
    #else
    static let rsaKeySizes: [KernelCryptography.RSA.KeySize] = [.b256, .b512, .b768, .b1024, .b1280, .b1536, .b2048]
    #endif
    
    @Test(
        arguments: rsaKeySizes
    )
    func rsaRoundTrip(keySize: KernelCryptography.RSA.KeySize) async throws {
        let comp: KernelCryptography.RSA.Components = try await .init(keySize: keySize, concurrentCoreCount: 10)
        let privateKeyPKCS1PEM: KernelASN1.PEMFile = .init(for: .rsaPrivateKey, from: comp.privateKey(.pkcs1))
        let privateKeyPKCS8PEM: KernelASN1.PEMFile = .init(for: .privateKey, from: comp.privateKey(.pkcs8))
        let publicKeyPKCS1PEM: KernelASN1.PEMFile = .init(for: .rsaPublicKey, from: comp.publicKey(.pkcs1))
        let publicKeyPKCS8PEM: KernelASN1.PEMFile = .init(for: .publicKey, from: comp.publicKey(.pkcs8))
        guard
            let pkcs1Parsed = try KernelASN1.ASN1Parser4.objectFromPEM(pemString: privateKeyPKCS1PEM.pemString),
            let pkcs8Parsed = try KernelASN1.ASN1Parser4.objectFromPEM(pemString: privateKeyPKCS8PEM.pemString),
            let pkcs1PubParsed = try KernelASN1.ASN1Parser4.objectFromPEM(pemString: publicKeyPKCS1PEM.pemString),
            let pkcs8PubParsed = try KernelASN1.ASN1Parser4.objectFromPEM(pemString: publicKeyPKCS8PEM.pemString)
        else { throw KernelASN1.TypedError(.decodingFailed) }
        print("----- PKCS 1 RSA\(keySize.intValue) -----")
        KernelASN1.ASN1Printer.printObjectVerbose(pkcs1Parsed, decodedOctets: true, decodedBits: true)
        print("----- PKCS 8 RSA\(keySize.intValue) -----")
        KernelASN1.ASN1Printer.printObjectVerbose(pkcs8Parsed, decodedOctets: true, decodedBits: true)
        print("----- PKCS 1 PUBLIC RSA\(keySize.intValue) -----")
        KernelASN1.ASN1Printer.printObjectVerbose(pkcs1PubParsed, decodedOctets: true, decodedBits: true)
        print("----- PKCS 8 PUBLIC RSA\(keySize.intValue) -----")
        KernelASN1.ASN1Printer.printObjectVerbose(pkcs8PubParsed, decodedOctets: true, decodedBits: true)
        let privateKeyPKCS1: KernelCryptography.RSA.PrivateKey = try .init(from: pkcs1Parsed.asn1())
        let privateKeyPKCS8: KernelCryptography.RSA.PrivateKey = try .init(from: pkcs8Parsed.asn1())
        let privateKeyPKCS1RecPEM: KernelASN1.PEMFile = .init(for: .rsaPrivateKey, from: privateKeyPKCS1)
        let privateKeyPKCS8RecPEM: KernelASN1.PEMFile = .init(for: .privateKey, from: privateKeyPKCS8)
        let publicKeyPKCS1: KernelCryptography.RSA.PublicKey = try .init(from: pkcs1PubParsed.asn1())
        let publicKeyPKCS8: KernelCryptography.RSA.PublicKey = try .init(from: pkcs8PubParsed.asn1())
        let publicKeyPKCS1RecPEM: KernelASN1.PEMFile = .init(for: .rsaPublicKey, from: publicKeyPKCS1)
        let publicKeyPKCS8RecPEM: KernelASN1.PEMFile = .init(for: .publicKey, from: publicKeyPKCS8)
        guard
            let pkcs1ParsedRec = try KernelASN1.ASN1Parser4.objectFromPEM(pemString: privateKeyPKCS1RecPEM.pemString),
            let pkcs8ParsedRec = try KernelASN1.ASN1Parser4.objectFromPEM(pemString: privateKeyPKCS8RecPEM.pemString),
            let pkcs1PubParsedRec = try KernelASN1.ASN1Parser4.objectFromPEM(pemString: publicKeyPKCS1RecPEM.pemString),
            let pkcs8PubParsedRec = try KernelASN1.ASN1Parser4.objectFromPEM(pemString: publicKeyPKCS8RecPEM.pemString)
        else { throw KernelASN1.TypedError(.decodingFailed) }
        print("----- PKCS 1 REC RSA\(keySize.intValue) -----")
        KernelASN1.ASN1Printer.printObjectVerbose(pkcs1ParsedRec, decodedOctets: true, decodedBits: true)
        print("----- PKCS 8 REC RSA\(keySize.intValue) -----")
        KernelASN1.ASN1Printer.printObjectVerbose(pkcs8ParsedRec, decodedOctets: true, decodedBits: true)
        print("----- PKCS 1 PUBLIC REC RSA\(keySize.intValue) -----")
        KernelASN1.ASN1Printer.printObjectVerbose(pkcs1PubParsedRec, decodedOctets: true, decodedBits: true)
        print("----- PKCS 8 PUBLIC REC RSA\(keySize.intValue) -----")
        KernelASN1.ASN1Printer.printObjectVerbose(pkcs8PubParsedRec, decodedOctets: true, decodedBits: true)
        print("----- PKCS 1 PEM RSA\(keySize.intValue) -----")
        print(privateKeyPKCS1RecPEM.pemString)
        print("----- PKCS 8 PEM RSA\(keySize.intValue) -----")
        print(privateKeyPKCS8RecPEM.pemString)
        print("----- PKCS 1 PEM PUBLIC RSA\(keySize.intValue) -----")
        print(publicKeyPKCS1RecPEM.pemString)
        print("----- PKCS 8 PEM PUBLIC RSA\(keySize.intValue) -----")
        print(publicKeyPKCS8RecPEM.pemString)
        let privateKeyPKCS1Rec: KernelCryptography.RSA.PrivateKey = try .init(from: pkcs1ParsedRec.asn1())
        let privateKeyPKCS8Rec: KernelCryptography.RSA.PrivateKey = try .init(from: pkcs8ParsedRec.asn1())
        let publicKeyPKCS1Rec: KernelCryptography.RSA.PublicKey = try .init(from: pkcs1PubParsedRec.asn1())
        let publicKeyPKCS8Rec: KernelCryptography.RSA.PublicKey = try .init(from: pkcs8PubParsedRec.asn1())
        #expect(comp.n == privateKeyPKCS1.n)
        #expect(comp.n == privateKeyPKCS8.n)
        #expect(comp.e == privateKeyPKCS1.e)
        #expect(comp.e == privateKeyPKCS8.e)
        #expect(comp.d == privateKeyPKCS1.d)
        #expect(comp.d == privateKeyPKCS8.d)
        #expect(comp.p == privateKeyPKCS1.p)
        #expect(comp.p == privateKeyPKCS8.p)
        #expect(comp.q == privateKeyPKCS1.q)
        #expect(comp.q == privateKeyPKCS8.q)
        #expect(comp.n == publicKeyPKCS1.n)
        #expect(comp.n == publicKeyPKCS8.n)
        #expect(comp.e == publicKeyPKCS1.e)
        #expect(comp.e == publicKeyPKCS8.e)
        
        #expect(comp.n == privateKeyPKCS1Rec.n)
        #expect(comp.n == privateKeyPKCS8Rec.n)
        #expect(comp.e == privateKeyPKCS1Rec.e)
        #expect(comp.e == privateKeyPKCS8Rec.e)
        #expect(comp.d == privateKeyPKCS1Rec.d)
        #expect(comp.d == privateKeyPKCS8Rec.d)
        #expect(comp.p == privateKeyPKCS1Rec.p)
        #expect(comp.p == privateKeyPKCS8Rec.p)
        #expect(comp.q == privateKeyPKCS1Rec.q)
        #expect(comp.q == privateKeyPKCS8Rec.q)
        #expect(comp.n == publicKeyPKCS1Rec.n)
        #expect(comp.n == publicKeyPKCS8Rec.n)
        #expect(comp.e == publicKeyPKCS1Rec.e)
        #expect(comp.e == publicKeyPKCS8Rec.e)
    }
    
    @Test
    func testRSA4096UInt() async throws {
        let d: KernelNumerics.BigInt = .init("195248711011744793939364013142851705109525283442141846707383259776437381009706922409030182839303120851801348500189178565087523478139202276982469684899675431510425573801709023732389087209034311883277260097615130417981771002503985053130280062534644859298361015546035084411042434568251719974038037888015113697932570213584452752255828821590062679733332252370113125346319877796116290813379677645927537228840503385152972511611807612498624534682304620473791092159344653029059040650135335622951409193186560156755117672675258410576243940930926069117629512252258105950641654261942637424427623746706920306677224451960080342001290957861049152832495306887978268660984315415911156548137198202501201186082657461943040714914945672092742714029591089391163052733744091452597639208342138524422635673212334590398698472311921585728155257248360608296866370752554153541386529373603209579929620512355175622240465615154736322719746968303451879970114772110963383671223308930683851422223601403939905497385342453165811217946275209028925086775116817071905272356650132712558468533393319971435746390646463205866189553648356691248826666497370549639370783947554392392478668250477868630285285145108483840560021577710422345868820845350497237509095853612600249956142153")!
        
        print("D BITS RSA PRIVATE", d.bitWidth)
        let dBytes = KernelASN1.ASN1Writer.dataFromObject(.integer(.init(data: d.signedBytes(), exactLength: KernelCryptography.RSA.KeySize.b4096.byteWidth)))
        print("D BYTES")
        print(d)
        print(dBytes.toHexString())
    }
    
    @Test
    func testRSA4096FromPEM() async throws {
        guard let parsedPublicPKCS1 = try KernelASN1.ASN1Parser4.objectFromPEM(pemString: RSAPEMStrings.rsa4096pkcs1public) else { throw KernelASN1.TypedError(.decodingFailed) }
        guard let parsedPublicPKCS8 = try KernelASN1.ASN1Parser4.objectFromPEM(pemString: RSAPEMStrings.rsa4096pkcs8public) else { throw KernelASN1.TypedError(.decodingFailed) }
        guard let parsedPrivatePKCS1 = try KernelASN1.ASN1Parser4.objectFromPEM(pemString: RSAPEMStrings.rsa4096pkcs1private) else { throw KernelASN1.TypedError(.decodingFailed) }
        guard let parsedPrivatePKCS8 = try KernelASN1.ASN1Parser4.objectFromPEM(pemString: RSAPEMStrings.rsa4096pkcs8private) else { throw KernelASN1.TypedError(.decodingFailed) }
        print("PUBLIC PKCS1")
        KernelASN1.ASN1Printer.printObjectVerbose(parsedPublicPKCS1, decodedOctets: true)
        print("PUBLIC PKCS8")
        KernelASN1.ASN1Printer.printObjectVerbose(parsedPublicPKCS8, decodedOctets: true)
        print("PRIVATE PKCS1")
        KernelASN1.ASN1Printer.printObjectVerbose(parsedPrivatePKCS1, decodedOctets: true)
        print("PRIVATE PKCS8")
        KernelASN1.ASN1Printer.printObjectVerbose(parsedPrivatePKCS8, decodedOctets: true)
        
        let publicPKCS1: KernelCryptography.RSA.PublicKey = try .init(from: parsedPublicPKCS1.asn1())
        let publicPKCS8: KernelCryptography.RSA.PublicKey = try .init(from: parsedPublicPKCS8.asn1())
        let privatePKCS1: KernelCryptography.RSA.PrivateKey = try .init(from: parsedPrivatePKCS1.asn1())
        let privatePKCS8: KernelCryptography.RSA.PrivateKey = try .init(from: parsedPrivatePKCS8.asn1())
        let publicPKCS1Encoded: KernelASN1.PEMFile = .init(for: .rsaPublicKey, from: publicPKCS1)
        let publicPKCS8Encoded: KernelASN1.PEMFile = .init(for: .publicKey, from: publicPKCS8)
        let privatePKCS1Encoded: KernelASN1.PEMFile = .init(for: .rsaPrivateKey, from: privatePKCS1)
        let privatePKCS8Encoded: KernelASN1.PEMFile = .init(for: .privateKey, from: privatePKCS8)
        guard let reparsedPublicPKCS1 = try KernelASN1.ASN1Parser4.objectFromPEM(pemString: publicPKCS1Encoded.pemString) else { throw KernelASN1.TypedError(.decodingFailed) }
        guard let reparsedPublicPKCS8 = try KernelASN1.ASN1Parser4.objectFromPEM(pemString: publicPKCS8Encoded.pemString) else { throw KernelASN1.TypedError(.decodingFailed) }
        guard let reparsedPrivatePKCS1 = try KernelASN1.ASN1Parser4.objectFromPEM(pemString: privatePKCS1Encoded.pemString) else { throw KernelASN1.TypedError(.decodingFailed) }
        guard let reparsedPrivatePKCS8 = try KernelASN1.ASN1Parser4.objectFromPEM(pemString: privatePKCS8Encoded.pemString) else { throw KernelASN1.TypedError(.decodingFailed) }
        print("PUBLIC PKCS1 REPARSE")
        KernelASN1.ASN1Printer.printObjectVerbose(reparsedPublicPKCS1, decodedOctets: true)
        print("PUBLIC PKCS8 REPARSE")
        KernelASN1.ASN1Printer.printObjectVerbose(reparsedPublicPKCS8, decodedOctets: true)
        print("PRIVATE PKCS1 REPARSE")
        KernelASN1.ASN1Printer.printObjectVerbose(reparsedPrivatePKCS1, decodedOctets: true)
        print("PRIVATE PKCS8 REPARSE")
        KernelASN1.ASN1Printer.printObjectVerbose(reparsedPrivatePKCS8, decodedOctets: true)
        
        //        print(RSAPemStrings.rsa4096pkcs8private)
        //        print("NEXT")
        //        print(privatePKCS8Encoded.pemString)
        
        let publicPKCS1Final: KernelCryptography.RSA.PublicKey = try .init(from: reparsedPublicPKCS1.asn1())
        let publicPKCS8Final: KernelCryptography.RSA.PublicKey = try .init(from: reparsedPublicPKCS8.asn1())
        let privatePKCS1Final: KernelCryptography.RSA.PrivateKey = try .init(from: reparsedPrivatePKCS1.asn1())
        let privatePKCS8Final: KernelCryptography.RSA.PrivateKey = try .init(from: reparsedPrivatePKCS8.asn1())
        
        let publicKeys =    [publicPKCS1,   publicPKCS8,    publicPKCS1Final,   publicPKCS8Final]
        let privateKeys =   [privatePKCS1,  privatePKCS8,   privatePKCS1Final,  privatePKCS8Final]
        #expect(Set(publicKeys.map { $0.n } + privateKeys.map { $0.n }).count == 1)
        #expect(Set(publicKeys.map { $0.e } + privateKeys.map { $0.e }).count == 1)
        #expect(Set(privateKeys.map { $0.d }).count == 1)
        #expect(Set(privateKeys.map { $0.p }).count == 1)
        #expect(Set(privateKeys.map { $0.q }).count == 1)
    }
    //    func testRSA4096Generation() async throws {
    //        let app: Application = .init()
    //        bootstrapBKSwiftAppUtilsLogging()
    //        let rsaService: KernelCryptography.RSAService = .init(app: app)
    //        let newKeySet = try await rsaService.getRSA4096()
    //
    //        let privateKeyParsed = try KernelASN1.ASN1Parser4.objectFromBytes(newKeySet.privateKeyPKCS1DER())
    //        let publicKeyParsed = try KernelASN1.ASN1Parser4.objectFromBytes(newKeySet.publicKeyPKCS1DER())
    //        print("--PRIVATE KEY--")
    //        KernelASN1.ASN1Printer.printObjectVerbose(privateKeyParsed)
    //        print("--PUBLIC KEY--")
    //        KernelASN1.ASN1Printer.printObjectVerbose(publicKeyParsed)
    //        app.shutdown()
    //    }
    
}

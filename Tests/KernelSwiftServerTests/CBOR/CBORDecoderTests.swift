//
//  File.swift
//
//
//  Created by Jonathan Forbes on 28/09/2023.
//

import Testing
//@testable import KernelVaporUtilities
import KernelSwiftServer

@Suite
struct CBORDecoderTests {

    @Test
    func testCBORDecoder() async throws {
        let testCount = 1
        for _ in 0..<testCount {

            let utf8String_1: String = try KernelCBOR.CBORDecoder.decode(from: CBORTestAssets.utf8String_1)
            let utf8String_2: String = try KernelCBOR.CBORDecoder.decode(from: CBORTestAssets.utf8String_2)
            let utf8String_3: String = try KernelCBOR.CBORDecoder.decode(from: CBORTestAssets.utf8String_3)
            let utf8String_4: String = try KernelCBOR.CBORDecoder.decode(from: CBORTestAssets.utf8String_4)
            let utf8String_5: String = try KernelCBOR.CBORDecoder.decode(from: CBORTestAssets.utf8String_5)
            let utf8String_6: String = try KernelCBOR.CBORDecoder.decode(from: CBORTestAssets.utf8String_6)
            let utf8String_7: String = try KernelCBOR.CBORDecoder.decode(from: CBORTestAssets.utf8String_7)
            
            print("utf8String_1:", utf8String_1)
            print("utf8String_2:", utf8String_2)
            print("utf8String_3:", utf8String_3)
            print("utf8String_4:", utf8String_4)
            print("utf8String_5:", utf8String_5)
            print("utf8String_6:", utf8String_6)
            print("utf8String_7:", utf8String_7)
            
            
            let cborAppAttest: CBORAppAttest = try KernelCBOR.CBORDecoder.decode(from: CBORTestAssets.bigTest)

            try cborAppAttest.attestationStatement.x5c.forEach { cert in
                guard let parsedCertRecreated = try KernelASN1.ASN1Parser4.objectFromPEM(pemString: cert.pemFile().pemString) else { throw KernelASN1.TypedError(.decodingFailed) }
                KernelASN1.ASN1Printer.printObjectVerbose(parsedCertRecreated, decodedOctets: true, decodedBits: true)
            }
            
        }
    }
    
}

public struct CBORAppAttest: KernelCBOR.CBORDecodable {
    public var format: String
    public var attestationStatement: AttestationStatement
    
    public init(from cborType: KernelCBOR.CBORType) throws {
        guard case .map(let dictionary) = cborType else { throw Self.decodingError(.map, cborType) }
        var frm: String? = nil
        var attst: AttestationStatement? = nil
        try dictionary.forEach { entry in
            if case .utf8String("fmt") = entry.key {
                if case let .utf8String(string) = entry.value {
                    frm = string
                }
            }
            if case .utf8String("attStmt") = entry.key {
//                print("tried...")
                attst = try KernelCBOR.CBORDecoder.decode(AttestationStatement.self, from: entry.value)
            }
            
        }
//        print(frm, attst)
        guard let frm, let attst else { throw Self.decodingError(.map, cborType) }
        self.format = frm
        self.attestationStatement = attst

    }
    
    
    public struct AttestationStatement: KernelCBOR.CBORDecodable {
        public var x5c: [KernelX509.Certificate]
        
        public init(from cborType: KernelCBOR.CBORType) throws {
            var x5cs: [[UInt8]] = []
//            print("got here...")
            guard case .map(let dict) = cborType else { throw Self.decodingError(.map, cborType) }
            guard case .array(let arr) = dict.first?.value else { throw Self.decodingError(.array, cborType) }
            arr.forEach { item in
                if case let .byteString(bytes) = item {
                    x5cs.append(bytes)
                }
            }
            
            self.x5c = try x5cs.map { raw in
                let parsedCert = try KernelASN1.ASN1Parser4.objectFromBytes(raw)
                let decoded: KernelX509.Certificate = try KernelASN1.ASN1Decoder.decode(from: parsedCert)
                return decoded
            }
        }
    }
}

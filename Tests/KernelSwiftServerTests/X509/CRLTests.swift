//
//  File.swift
//
//
//  Created by Jonathan Forbes on 23/10/2023.
//

import Testing
import KernelSwiftServer

@Suite
struct CRLTests {
    @Test
    func testReasonFlagsDecode() throws {
        let flags: KernelX509.CRL.ReasonFlags = .init(flags: [.keyCompromise, .certificateHold, .aaCompromise])
        let built = flags.buildASN1Type()
        let bytes = KernelASN1.ASN1Writer.dataFromObject(built)
        let parsedFlags = try KernelASN1.ASN1Parser4.objectFromBytes(bytes)
        let decodedFlags: KernelX509.CRL.ReasonFlags = try KernelASN1.ASN1Decoder.decode(from: parsedFlags)
        #expect(decodedFlags.composedValue() == flags.composedValue())
    }
}

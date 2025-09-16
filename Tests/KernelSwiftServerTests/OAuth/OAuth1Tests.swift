//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 18/11/2024.
//

import Testing
import KernelSwiftServer
import Vapor

@Suite
struct OAuth1Tests {
    @Test
    func testPutSignature() async throws {
        var clientRequest: ClientRequest = .init()
        clientRequest.url = .init(string: "http://www.example.com/resource")
        clientRequest.method = .PUT
        try clientRequest.content.encode("Hello World!")
        try clientRequest.addOAuth1AuthorisationHeader(
            consumerKey: "consumer",
            signingPrivateKey: KernelCryptography.RSA.KeySize.b2048.testSamplePrivateKey,
            alg: .SHA2_256
        )
        
        print("CLIENT REQ", clientRequest)
    }
    
    @Test
    func testGetSignature() async throws {
        var clientRequest: ClientRequest = .init()
        clientRequest.url = .init(string: "http://www.example.com/resource")
        clientRequest.method = .GET
        try clientRequest.addOAuth1AuthorisationHeader(
            consumerKey: "consumer",
            signingPrivateKey: KernelCryptography.RSA.KeySize.b2048.testSamplePrivateKey,
            alg: .SHA2_256
        )
        
        print("CLIENT REQ", clientRequest)
    }
}

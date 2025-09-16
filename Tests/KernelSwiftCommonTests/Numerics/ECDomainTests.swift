import XCTest

import KernelSwiftCommon
//import KernelSwiftServer
final class ECDomainTests: XCTestCase {
    func testOIDInit(oid: KernelSwiftCommon.ObjectID) throws {
        let domain: KernelNumerics.EC.Domain = try .init(fromOID: oid)
        let (secret, pub) = domain.generateSecretAndPoint()
        print("SECRET \(oid.rawValue)")
        print(secret)
        print("PUBLIC \(oid.rawValue)")
        print(pub)
        let containsPoint = domain.contains(pub)
        XCTAssert(containsPoint)
    }
    
    func testCurveGenerationANSSI() throws {
        try testOIDInit(oid: .frp256v1)
    }
    
    func testCurveGenerationBrainpool() throws {
        try testOIDInit(oid: .brainpoolP160r1)
        try testOIDInit(oid: .brainpoolP160t1)
        try testOIDInit(oid: .brainpoolP192r1)
        try testOIDInit(oid: .brainpoolP192t1)
        try testOIDInit(oid: .brainpoolP224r1)
        try testOIDInit(oid: .brainpoolP224t1)
        try testOIDInit(oid: .brainpoolP256r1)
        try testOIDInit(oid: .brainpoolP256t1)
        try testOIDInit(oid: .brainpoolP320r1)
        try testOIDInit(oid: .brainpoolP320t1)
        try testOIDInit(oid: .brainpoolP384r1)
        try testOIDInit(oid: .brainpoolP384t1)
        try testOIDInit(oid: .brainpoolP512r1)
        try testOIDInit(oid: .brainpoolP512t1)
    }
    
    func testCurveGenerationSECP() throws {
        try testOIDInit(oid: .secp112r1)
        try testOIDInit(oid: .secp112r2)
        try testOIDInit(oid: .secp128r1)
        try testOIDInit(oid: .secp128r2)
    }
    
    func testCurveGenerationX962() throws {
        try testOIDInit(oid: .x962Prime192v1)
        try testOIDInit(oid: .x962Prime192v2)
        try testOIDInit(oid: .x962Prime192v3)
        try testOIDInit(oid: .x962Prime239v1)
        try testOIDInit(oid: .x962Prime239v2)
        try testOIDInit(oid: .x962Prime239v3)
        try testOIDInit(oid: .x962Prime256v1)
    }
    
    func testCurveGenerationX963() throws {
        try testOIDInit(oid: .ansip160r1)
        try testOIDInit(oid: .ansip160k1)
        try testOIDInit(oid: .ansip256k1)
        try testOIDInit(oid: .ansip160r2)
        try testOIDInit(oid: .ansip192k1)
        try testOIDInit(oid: .ansip224k1)
        try testOIDInit(oid: .ansip224r1)
        try testOIDInit(oid: .ansip384r1)
        try testOIDInit(oid: .ansip521r1)
    }
    
    func testCurveGenerationBN() throws {
        try testOIDInit(oid: .unknownOID("bn158"))
    }
}

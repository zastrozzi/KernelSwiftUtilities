//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 03/12/2023.
//

import Vapor
import Fluent
import KernelSwiftCommon

/// RouteCollection
extension KernelX509.Routes {
    
    public struct CertificateStore_v1_0: ContextSwitchingRouteCollection, FeatureRouteCollection {
        public typealias Feature = KernelX509.Routes
        public static let openAPITag: String = "Certificate Store V1.0"
        
        @KernelDI.Injected(\.keystoreService) var keystore
        
        public enum RouteCollectionContext {
            case root
        }
        
        public var routeCollectionContext: RouteCollectionContext
        
        public init(forContext routeCollectionContext: RouteCollectionContext = .root) {
            self.routeCollectionContext = routeCollectionContext
        }
        
        public func boot(routes: RoutesBuilder) throws {
            let routeGroup = routes.versioned("1.0", "x509").typeGrouped("certificates").tags(Self.resolvedOpenAPITag)
            routeGroup.get(":certificateId".parameterType(UUID.self), use: getCertificateHandler).summary("Get Certificate")
            routeGroup.post("test-create", ":sample".parameterType(Int.self), use: createTestCertificateHandler).summary("Create Test Certificate")
        }
        
        public func getCertificateHandler(_ req: TypedRequest<GetCertificateContext>) async throws -> Response {
            try req.platformActor.systemOrAdmin()
            let databaseId = req.kernelDI(KernelX509.self).config.get(.defaultDatabaseID, as: DatabaseID.self)!
            let found = try await KernelX509.Fluent.Model.Certificate
                .findOrThrow(
                    try req.parameters.require("certificateId"),
                    on: req.application.withDBLock(databaseId)
                ) {
                    Abort(.notFound, reason: "Certificate not found")
                }
//            guard let cid = found.id else { throw Abort(.badRequest, reason: "no id") }
//            KernelX509.logger.info("FOUND CERT \(cid) | V:\(found.tbsCert.version) | SN:\(found.tbsCert.serialNumber)")
            let convertedToCert: KernelX509.Certificate = try .init(from: found)
            let convertedPem = convertedToCert.pemFile()
//            guard let parsedConvertedPem = try KernelASN1.ASN1Parser4.objectFromPEM(pemString: convertedPem) else { throw KernelASN1.TypedError(.decodingFailed) }
//            parsedConvertedPem.printVerbose(fullLength: true, decodedOctets: true, decodedBits: true)
            return try await req.response.successPKIX.encode(.init(convertedPem))
        }
        
        public func createTestCertificateHandler(_ req: TypedRequest<CreateTestCertificateContext>) async throws -> Response {
            try req.platformActor.systemOrAdmin()
            let databaseId = req.kernelDI(KernelX509.self).config.get(.defaultDatabaseID, as: DatabaseID.self)!
            let sample = try req.parameters.require("sample", as: Int.self)
            let certPem: String = switch sample {
            case 1: TestCertPEMStrings.postgresRoot
            case 2: TestCertPEMStrings.postgresServer
            case 3: TestCertPEMStrings.openBanking
            case 4: TestCertPEMStrings.minica
            case 5: TestCertPEMStrings.attestLeafCert
            case 6: TestCertPEMStrings.attestIntermediateCert
            case 7: TestCertPEMStrings.attestRootCert
            case 8: TestCertPEMStrings.longNameConstraints
            case 9: TestCertPEMStrings.rsapss256
            default: ""
            }
            guard let parsedPem = try KernelASN1.ASN1Parser4.objectFromPEM(pemString: certPem) else { throw Abort(.badRequest, reason: "couldnt parse") }
            let cert: KernelX509.Certificate = try .init(from: parsedPem.asn1())
            let dbCert: KernelX509.Fluent.Model.Certificate = try .createFields(from: cert)
            try await dbCert.create(on: req.application.withDBLock(databaseId))
            guard let cid = dbCert.id else { throw Abort(.badRequest, reason: "no id") }
            KernelX509.logger.info("CREATED CERT \(cid) | V:\(dbCert.tbsCert.version) | SN:\(dbCert.tbsCert.serialNumber)")
            let convertedToCert: KernelX509.Certificate = try .init(from: dbCert)
            convertedToCert.issuer.buildASN1Type().print()
            convertedToCert.subject.buildASN1Type().print()
            let convertedPem = convertedToCert.pemFile()
            guard let parsedConvertedPem = try KernelASN1.ASN1Parser4.objectFromPEM(pemString: convertedPem.pemString) else { throw KernelASN1.TypedError(.decodingFailed) }
            parsedConvertedPem.printVerbose(fullLength: true, decodedOctets: true, decodedBits: true)
            return try await req.response.successPKIX.encode(.init(convertedPem))
        }
        
//        public func testCertDBSavePublicKey(_ req: TypedRequest<TestCertDBGetContext>) async throws -> Response {
//            let databaseId = req.kernelDI(KernelX509.self).config.get(.defaultDatabaseID, as: DatabaseID.self)!
//            let id = try req.parameters.require("id", as: UUID.self)
//            guard let found = try await KernelX509.Fluent.Model.Certificate
//                .query(on: req.application.withDBLock(databaseId))
//                .filter(\.$id == id)
//                .first()
//            else { throw Abort(.notFound, reason: "cert not found") }
//            let convertedToCert: KernelX509.Certificate = try .init(from: found)
//            guard found.tbsCert.subjectPublicKeyInfo.$publicKey.id == nil else { throw Abort(.conflict, reason: "public key already exists") }
//            let publicKey = try await keystore.storePublicKeyFromX509Cert(convertedToCert.subjectPublicKeyInfo, on: databaseId)
//            found.tbsCert.subjectPublicKeyInfo.$publicKey.id = publicKey.id
//            try await found.save(on: req.application.withDBLock(databaseId))
//            return try await req.response.success.encode(.init())
//        }
    }
}

extension KernelX509.Routes.CertificateStore_v1_0 {
    public struct CreateTestCertificateContext: RouteContext {
        public init() {}
        let successPKIX: ResponseContext<KernelASN1.TypedPEMFile<KernelASN1.PEMFile.Format.CRT>> = .success(.ok, .pkixCert)
    }
    
//    public typealias TestCertDBGetContext = GetRouteContext<KernelSwiftCommon.Networking.HTTP.EmptyResponse>
    
    public struct GetCertificateContext: RouteContext {
        public init() {}
        let successPKIX: ResponseContext<KernelASN1.TypedPEMFile<KernelASN1.PEMFile.Format.CRT>> = .success(.ok, .pkixCert)
//        let successPKCS8: ResponseContext<KernelASN1.TypedPEMFile<KernelASN1.PEMFile.Format.PrivateKey>> = .success(.ok, .pkcs8)
//        let successJSON: ResponseContext<KernelX509.Certificate> = .success(.ok, .json)
    }
}



public enum TestCertPEMStrings {}

extension TestCertPEMStrings {
    public static let postgresRoot: String =
"""
-----BEGIN CERTIFICATE-----
MIIE3jCCAsagAwIBAgIBATANBgkqhkiG9w0BAQsFADAPMQ0wCwYDVQQDEwRteUNB
MB4XDTIzMDkyMjEzNTExM1oXDTI1MDMyMjE0MDExMVowDzENMAsGA1UEAxMEbXlD
QTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBANGPFMy0qkJ0AjfYIZj5
NM3gSBuf8B4htJfv1H3EauR2w+bTvCYHvj06M6RacvJB0waHTiu6ZTs6eYehll8B
fkUKOg+dD2v24QitqMwJb5g00RJthmkjQzkYM2PM+sgoeSAbBPD2p5NPpXyBs0gV
QHFW9BygDQh8ipz+B/MMyoacSg0/YRLzvVYrMtEcJREUmn95pM6p291QuQbJ3fH/
brWXs4YMSf/2jwQ3Fjo2XjbOadGFj+9VOY89zKomUz3desV08qy5x4lqGEGT8eP+
qXbxQxGusz7JbZB+YIJAPQ6Cd9Hw1GEMk297Ggn102la62TXXeWCvvDtoVUTJu27
CRMVHqYbwEFOulFbzY870dUkXOQ2+ASO1eR5OZdTAyHsKFF6SOMq2oLLR/uu6IGT
C3IjFaRf3WNhGNTKBUBC7E00T9+HOLIYqB4mxSGJKPM6MuJYL3IOTMWLw25P9RDz
4v/DAJ7ijoly72g0IHuOKWlFKREXSY/eD0pyF3IMsZrSJw0+rapgILpiQC8iFf7P
C6sAfx537bv6l7e/uah5G5IfG2IZj43DDDICR7eK4q4cl1IwW6tiTZbNnR4EBq1e
WpbLfmu3WnWFihoajq7M9wOTL4ObWIligxaLOnicvWD2CznfjJktJ8HUKzs6J+re
cEDILYEGWAHIx+Dh475Sg5UdAgMBAAGjRTBDMA4GA1UdDwEB/wQEAwIBBjASBgNV
HRMBAf8ECDAGAQH/AgEAMB0GA1UdDgQWBBRmku5y6ibhZEzWKA0enOUHfLsebzAN
BgkqhkiG9w0BAQsFAAOCAgEAyxoOMykdrMkIF1RmwYqo0l2Hwr/52df1ZVjtj6QA
lomPNL/aWY28jApLCl7ez8QIfusQp74bWkGYLFyYM4HMI3gSmjmTXwsJ1JCS5Qa8
MNkxomZ3iQhlyIrp9T66YUnTDyTjvcUXNKCgqBoR/WmPS2bDKgy8alln2aPXB+Xn
tLuQdq9YK54pyuI/TQ1ARuGMekFZ762IGd27Cent8aRyODC4lKtcwGKoEWuKpMxX
0/V1ZD6EPxt6j5xRe+iykhJHuhuWM2kxYVHMKTWpb99vuIpd05ZlMNT9crIhRl+O
3GPHHxivKw+VireevcqYVocqElxceZYgiuILn/UZOUSbIqzM94tJx1+5XA3mviH8
aTORYNdECJTMpjP85F6Mt8JheCk40wOU9CERHxQnup9OLzcBiLVcmcWYH+5fVQ0g
WJOoo6vGWT4DCjMuFA6VK2Uj3vJSseMAHWJELF6shJa6oFS3zu9KIWI+M5Y5Jb43
2Ho1VP8MTRJi0129MATo/avln5xAEkiVjucZoRP6xGzSO8KzuCPch0gi+R0/TRFv
nTBoqlJOV+/Aeuha6jeuHq5fwS5w4y/9LeyofOmJIKlvb440RHDVekrrqxH+KJSO
FdhE8uUtEGBxE1baDxZGX0JS4E8V208CuzteCnifIFnhD7NwZbSRPi6oKo2/7M0W
Zf8=
-----END CERTIFICATE-----
"""
    
    public static let postgresServer: String =
"""
-----BEGIN CERTIFICATE-----
MIIEODCCAiCgAwIBAgIRAMeH3KG42cytdNxDzjEh4x0wDQYJKoZIhvcNAQELBQAw
DzENMAsGA1UEAxMEbXlDQTAeFw0yMzA5MjIxMzU0MTFaFw0yNTAzMjIxNDAxMTFa
MBUxEzARBgNVBAMTCnBvc3RncmVzZGIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
ggEKAoIBAQDM6bPYNMWRyUxN3tIuhAbtPtmTvm2GpRxq694ll7IFzR7BO2v5s9g7
KKk1Hue3v9oETvWs9gDgJpxoD0f3VPUs5W+vpq6bE3yxeibuwpQU+4NQum4wiCi2
Z/E0RbT32sJfBXDMgrAZafSOKi3823er8g/7ypynIwr7NcGxQqZSsihtOQ+lL/bV
E49TPKQkOb7R33zFJJ/RmO8hiEaRM17qCQOvbVcMun8NHWc5mIIs4aJskSBC7lfC
eAenD3+OGtZXHnnZCY21OQpNRZuk9j0wr/nU5/LNWX/n2MAcJ4n0rskyepafNl/W
ahO8Ynqm/vadPDpTm79CzuZyo6SS1e4xAgMBAAGjgYgwgYUwDgYDVR0PAQH/BAQD
AgO4MB0GA1UdJQQWMBQGCCsGAQUFBwMBBggrBgEFBQcDAjAdBgNVHQ4EFgQU5t/Y
WhDOqlz5MCI/D7VMr8uPQcAwHwYDVR0jBBgwFoAUZpLucuom4WRM1igNHpzlB3y7
Hm8wFAYDVR0RBA0wC4IJbG9jYWxob3N0MA0GCSqGSIb3DQEBCwUAA4ICAQCBjXn7
waWC2R9CBkS5JKnKZkFZtQwS/gCLPyJJxV0T8VIAf11w0XOGnCtqqeEE4zFIbscM
HgGYFckt3CW5SiGhrfAsRNIkWkhwsygs2+ag34hhJ15emmRg+lkJ8oVCIUz5xYNp
tNdGM8c37Ss/7CgraCf6/AYUXPiwo+IOioTdWgo0U72cRQr6jcBFp5eKALxKqbPs
Uell563QU/qvz4v03n2+qcE/yvAEs5Rw2lHX4oBNHPNn1CpTckM8iaB9ZBftS9Sj
i+2PlOSbw7pDf8voddTB23jTs1JDLoXnpilLGBWYXtDI7O+nq1cTK9ILJcOlo4Fh
sRHVLoQ/C6p6Q++/fHZ6whc+/tzYPeMG3cJJLhcOenw+/w84PGQ/lvmbZpzSk66D
LrvVvS7KLXFScN7lb2AC3YxMxWltAzye4vGfOCwOvLlGSvJ8nsy2QAAYyMBTo6/U
s/HwHxiHCF1b9ueJ6rDSC75jac+RTpChaZPTG0RnwY5Ds/OH94vpZeHuFGR6n1Ro
g7bP5vvUp4M9RAX2jUZFrbpBWz0evUzcOfNWrTy1cYSB5zHSvkRw811mNsC2HNZm
ZRWCOPMP5JexHilV8GFfMfjnZXWjl0v/n78Tf/fZeHTuPMs40cn5NF8Ol6vl4B1S
fAes0zrVPS14SGZNxzEcLSKH+BiW3QGMU3rT+A==
-----END CERTIFICATE-----
"""
    
    public static let openBanking: String =
"""
-----BEGIN CERTIFICATE-----
MIIF6TCCBNGgAwIBAgIEWcbJATANBgkqhkiG9w0BAQsFADBTMQswCQYDVQQGEwJH
QjEUMBIGA1UEChMLT3BlbkJhbmtpbmcxLjAsBgNVBAMTJU9wZW5CYW5raW5nIFBy
ZS1Qcm9kdWN0aW9uIElzc3VpbmcgQ0EwHhcNMjMwNzA1MDAyMjM5WhcNMjQwODA1
MDA1MjM5WjB+MQswCQYDVQQGEwJHQjElMCMGA1UEChMcS0VSTkVMIEVER0UgVEVD
SE5PTE9HSUVTIExURDErMCkGA1UEYRMiUFNER0ItT0ItVW5rbm93bjAwMTRIMDAw
MDNBUm5ZWVFBMTEbMBkGA1UEAxMSMDAxNEgwMDAwM0FSbllZUUExMIIBIjANBgkq
hkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAz1aoMya5OQLvVlzdvDVSAZy4rQLBItY1
3se6z7LxIAlMwe11/lutZHMU+VcMZo76kNqs+BU3YxDnOag/lt1/ByifUv+veB6W
dILidmSv4IG/R/SACCPTVhvV8qOH/Tvyqyoehj+3+H2E7eUb4/ysaILwi6tLMsmJ
O5yvFrUDyxfBvvdBSnQbObtQrqU84HmZ1H7ApYLgBo8GEb1QKNhSoJhB3Pu/SPjK
6ict1nyGkn/VkxvM3kN+QAcq69UygXHPBGYPslWCr5qw5TzlDli6HrH0RARH6Smv
mMsjSXFW62ift7jvW31vw86zIqiWM7JI0JL8iqfCJ3KnkQZTMYLo8QIDAQABo4IC
mDCCApQwDgYDVR0PAQH/BAQDAgeAMIGRBggrBgEFBQcBAwSBhDCBgTATBgYEAI5G
AQYwCQYHBACORgEGAzBqBgYEAIGYJwIwYDA5MBEGBwQAgZgnAQIMBlBTUF9QSTAR
BgcEAIGYJwEDDAZQU1BfQUkwEQYHBACBmCcBBAwGUFNQX0lDDBtGaW5hbmNpYWwg
Q29uZHVjdCBBdXRob3JpdHkMBkdCLUZDQTAgBgNVHSUBAf8EFjAUBggrBgEFBQcD
AQYIKwYBBQUHAwIwgeAGA1UdIASB2DCB1TCB0gYLKwYBBAGodYEGAWQwgcIwKgYI
KwYBBQUHAgEWHmh0dHA6Ly9vYi50cnVzdGlzLmNvbS9wb2xpY2llczCBkwYIKwYB
BQUHAgIwgYYMgYNVc2Ugb2YgdGhpcyBDZXJ0aWZpY2F0ZSBjb25zdGl0dXRlcyBh
Y2NlcHRhbmNlIG9mIHRoZSBPcGVuQmFua2luZyBSb290IENBIENlcnRpZmljYXRp
b24gUG9saWNpZXMgYW5kIENlcnRpZmljYXRlIFByYWN0aWNlIFN0YXRlbWVudDBt
BggrBgEFBQcBAQRhMF8wJgYIKwYBBQUHMAGGGmh0dHA6Ly9vYi50cnVzdGlzLmNv
bS9vY3NwMDUGCCsGAQUFBzAChilodHRwOi8vb2IudHJ1c3Rpcy5jb20vb2JfcHBf
aXNzdWluZ2NhLmNydDA6BgNVHR8EMzAxMC+gLaArhilodHRwOi8vb2IudHJ1c3Rp
cy5jb20vb2JfcHBfaXNzdWluZ2NhLmNybDAfBgNVHSMEGDAWgBRQc5HGIXLTd/T+
ABIGgVx5eW4/UDAdBgNVHQ4EFgQU+jU/2sMMugptLNwbVBCfRjFCoOwwDQYJKoZI
hvcNAQELBQADggEBACSncVQJlYKkirqQE9wtUt6MnUIZj1Xp3TjLOXLUD4dzCUS/
jAE7Y4WZ4xniFn50yKu+pBUdQBNRGkG4/BwdQGA2cvdi75UxZPVWnIvx8GIRlYwr
nb4R4F2FjmKAGfehFlfxcQWNoxj7BILV7mS7AG9lJSKRDy0XQrHT+/Mx4knclqh+
fh7wLs8pbatAy3josOB5bMX1ZP9oC8YunBIoIdzhgWhBSexNOZ+Ndeiy3UXwbfSJ
HT7DsxNI7PnTSvMvbAgC+M+ukIK1WO11dPEudnVXWO/8soec1vETQPHiAy1Ns9S6
sOLgrwEi5f5fjDxaRAPXxMb32vBezyJyDmv7t70=
-----END CERTIFICATE-----
"""
    
    public static let minica: String =
"""
-----BEGIN CERTIFICATE-----
MIIF2DCCA8CgAwIBAgIQTKr5yttjb+Af907YWwOGnTANBgkqhkiG9w0BAQwFADCB
hTELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4G
A1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxKzApBgNV
BAMTIkNPTU9ETyBSU0EgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMTAwMTE5
MDAwMDAwWhcNMzgwMTE4MjM1OTU5WjCBhTELMAkGA1UEBhMCR0IxGzAZBgNVBAgT
EkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMR
Q09NT0RPIENBIExpbWl0ZWQxKzApBgNVBAMTIkNPTU9ETyBSU0EgQ2VydGlmaWNh
dGlvbiBBdXRob3JpdHkwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQCR
6FSS0gpWsawNJN3Fz0RndJkrN6N9I3AAcbxT38T6KhKPS38QVr2fcHK3YX/JSw8X
pz3jsARh7v8Rl8f0hj4K+j5c+ZPmNHrZFGvnnLOFoIJ6dq9xkNfs/Q36nGz637CC
9BR++b7Epi9Pf5l/tfxnQ3K9DADWietrLNPtj5gcFKt+5eNu/Nio5JIk2kNrYrhV
/erBvGy2i/MOjZrkm2xpmfh4SDBF1a3hDTxFYPwyllEnvGfDyi62a+pGx8cgoLEf
Zd5ICLqkTqnyg0Y3hOvozIFIQ2dOciqbXL1MGyiKXCJ7tKuY2e7gUYPDCUZObT6Z
+pUX2nwzV0E8jVHtC7ZcryxjGt9XyD+86V3Em69FmeKjWiS0uqlWPc9vqv9JWL7w
qP/0uK3pN/u6uPQLOvnoQ0IeidiEyxPx2bvhiWC4jChWrBQdnArncevPDt09qZah
SL0896+1DSJMwBGB7FY79tOi4lu3sgQiUpWAk2nojkxl8ZEDLXB0AuqLZxUpaVIC
u9ffUGpVRr+goyhhf3DQw6KqLCGqR84onAZFdr+CGCe01a60y1Dma/RMhnEw6abf
Fobg2P9A3fvQQoh/ozM6LlweQRGBY84YcWsr7KaKtzFcOmpH4MN5WdYgGq/yapiq
crxXStJLnbsQ/LBMQeXtHT1eKJ2czL+zUdqnR+WEUwIDAQABo0IwQDAdBgNVHQ4E
FgQUu69+Aj36pvE8hI6t7jiY7NkyMtQwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB
/wQFMAMBAf8wDQYJKoZIhvcNAQEMBQADggIBAArx1UaEt65Ru2yyTUEUAJNMnMvl
wFTPoCWOAvn9sKIN9SCYPBMtrFaisNZ+EZLpLrqeLppysb0ZRGxhNaKatBYSaVqM
4dc+pBroLwP0rmEdEBsqpIt6xf4FpuHA1sj+nq6PK7o9mfjYcwlYRm6mnPTXJ9OV
2jeDchzTc+CiR5kDOF3VSXkAKRzH7JsgHAckaVd4sjn8OoSgtZx8jb8uk2Intzna
FxiuvTwJaP+EmzzV1gsD41eeFPfR60/IvYcjt7ZJQ3mFXLrrkguhxuhoqEwWsRqZ
CuhTLJK7oQkYdQxlqHvLI7cawiiFwxv/0Cti76R7CZGYZ4wUAc1oBmpjIXUDgIiK
boHGhfKppC3n9KUkEEeDys30jXlYsQab5xoq2Z0B15R97QNKyvDb6KkBPvVWmcke
jkk9u+UJueBPSZI9FoJAzMxZxuY67RIuaTxslbH9qh17f4a+Hg4yRvv7E491f0yL
S0Zj/gA0QHDBw7mh3aZw4gSzQbzpgJHqZJx64SIDqZxubw5lT2yHh17zbqD5daWb
QOhTsiedSrnAdyGN/4fy3ryM7xfft0kL0fJuMAsaDk527RH89elWsn2/x20Kk4yl
0MC2Hb46TpSi125sC8KKfPog88Tk5c0NqMuRkrF8hey1FGlmDoLnzc7ILaZRfyHB
NVOFBkpdn627G190
-----END CERTIFICATE-----
"""
    
    public static let rsapss256: String =
"""
-----BEGIN CERTIFICATE-----
MIIDDzCCAfegAwIBAgIMWYGU7zoymvg+Z63iMA0GCSqGSIb3DQEBCwUAMCMxITAf
BgNVBAMTGEJvdW5jeUNhc3RsZSBUTFMgVGVzdCBDQTAeFw0xNzA4MDIwOTAxMzVa
Fw0zNzA3MjkwOTAxMzVaMCMxITAfBgNVBAMTGEJvdW5jeUNhc3RsZSBUTFMgVGVz
dCBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAOMuUmmLJ2pQ4fYj
EfuIj11TMnG8dqScapc/yU9zHCDn5DQJGOa/X5jYoJX4k2PbXk5bbck2caC4J7/G
WRugGc4KcOVItAmnxbVzJqtpsdRrVUvTzqcvaSZNHEgSWP73WmlACX6xIHRyBtr+
Pwpig73eZkOVcGOsbsWliffVQ0f0fz/AGsYh5IWBNlIfBOWwOEBDJavlsYrVGAw1
MuXxknybsjXFRqyFNPE6Shd3W3eteo+FOvQsyopmX6FcP+EOaFQxSQ7yR+xNsreC
yxi40hPfswO6TihN9hLdVt3C+OHDJw2wR2xM+SwsW8Hu4jEi21uakQl846z+XdgV
o+D3v3cCAwEAAaNDMEEwDwYDVR0TAQH/BAUwAwEB/zAPBgNVHQ8BAf8EBQMDBwQA
MB0GA1UdDgQWBBQrQlWadXqqzBV+2iw7BZXrvFHaQjANBgkqhkiG9w0BAQsFAAOC
AQEArUVXn2oI5hgSkDwDrhQFijHBT3d37SX0eji//lkLPTHSEXHv+6kAoxVKmSnG
hAAxuLKxtAjNlXi4FAxSpQPX17/199JHUd/Ue63Tetc8DfaFc6MaFNxWkNrY6LUX
bEhbI/vB1kBu7sc8SW7N694WSpe/OmD/lB6GYW6ZV68hrTB0gfmfB6SfcGbQ69ss
YUsNU7Yo1GZnJTz0FZzybjx/T85NnVvpfVqjjaGRFeSva9GAU+5uO5DdbSpbkCcw
6QFFfvcJ7VD6qFqtLG1TfcdOuCaUB8cmDhDtTB/Ax96wGdJvp6ca3YaboZag9HOZ
4csuzHIJQyd5HT6xLbUBeskgWw==
-----END CERTIFICATE-----
"""
    
    public static let attestLeafCert: String =
"""
-----BEGIN CERTIFICATE-----
MIIC8jCCAnmgAwIBAgIGAYqki5DPMAoGCCqGSM49BAMCME8xIzAhBgNVBAMMGkFw
cGxlIEFwcCBBdHRlc3RhdGlvbiBDQSAxMRMwEQYDVQQKDApBcHBsZSBJbmMuMRMw
EQYDVQQIDApDYWxpZm9ybmlhMB4XDTIzMDkxNjE5MDg0NFoXDTI0MDQxMDAzMjg0
NFowgZExSTBHBgNVBAMMQGNlNjkyNmYzNmRlMmU0ZmIyOTg1ZmRlNzM4ODcyY2I0
ODliMDNmZTNkMGQzNTM3OTIxYzY4ZGZjZmI4OWU0ZjAxGjAYBgNVBAsMEUFBQSBD
ZXJ0aWZpY2F0aW9uMRMwEQYDVQQKDApBcHBsZSBJbmMuMRMwEQYDVQQIDApDYWxp
Zm9ybmlhMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE9AYAjn+x9lY+UetEwWri
6CTRDXfESaxvWNjHSdnhsCdVkbouhYoZh47+cfHWsCs1T/60krZ6pK9xmbZ4jgbG
kKOB/TCB+jAMBgNVHRMBAf8EAjAAMA4GA1UdDwEB/wQEAwIE8DB+BgkqhkiG92Nk
CAUEcTBvpAMCAQq/iTADAgEBv4kxAwIBAL+JMgMCAQG/iTMDAgEBv4k0JgQkODlD
Ulk2OVhLNC5jb20ua2VybmVsZWRnZS5lY2wuRmluRml0pQYEBHNrcyC/iTYDAgEF
v4k3AwIBAL+JOQMCAQC/iToDAgEAMCUGCSqGSIb3Y2QIBwQYMBa/ingGBAQxNy4w
v4p7CAQGMjFBMzI5MDMGCSqGSIb3Y2QIAgQmMCShIgQgKTvHjGOQ/RctJuQsLNvl
5DNOZhSIf7bE9+OG/pxhcXswCgYIKoZIzj0EAwIDZwAwZAIwNHASUL2eGeJriuIK
RPlcd9eqhXtgy3etvjMLwFWIddpqMeecqV1f5gRovh1d/xgWAjBAc2qaKyfLOu8F
UvtQNLbyltRisrujdfNO22f2wHFUMNlOAhYvDqNoppvH5TPWtfk=
-----END CERTIFICATE-----
"""
    
    public static let attestIntermediateCert: String =
"""
-----BEGIN CERTIFICATE-----
MIICQzCCAcigAwIBAgIQCbrF4bxAGtnUU5W8OBoIVDAKBggqhkjOPQQDAzBSMSYw
JAYDVQQDDB1BcHBsZSBBcHAgQXR0ZXN0YXRpb24gUm9vdCBDQTETMBEGA1UECgwK
QXBwbGUgSW5jLjETMBEGA1UECAwKQ2FsaWZvcm5pYTAeFw0yMDAzMTgxODM5NTVa
Fw0zMDAzMTMwMDAwMDBaME8xIzAhBgNVBAMMGkFwcGxlIEFwcCBBdHRlc3RhdGlv
biBDQSAxMRMwEQYDVQQKDApBcHBsZSBJbmMuMRMwEQYDVQQIDApDYWxpZm9ybmlh
MHYwEAYHKoZIzj0CAQYFK4EEACIDYgAErls3oHdNebI1j0Dn0fImJvHCX+8XgC3q
s4JqWYdP+NKtFSV4mqJmBBkSSLY8uWcGnpjTY71eNw+/oI4ynoBzqYXndG6jWaL2
bynbMq9FXiEWWNVnr54mfrJhTcIaZs6Zo2YwZDASBgNVHRMBAf8ECDAGAQH/AgEA
MB8GA1UdIwQYMBaAFKyREFMzvb5oQf+nDKnl+url5YqhMB0GA1UdDgQWBBQ+410c
BBmpybQx+IR01uHhV3LjmzAOBgNVHQ8BAf8EBAMCAQYwCgYIKoZIzj0EAwMDaQAw
ZgIxALu+iI1zjQUCz7z9Zm0JV1A1vNaHLD+EMEkmKe3R+RToeZkcmui1rvjTqFQz
97YNBgIxAKs47dDMge0ApFLDukT5k2NlU/7MKX8utN+fXr5aSsq2mVxLgg35BDhv
eAe7WJQ5tw==
-----END CERTIFICATE-----
"""
    
    public static let attestRootCert: String =
"""
-----BEGIN CERTIFICATE-----
MIICITCCAaegAwIBAgIQC/O+DvHN0uD7jG5yH2IXmDAKBggqhkjOPQQDAzBSMSYw
JAYDVQQDDB1BcHBsZSBBcHAgQXR0ZXN0YXRpb24gUm9vdCBDQTETMBEGA1UECgwK
QXBwbGUgSW5jLjETMBEGA1UECAwKQ2FsaWZvcm5pYTAeFw0yMDAzMTgxODMyNTNa
Fw00NTAzMTUwMDAwMDBaMFIxJjAkBgNVBAMMHUFwcGxlIEFwcCBBdHRlc3RhdGlv
biBSb290IENBMRMwEQYDVQQKDApBcHBsZSBJbmMuMRMwEQYDVQQIDApDYWxpZm9y
bmlhMHYwEAYHKoZIzj0CAQYFK4EEACIDYgAERTHhmLW07ATaFQIEVwTtT4dyctdh
NbJhFs/Ii2FdCgAHGbpphY3+d8qjuDngIN3WVhQUBHAoMeQ/cLiP1sOUtgjqK9au
Yen1mMEvRq9Sk3Jm5X8U62H+xTD3FE9TgS41o0IwQDAPBgNVHRMBAf8EBTADAQH/
MB0GA1UdDgQWBBSskRBTM72+aEH/pwyp5frq5eWKoTAOBgNVHQ8BAf8EBAMCAQYw
CgYIKoZIzj0EAwMDaAAwZQIwQgFGnByvsiVbpTKwSga0kP0e8EeDS4+sQmTvb7vn
53O5+FRXgeLhpJ06ysC5PrOyAjEAp5U4xDgEgllF7En3VcE3iexZZtKeYnpqtijV
oyFraWVIyd/dganmrduC1bmTBGwD
-----END CERTIFICATE-----
"""
    
    public static let longNameConstraints: String =
"""
-----BEGIN CERTIFICATE-----
MIIkKjCCIxKgAwIBAgIJIrmxaudci1hlMA0GCSqGSIb3DQEBCwUAMF0xCzAJBgNV
BAYTAkpQMSUwIwYDVQQKExxTRUNPTSBUcnVzdCBTeXN0ZW1zIENPLixMVEQuMScw
JQYDVQQLEx5TZWN1cml0eSBDb21tdW5pY2F0aW9uIFJvb3RDQTIwHhcNMjAwMzIz
MDcxNzM2WhcNMjkwNTI5MDUwMDM5WjBbMQswCQYDVQQGEwJKUDEqMCgGA1UEChMh
TmF0aW9uYWwgSW5zdGl0dXRlIG9mIEluZm9ybWF0aWNzMSAwHgYDVQQDExdOSUkg
T3BlbiBEb21haW4gQ0EgLSBHNTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBAMvHidrFR7CRsutS5ioQCQBe5mtBfm1o7d5Hu111so+QrOMzZqtXMFTppYAG
qTWst4HW6nNIKgoFcbngQ2motJ44P57oTXu4kUHJO9qti/l9VVU+IIwPgb/xJk6R
jp5OcJfg5OPmDc6f3qmzl9803mKO1OO3ldDBGqq430cb1e6EfAD4xw+Rpr7fq5g3
PwW1v6cylM6ivOYxYwKhioPUFigzomVNSnCZMzZcsvIjsm+q0UkiCdJf9UcK8/uV
tW/3RWLO4SmqAxe+IMnjMO54Bpx1vyLm3jzDC3s4ndtAadQ7+GIvan9RsalRIhjM
e851BiXf1URA6BJAVW6bDVOS9ycCAwEAAaOCIO0wgiDpMB0GA1UdDgQWBBRnOjrB
a7ccpkFGOTCEyGkAWRFYwTAfBgNVHSMEGDAWgBQKhal3ZQWYfECB+A+XLDjxCuw8
zzASBgNVHRMBAf8ECDAGAQH/AgEAMA4GA1UdDwEB/wQEAwIBBjAdBgNVHSUEFjAU
BggrBgEFBQcDAQYIKwYBBQUHAwIwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDovL3Jl
cG9zaXRvcnkuc2Vjb210cnVzdC5uZXQvU0MtUm9vdDIvU0NSb290MkNSTC5jcmww
UgYDVR0gBEswSTBHBgoqgwiMmxtkhwUEMDkwNwYIKwYBBQUHAgEWK2h0dHBzOi8v
cmVwb3NpdG9yeS5zZWNvbXRydXN0Lm5ldC9TQy1Sb290Mi8wgYUGCCsGAQUFBwEB
BHkwdzAwBggrBgEFBQcwAYYkaHR0cDovL3Njcm9vdGNhMi5vY3NwLnNlY29tdHJ1
c3QubmV0MEMGCCsGAQUFBzAChjdodHRwOi8vcmVwb3NpdG9yeS5zZWNvbXRydXN0
Lm5ldC9TQy1Sb290Mi9TQ1Jvb3QyY2EuY2VyMIIfOwYDVR0eBIIfMjCCHy6ggh74
MAuCCWFndS5hYy5qcDARgg9haWNoaS1lZHUuYWMuanAwE4IRYWljaGktZmFtLXUu
YWMuanAwE4IRYWljaGktbWVkLXUuYWMuanAwEIIOYWljaGktcHUuYWMuanAwEoIQ
YWljaGktdG9oby5hYy5qcDAPgg1haWNoaS11LmFjLmpwMA6CDGFpdGVjaC5hYy5q
cDAOggxha2FzaGkuYWMuanAwEYIPYWtpdGEtbmN0LmFjLmpwMA+CDWFraXRhLXUu
YWMuanAwEIIOYW5hbi1uY3QuYWMuanAwDoIMYW5kcmV3LmFjLmpwMAuCCWFwdS5h
Yy5qcDASghBhcmlha2UtbmN0LmFjLmpwMBWCE2FzYWhpa2F3YS1tZWQuYWMuanAw
FYITYXNhaGlrYXdhLW5jdC5hYy5qcDAPgg1hc2FoaS11LmFjLmpwMBCCDmJ1a2t5
by11LmFjLmpwMA6CDGJ1bmt5by5hYy5qcDAPgg1idW5yaS11LmFjLmpwMBCCDmNo
aWJha291ZGFpLmpwMA6CDGNoaWt5dS5hYy5qcDANggtjaHVidS5hYy5qcDAQgg5j
aHVreW8tdS5hYy5qcDAOggxjaHVvLXUuYWMuanAwEoIQY29uc29ydGl1bS5vci5q
cDAQgg5kYWlkby1pdC5hYy5qcDANggtkYWl0by5hYy5qcDAOggxkZW5kYWkuYWMu
anAwF4IVZGV2ZWxvcG1lbnQtc2Nob29sLmpwMA2CC2RvaHRvLmFjLmpwMBGCD2Rv
a2t5b21lZC5hYy5qcDAQgg5kb3NoaXNoYS5hYy5qcDAMggplZHVyb2FtLmpwMA+C
DWVoaW1lLXUuYWMuanAwDIIKZW5yaS5nby5qcDALgglmY3UuYWMuanAwDoIMZmRj
bmV0LmFjLmpwMA6CDGZlcnJpcy5hYy5qcDALgglmZXJyaXMuanAwC4IJZml0LmFj
LmpwMAuCCWZtdS5hYy5qcDALgglmcHUuYWMuanAwEYIPZnVqaXRhLWh1LmFjLmpw
MBGCD2Z1a3VpLW5jdC5hYy5qcDAOggxmdWt1am8uYWMuanAwE4IRZnVrdW9rYS1l
ZHUuYWMuanAwFYITZnVrdW9rYS1pbnQtdS5hYy5qcDARgg9mdWt1b2thLXUuYWMu
anAwFYITZnVrdXNoaW1hLW5jdC5hYy5qcDATghFmdWt1c2hpbWEtdS5hYy5qcDAS
ghBmdWt1eWFtYS11LmFjLmpwMAuCCWZ1bi5hYy5qcDAMggpnYWt1bmluLmpwMA+C
DWdpZnUtY24uYWMuanAwE4IRZ2lmdS1rZWl6YWkuYWMuanAwEIIOZ2lmdS1uY3Qu
YWMuanAwD4INZ2lmdS1wdS5hYy5qcDAOggxnaWZ1LXUuYWMuanAwC4IJZ2t1LmFj
LmpwMA2CC2dyaXBzLmFjLmpwMBCCDmd1bm1hLWN0LmFjLmpwMA+CDWd1bm1hLXUu
YWMuanAwFIISaGFjaGlub2hlLWN0LmFjLmpwMBOCEWhhY2hpbm9oZS11LmFjLmpw
MBOCEWhha29kYXRlLWN0LmFjLmpwMBCCDmhhbWEtbWVkLmFjLmpwMBSCEmhlaXNl
aS1pcnlvdS5hYy5qcDAQgg5oZWlzZWktdS5hYy5qcDAIggZoZ3UuanAwDIIKaGly
b2RhaS5qcDAPgg1oaXJva291ZGFpLmpwMBKCEGhpcm9zYWtpLXUuYWMuanAwFYIT
aGlyb3NoaW1hLWNtdC5hYy5qcDAUghJoaXJvc2hpbWEtY3UuYWMuanAwE4IRaGly
b3NoaW1hLXUuYWMuanAwEIIOaGlyb3NoaW1hLXUuanAwD4INaGktdGVjaC5hYy5q
cDANggtoaXQtdS5hYy5qcDAMggpobWpjLmFjLmpwMBKCEGhva2thaS1zLXUuYWMu
anAwEYIPaG9ra3lvZGFpLmFjLmpwMA+CDWhva3VkYWkuYWMuanAwE4IRaG9rdS1p
cnlvLXUuYWMuanAwEoIQaG9rdXJpa3UtdS5hYy5qcDAPgg1oeW9nby11LmFjLmpw
MA2CC2lhbWFzLmFjLmpwMAqCCGlhbWFzLmpwMA+CDWliYXJha2kuYWMuanAwEoIQ
aWJhcmFraS1jdC5hYy5qcDALgglpY2MuYWMuanAwEoIQaWNoaW5vc2VraS5hYy5q
cDALgglpY3UuYWMuanAwEIIOaWdha3VrZW4ub3IuanAwC4IJaW1zLmFjLmpwMBCC
DmludGVybmV0LmFjLmpwMAuCCWlvdC5hYy5qcDAJggdpcG11LmpwMA6CDGlyaS10
b2t5by5qcDAKgghpcm9vcC5qcDAUghJpc2hpa2F3YS1uY3QuYWMuanAwC4IJaXNt
LmFjLmpwMBCCDml0LWNoaWJhLmFjLmpwMBSCEml0LWhpcm9zaGltYS5hYy5qcDAP
gg1pd2FraW11LmFjLmpwMBGCD2l3YXRlLW1lZC5hYy5qcDAPgg1pd2F0ZS11LmFj
LmpwMA2CC2phaXN0LmFjLmpwMA+CDWphbXN0ZWMuZ28uanAwCYIHamF4YS5qcDAM
ggpqLWZvY3VzLmpwMA2CC2ppY2hpLmFjLmpwMA6CDGppbi1haS5hYy5qcDAOggxq
aW5kYWkuYWMuanAwDYILam9zaG8uYWMuanAwC4IJai1wYXJjLmpwMA6CDGpyY2hj
bi5hYy5qcDAMggpqc3BzLmdvLmpwMAyCCmp1ZW4uYWMuanAwFYITa2FjaG8tY29s
bGVnZS5hYy5qcDAOggxrYWV0c3UuYWMuanAwEoIQa2FnYXdhLW5jdC5hYy5qcDAQ
gg5rYWdhd2EtdS5hYy5qcDAUghJrYWdvc2hpbWEtY3QuYWMuanAwE4IRa2Fnb3No
aW1hLXUuYWMuanAwEIIOa2FpeW9kYWkuYWMuanAwE4IRa2FuYWdhd2EtaXQuYWMu
anAwE4IRa2FuYXphd2EtZ3UuYWMuanAwEoIQa2FuYXphd2EtdS5hYy5qcDALgglr
YW5kYWkuanAwEIIOa2Fuc2FpLXUuYWMuanAwFIISa2FzZWktZ2FrdWluLmFjLmpw
MAuCCWtidS5hYy5qcDALgglrY3QuYWMuanAwDIIKa2N1YS5hYy5qcDAMggprZWlv
LmFjLmpwMAmCB2tlaW8uanAwCIIGa2VrLmpwMA6CDGtpbmRhaS5hYy5qcDARgg9r
aW5qby1nYWt1aW4uanAwD4INa2luam8tdS5hYy5qcDAPgg1raXJ5dS11LmFjLmpw
MBCCDmtpc2FyYXp1LmFjLmpwMAuCCWtpdC5hYy5qcDAIggZraXQuanAwEYIPa2l0
YWt5dS11LmFjLmpwMBGCD2tpdGFtaS1pdC5hYy5qcDARgg9rLWp1bnNoaW4uYWMu
anAwDoIMa29iZS1jLmFjLmpwMBGCD2tvYmUtY29sbGVnZS5qcDARgg9rb2JlLWN1
ZnMuYWMuanAwEoIQa29iZS1rb3Nlbi5hYy5qcDATghFrb2JlLXRva2l3YS5hYy5q
cDAOggxrb2JlLXUuYWMuanAwEIIOa29jaGktY3QuYWMuanAwDYILa29jaGktY3Qu
anAwEIIOa29jaGktbXMuYWMuanAwEoIQa29jaGktdGVjaC5hYy5qcDAPgg1rb2No
aS11LmFjLmpwMAyCCmtvY2hpLXUuanAwEIIOa29nYWt1aW4uYWMuanAwEoIQa29r
dWdha3Vpbi5hYy5qcDASghBrb2t1c2hpa2FuLmFjLmpwMA2CC2tvc2VuLWFjLmpw
MA+CDWtvc2VuLWsuZ28uanAwDYILa3BwdWMuYWMuanAwC4IJa3B1LmFjLmpwMA2C
C2twdS1tLmFjLmpwMAyCCmt1YXMuYWMuanAwDIIKa3Vmcy5hYy5qcDALgglrdWlu
cy5uZXQwEIIOa3VtYWdha3UuYWMuanAwFIISa3VtYW1vdG8taHN1LmFjLmpwMBSC
Emt1bWFtb3RvLW5jdC5hYy5qcDASghBrdW1hbW90by11LmFjLmpwMBGCD2t1bml0
YWNoaS5hYy5qcDAQgg5rdXJlLW5jdC5hYy5qcDARgg9rdXJ1bWUtaXQuYWMuanAw
EoIQa3VydW1lLW5jdC5hYy5qcDAVghNrdXJ1bWUtc2hpbmFpLmFjLmpwMBCCDmt1
cnVtZS11LmFjLmpwMBKCEGt1c2hpcm8tY3QuYWMuanAwDIIKa3d1Yy5hYy5qcDAP
gg1reW9oYWt1LmdvLmpwMBCCDmt5b2t5by11LmFjLmpwMBGCD2t5b3RvLWFydC5h
Yy5qcDASghBreW90by1lY29uLmFjLmpwMBWCE2t5b3RvZ2FrdWVuLXUuYWMuanAw
FIISa3lvdG9rYWNoby11LmFjLmpwMBCCDmt5b3RvLXN1LmFjLmpwMA+CDWt5b3Rv
LXUuYWMuanAwDIIKa3lvdG8tdS5qcDAQgg5reW90by13dS5hYy5qcDAQgg5reXUt
ZGVudC5hYy5qcDAQgg5reXVreW8tdS5hYy5qcDAQgg5reXVzYW4tdS5hYy5qcDAQ
gg5reXVzaHUtdS5hYy5qcDAPgg1reXV0ZWNoLmFjLmpwMAyCCmt5dXRlY2guanAw
EoIQbWFpenVydS1jdC5hYy5qcDARgg9tYXRzdWUtY3QuYWMuanAwDoIMbWF0c3Vl
LWN0LmpwMBOCEW1hdHN1eWFtYS11LmFjLmpwMBCCDm1hdHN1eWFtYS11LmpwMA+C
DW1laWppLXUuYWMuanAwDoIMbWVpby11LmFjLmpwMBCCDm1laXJpbi1jLmFjLmpw
MA6CDG1lamlyby5hYy5qcDARgg9tZXRyby1jaXQuYWMuanAwDYILbWllLXUuYWMu
anAwD4INbWlucGFrdS5hYy5qcDAWghRtaXlha29ub2pvLW5jdC5hYy5qcDARgg9t
aXlha3lvLXUuYWMuanAwFIISbWl5YXNhbmtlaS11LmFjLmpwMBOCEW1peWF6YWtp
LW11LmFjLmpwMBKCEG1peWF6YWtpLXUuYWMuanAwC4IJbXB1LmFjLmpwMBKCEG11
cm9yYW4taXQuYWMuanAwDoIMbXVzYWJpLmFjLmpwMAuCCW15anVlbi5qcDAQgg5t
eS1waGFybS5hYy5qcDALgglteXUuYWMuanAwEIIObmFidW5rZW4uZ28uanAwDoIM
bmFnYW5vLmFjLmpwMBKCEG5hZ2Fuby1uY3QuYWMuanAwEoIQbmFnYW9rYS1jdC5h
Yy5qcDARgg9uYWdhb2thdXQuYWMuanAwEoIQbmFnYXNha2ktdS5hYy5qcDAUghJu
YWdveWEtYnVucmkuYWMuanAwEYIPbmFnb3lhLWN1LmFjLmpwMBCCDm5hZ295YS11
LmFjLmpwMA2CC25hZ295YS11LmpwMBGCD25hZ295YS13dS5hYy5qcDAKgghuYWlz
dC5qcDARgg9uYWthbmlzaGkuYWMuanAwC4IJbmFuemFuLmpwMBCCDm5hbnphbi11
LmFjLmpwMAuCCW5hby5hYy5qcDAQgg5uYXJhLWVkdS5hYy5qcDAQgg5uYXJhaGFr
dS5nby5qcDAOggxuYXJhLWsuYWMuanAwEYIPbmFyYW1lZC11LmFjLmpwMA+CDW5h
cmEtd3UuYWMuanAwDIIKbmFyZWdpLm9yZzAQgg5uYXJ1dG8tdS5hYy5qcDAMggpu
Y2dnLmdvLmpwMAyCCm5jZ20uZ28uanAwDIIKbmNucC5nby5qcDARgg9uYy10b3lh
bWEuYWMuanAwDoIMbmV0bmZ1Lm5lLmpwMA2CC25ldXJvaW5mLmpwMAiCBm5mdS5q
cDALggluZnUubmUuanAwEYIPbi1mdWt1c2hpLmFjLmpwMAyCCm5pYXMuYWMuanAw
DIIKbmliYi5hYy5qcDAMggpuaWNoLmdvLmpwMBCCDm5pY2hpYnVuLmFjLmpwMAyC
Cm5pZnMuYWMuanAwDoIMbmlmcy1rLmFjLmpwMAuCCW5pZy5hYy5qcDALggluaWgu
Z28uanAwD4INbmlob24tdS5hYy5qcDAJggduaWh1LmpwMAuCCW5paS5hYy5qcDAM
ggpuaWlkLmdvLmpwMBGCD25paWdhdGEtdS5hYy5qcDATghFuaWloYW1hLW5jdC5h
Yy5qcDAMggpuaW1zLmdvLmpwMA6CDG5pbmphbC5hYy5qcDAJggduaW5zLmpwMAyC
Cm5pcGguZ28uanAwDIIKbmlwci5hYy5qcDAMggpuaXBzLmFjLmpwMBaCFG5pc2hv
Z2FrdXNoYS11LmFjLmpwMA6CDG5pdGVjaC5hYy5qcDALggluaXRlY2guanAwDoIM
bml0dGFpLmFjLmpwMAyCCm5peWUuZ28uanAwDYILbm9kYWkuYWMuanAwEIIObi1z
ZWlyeW8uYWMuanAwC4IJbnVhLmFjLmpwMAyCCm51YXMuYWMuanAwDYILbnVjYmEu
YWMuanAwDIIKbnVmcy5hYy5qcDAMggpudWh3LmFjLmpwMAyCCm51aXMuYWMuanAw
EYIPbnVtYXp1LWN0LmFjLmpwMAmCB253ZWMuanAwD4INb2JpaGlyby5hYy5qcDAO
ggxvYmlyaW4uYWMuanAwDIIKb2NoYS5hYy5qcDAJggdvaXN0LmpwMAuCCW9pdC5h
Yy5qcDAPgg1vaXRhLWN0LmFjLmpwMA6CDG9pdGEtdS5hYy5qcDALgglva2FkYWku
anAwDoIMb2thLXB1LmFjLmpwMBGCD29rYXlhbWEtdS5hYy5qcDASghBva2luYXdh
LWN0LmFjLmpwMBGCD29raW5hd2EtdS5hYy5qcDAMggpva2l1LmFjLmpwMBKCEG9u
b21pY2hpLXUuYWMuanAwDIIKb3Blbi5lZC5qcDAOggxvc2FrYWMuYWMuanAwEIIO
b3Nha2EtY3UuYWMuanAwEYIPb3Nha2FmdS11LmFjLmpwMBSCEm9zYWthLWt5b2lr
dS5hYy5qcDARgg9vc2FrYS1wY3QuYWMuanAwD4INb3Nha2EtdS5hYy5qcDAQgg5v
c2hpbWEtay5hYy5qcDANggtvdGFuaS5hYy5qcDAQgg5vdGFydS11Yy5hYy5qcDAO
ggxvdGVtb24uYWMuanAwDIIKb3Vocy5hYy5qcDALgglvdXMuYWMuanAwEIIOb3lh
bWEtY3QuYWMuanAwCoIIcGRiai5vcmcwFIIScHUtaGlyb3NoaW1hLmFjLmpwMBOC
EXB1LWt1bWFtb3RvLmFjLmpwMAuCCXFzdC5nby5qcDAOggxyYWt1bm8uYWMuanAw
DYILcmVoYWIuZ28uanAwEYIPcmVpdGFrdS11LmFjLmpwMBCCDnJla2loYWt1LmFj
LmpwMA2CC3Jpa2VuLmdvLmpwMAqCCHJpa2VuLmpwMA6CDHJpa2t5by5hYy5qcDAO
ggxyaWtreW8ubmUuanAwEIIOcml0c3VtZWkuYWMuanAwC4IJcmt1LmFjLmpwMAyC
CnJvaXMuYWMuanAwEYIPcnVjb25zb3J0aXVtLmpwMA+CDXJ5dWtva3UuYWMuanAw
DoIMc2FnYS11LmFjLmpwMBGCD3NhaXRhbWEtdS5hYy5qcDANggtzYW5uby5hYy5q
cDAOggxzYXBtZWQuYWMuanAwEYIPc2FwcG9yby11LmFjLmpwMA6CDHNhc2Viby5h
Yy5qcDALgglzY3UuYWMuanAwDYILc2Vpam8uYWMuanAwEIIOc2Vpam9oLXUuYWMu
anAwDoIMc2Vpa2VpLmFjLmpwMBKCEHNlaW5hbi1nYWt1aW4uanAwEYIPc2VpbmFu
LWd1LmFjLmpwMA6CDHNlaXJlaS5hYy5qcDASghBzZWlzYWRvaHRvLmFjLmpwMA6C
DHNlaXNlbi5hYy5qcDAQgg5zZWlzZW4tdS5hYy5qcDASghBzZW5kYWktbmN0LmFj
LmpwMBCCDnNlbnNodS11LmFjLmpwMA2CC3NlbnNodS11LmpwMBCCDnNldHN1bmFu
LmFjLmpwMAuCCXNnay5hYy5qcDALgglzZ3UuYWMuanAwE4IRc2hpYmF1cmEtaXQu
YWMuanAwDoIMc2hpZ2Fra2FuLmpwMBGCD3NoaWdhLW1lZC5hYy5qcDAPgg1zaGln
YS11LmFjLmpwMBGCD3NoaW1hbmUtdS5hYy5qcDAWghRzaGltb25vc2VraS1jdS5h
Yy5qcDARgg9zaGlub25vbWUuYWMuanAwEYIPc2hpbnNodS11LmFjLmpwMBGCD3No
aXJheXVyaS5hYy5qcDAQgg5zaGl6dW9rYS5hYy5qcDAOggxzaG9kYWkuYWMuanAw
DoIMc2hva2VpLmFjLmpwMBGCD3Nob25hbi1pdC5hYy5qcDAPgg1zaG90b2t1LmFj
LmpwMAyCCnNob3Rva3UuanAwD4INc2hvd2EtdS5hYy5qcDAOggxzaHVidW4uYWMu
anAwDYILc2luZXQuYWQuanAwDIIKc2lzdC5hYy5qcDALgglzaXUuYWMuanAwDIIK
c29jdS5hYy5qcDAOggxzb2pvLXUuYWMuanAwDIIKc29rYS5hYy5qcDANggtzb2tl
bi5hYy5qcDAPgg1zcHJpbmc4Lm9yLmpwMBKCEHN1Z2l5YW1hLXUuYWMuanAwEYIP
c3V6dWthLWN0LmFjLmpwMAuCCXN3dS5hYy5qcDAQgg50YW1hZ2F3YS5hYy5qcDAN
ggt0YW1hZ2F3YS5qcDALggl0YXUuYWMuanAwC4IJdGN1LmFjLmpwMAyCCnRjdWUu
YWMuanAwC4IJdGRjLmFjLmpwMBCCDnRlaWt5by11LmFjLmpwMA6CDHRlbnNoaS5h
Yy5qcDAUghJ0ZXp1a2F5YW1hLXUuYWMuanAwCIIGdGd1LmpwMAuCCXRodS5hYy5q
cDAOggx0aXRlY2guYWMuanAwC4IJdG1kLmFjLmpwMAiCBnRubS5qcDAQgg50b2Jh
LWNtdC5hYy5qcDAQgg50b2J1bmtlbi5nby5qcDAOggx0b2hva3UuYWMuanAwFYIT
dG9ob2t1LWdha3Vpbi5hYy5qcDASghB0b2hva3UtZ2FrdWluLmpwMBKCEHRvaG9r
dS1tcHUuYWMuanAwDoIMdG9oby11LmFjLmpwMA+CDXRvaHRlY2guYWMuanAwDoIM
dG9raXdhLmFjLmpwMA6CDHRva29oYS5hYy5qcDARgg90b2tvaGEtamMuYWMuanAw
EIIOdG9rb2hhLXUuYWMuanAwE4IRdG9rdXNoaW1hLXUuYWMuanAwEIIOdG9rdXlh
bWEuYWMuanAwEIIOdG9reW8tY3QuYWMuanAwFIISdG9tYWtvbWFpLWN0LmFjLmpw
MBGCD3RvdHRvcmktdS5hYy5qcDAOggx0b3lha3UuYWMuanAwDIIKdG95by5hYy5q
cDARgg90b3lvdGEtY3QuYWMuanAwD4INdHN1a3ViYS5hYy5qcDARgg90c3VrdWJh
LWcuYWMuanAwFIISdHN1a3ViYS10ZWNoLmFjLmpwMBSCEnRzdXJ1LWdha3Vlbi5h
Yy5qcDARgg90c3VydW1pLXUuYWMuanAwFIISdHN1cnVva2EtbmN0LmFjLmpwMBKC
EHRzdXlhbWEtY3QuYWMuanAwDIIKdHVhdC5hYy5qcDAMggp0dWZzLmFjLmpwMAyC
CnR1aXMuYWMuanAwDIIKdHVzeS5hYy5qcDALggl0dXQuYWMuanAwDIIKdHdjdS5h
Yy5qcDAOggx1LWFpenUuYWMuanAwDYILdWJlLWsuYWMuanAwC4IJdWVjLmFjLmpw
MA+CDXUtZnVrdWkuYWMuanAwEYIPdS1nYWt1Z2VpLmFjLmpwMA+CDXUtaHlvZ28u
YWMuanAwD4INdS1rb2NoaS5hYy5qcDAQgg51LW5hZ2Fuby5hYy5qcDAPgg11bml2
ZXJzaXR5LmpwMA6CDHVvZWgtdS5hYy5qcDAJggd1cGtpLmpwMBCCDnUtcnl1a3l1
LmFjLmpwMBGCD3Utc2hpbWFuZS5hYy5qcDAWghR1LXNoaXp1b2thLWtlbi5hYy5q
cDAPgg11LXRva3lvLmFjLmpwMBCCDnUtdG95YW1hLmFjLmpwMBSCEnV0c3Vub21p
eWEtdS5hYy5qcDAUghJ3YWtheWFtYS1uY3QuYWMuanAwEoIQd2FrYXlhbWEtdS5h
Yy5qcDAOggx3YWtob2suYWMuanAwEoIQeWFtYWdhdGEtdS5hYy5qcDATghF5YW1h
Z3VjaGktdS5hYy5qcDARgg95YW1hbmFzaGkuYWMuanAwDIIKeWdqYy5hYy5qcDAL
ggl5Z3UuYWMuanAwC4IJeW51LmFjLmpwMBCCDnlvbmFnby1rLmFjLmpwMAyCCnl1
Z2UuYWMuanAwEYIPdGVpa3lvLWpjLmFjLmpwMBCCDm9zYWthLXVlLmFjLmpwMA2C
C3RzdWRhLmFjLmpwMAuCCW5ndS5hYy5qcDALggljMmMuYWMuanAwDoIMYW95YW1h
LmFjLmpwMBGCD3VwYy1vc2FrYS5hYy5qcDAIggZmaXQuanAwE4IRZnVrdW9rYS13
amMuYWMuanChMDAKhwgAAAAAAAAAADAihyAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAADANBgkqhkiG9w0BAQsFAAOCAQEAxWH4we4kk599n+wSNrDE1GDB
1P+tBW+X0EUHMeow5Db6EzNFBVr/bgxD/4dTKh0coWo6wzExCBKwag9S4j2eYNre
uy8X++HPRoXEqoKhOAIvgj9RLw1eGhW6OJoC++pUXHOAINUrYLgpwxiAZfw0oDAe
+NrOXXP/LwDP85gKq+2/QGCsENsxLC4tLhonANethBLExpHaiUhjDVD3IO8w9cmE
Fm4c6j6onhml5MChBfLeNoXlc7lG+CKgIV4lQ1AuedV/FcYtNXqADOe5hO4IKENQ
PBsG3+c22LGvqt4DsBMYHiGU4AFzT5BLWrYZv1TMIUQ+lSOWvLIsTQSN6WgQ3w==
-----END CERTIFICATE-----
"""
}

//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 24/10/2023.
//

import Foundation

extension RSAPEMStrings {
    public static let pkcs1PublicKey256: String =
"""
-----BEGIN RSA PUBLIC KEY-----
MCgCIQCuFLkFXTYxBC2p+aHDuh0TVz/wtrA7Wl8wNv9Okuki9QIDAQAB
-----END RSA PUBLIC KEY-----
"""
    
    public static let pkcs1PrivateKey256: String =
"""
-----BEGIN RSA PRIVATE KEY-----
MIGpAgEAAiEArhS5BV02MQQtqfmhw7odE1c/8LawO1pfMDb/TpLpIvUCAwEAAQIg
dmi+GXn3vIudC/szH1FfKIKM03qM58yY2NGZtYCONQECEQDlOtjFWDf1WCnrvkqK
d6IhAhEAwmke1m5crJb8rZQD2QKOVQIQJRYXOh5it0vzRFO+JZbjYQIQbbmg8wvU
+IA7Wsiop0m/BQIQXqsu0hQFYD+OL6qoGGqjEA==
-----END RSA PRIVATE KEY-----
"""
    
    public static let pkcs8PublicKey256: String =
"""
-----BEGIN PUBLIC KEY-----
MDwwDQYJKoZIhvcNAQEBBQADKwAwKAIhAK4UuQVdNjEELan5ocO6HRNXP/C2sDta
XzA2/06S6SL1AgMBAAE=
-----END PUBLIC KEY-----
"""
    
    public static let pkcs8PrivateKey256: String =
"""
-----BEGIN PRIVATE KEY-----
MIHBAgEAMA0GCSqGSIb3DQEBAQUABIGsMIGpAgEAAiEArhS5BV02MQQtqfmhw7od
E1c/8LawO1pfMDb/TpLpIvUCAwEAAQIgdmi+GXn3vIudC/szH1FfKIKM03qM58yY
2NGZtYCONQECEQDlOtjFWDf1WCnrvkqKd6IhAhEAwmke1m5crJb8rZQD2QKOVQIQ
JRYXOh5it0vzRFO+JZbjYQIQbbmg8wvU+IA7Wsiop0m/BQIQXqsu0hQFYD+OL6qo
GGqjEA==
-----END PRIVATE KEY-----
"""
}

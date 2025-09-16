//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 24/10/2023.
//

import Foundation

extension RSAPEMStrings {
    public static let pkcs1PublicKey512: String =
"""
-----BEGIN RSA PUBLIC KEY-----
MEgCQQDXzbIgqEHJtoviyGKBramsEbx2ZcvsM2cQv7Z8ysblMZJuldHfAJv8Ywyh
RpP9B7WaFTEuULVI11zZc40l5D3vAgMBAAE=
-----END RSA PUBLIC KEY-----
"""
    
    public static let pkcs1PrivateKey512: String =
"""
-----BEGIN RSA PRIVATE KEY-----
MIIBPAIBAAJBANfNsiCoQcm2i+LIYoGtqawRvHZly+wzZxC/tnzKxuUxkm6V0d8A
m/xjDKFGk/0HtZoVMS5QtUjXXNlzjSXkPe8CAwEAAQJBAMwDBZah+i+7h1sJnTaC
+phU3BoB+lp97b2Dv/0Rph4clVYYm2fVzCXw01JBMDaaanur4JX/9PsoZHhxsm0U
gkECIQD+CDWHgGej6UOqxcPA2Aatg2s/9nov8tr6Vh46HjybGQIhANl5rDJehsWd
wRXqbv9oMgg+xGb85bsOGb1lcSU4QEpHAiEA6gzqNOQrmSusOsVnbGAdFvUEdbRE
M7VP6GI8C1QchtECIElRsxNcORXA5MsNuZRUPaH3/2E1XAJfc6Ad5jKFL2+bAiEA
5Xn0xMwVSfHs0lunjfYJP5/c20omEAxMWvelDen+nDo=
-----END RSA PRIVATE KEY-----
"""
    
    public static let pkcs8PublicKey512: String =
"""
-----BEGIN PUBLIC KEY-----
MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBANfNsiCoQcm2i+LIYoGtqawRvHZly+wz
ZxC/tnzKxuUxkm6V0d8Am/xjDKFGk/0HtZoVMS5QtUjXXNlzjSXkPe8CAwEAAQ==
-----END PUBLIC KEY-----
"""
    
    public static let pkcs8PrivateKey512: String =
"""
-----BEGIN PRIVATE KEY-----
MIIBVgIBADANBgkqhkiG9w0BAQEFAASCAUAwggE8AgEAAkEA182yIKhBybaL4shi
ga2prBG8dmXL7DNnEL+2fMrG5TGSbpXR3wCb/GMMoUaT/Qe1mhUxLlC1SNdc2XON
JeQ97wIDAQABAkEAzAMFlqH6L7uHWwmdNoL6mFTcGgH6Wn3tvYO//RGmHhyVVhib
Z9XMJfDTUkEwNppqe6vglf/0+yhkeHGybRSCQQIhAP4INYeAZ6PpQ6rFw8DYBq2D
az/2ei/y2vpWHjoePJsZAiEA2XmsMl6GxZ3BFepu/2gyCD7EZvzluw4ZvWVxJThA
SkcCIQDqDOo05CuZK6w6xWdsYB0W9QR1tEQztU/oYjwLVByG0QIgSVGzE1w5FcDk
yw25lFQ9off/YTVcAl9zoB3mMoUvb5sCIQDlefTEzBVJ8ezSW6eN9gk/n9zbSiYQ
DExa96UN6f6cOg==
-----END PRIVATE KEY-----
"""
}

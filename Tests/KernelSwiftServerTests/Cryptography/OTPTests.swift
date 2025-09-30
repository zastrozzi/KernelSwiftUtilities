//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 17/05/2025.
//

import Testing
import KernelSwiftServer
import KernelSwiftCommon
import Vapor


@Suite
public struct OTPTests {
//    let dataSHA1 = "12345678901234567890".data(using: String.Encoding.ascii)!
    let dataSHA1 = Array("12345678901234567890".utf8)
    let dataSHA256 = "12345678901234567890123456789012".utf8Bytes
    let dataSHA512 = "1234567890123456789012345678901234567890123456789012345678901234".utf8Bytes
    
    @Test
    func testGenerator6DigitHexSHA1() {
        let secret: [UInt8] = .init(fromHexString: "3132333435363738393031323334353637383930") ?? []
        #expect(KernelCryptography.Services.OTPService.generateOTP(secret: secret, algorithm: .sha1, counter: 0) == "755224")
        #expect(KernelCryptography.Services.OTPService.generateOTP(secret: secret, algorithm: .sha1, counter: 1) == "287082")
        #expect(KernelCryptography.Services.OTPService.generateOTP(secret: secret, algorithm: .sha1, counter: 2) == "359152")
    }
    
    @Test
    func testGenerator7DigitHexSHA1() {
        let secret: [UInt8] = .init(fromHexString: "3132333435363738393031323334353637383930") ?? []
        #expect(KernelCryptography.Services.OTPService.generateOTP(secret: secret, algorithm: .sha1, counter: 0, digits: 7) == "4755224")
        #expect(KernelCryptography.Services.OTPService.generateOTP(secret: secret, algorithm: .sha1, counter: 1, digits: 7) == "4287082")
        #expect(KernelCryptography.Services.OTPService.generateOTP(secret: secret, algorithm: .sha1, counter: 2, digits: 7) == "7359152")
    }
    
    @Test
    func testGenerator8DigitHexSHA1() {
        let secret: [UInt8] = .init(fromHexString: "3132333435363738393031323334353637383930") ?? []
        #expect(KernelCryptography.Services.OTPService.generateOTP(secret: secret, algorithm: .sha1, counter: 0, digits: 8) == "84755224")
        #expect(KernelCryptography.Services.OTPService.generateOTP(secret: secret, algorithm: .sha1, counter: 1, digits: 8) == "94287082")
        #expect(KernelCryptography.Services.OTPService.generateOTP(secret: secret, algorithm: .sha1, counter: 2, digits: 8) == "37359152")
    }
    
    @Test
    func testTOTP01() throws {
        let totp = try KernelCryptography.OTP.TOTP(secret: dataSHA1, digits: 8, timeInterval: 30, algorithm: .sha1)
        #expect(try totp.generate(secondsPast1970: 59) == "94287082")
    }
    
    @Test
    func testTOTP02() throws {
        let totp = try KernelCryptography.OTP.TOTP(secret: dataSHA256, digits: 8, timeInterval: 30, algorithm: .sha256)
        #expect(try totp.generate(secondsPast1970: 59) == "46119246")
    }
    
    @Test
    func testTOTP03() throws {
        let totp = try KernelCryptography.OTP.TOTP(secret: dataSHA512, digits: 8, timeInterval: 30, algorithm: .sha512)
        #expect(try totp.generate(secondsPast1970: 59) == "90693936")
    }
    
    @Test
    func testTOTP04() throws {
        let totp = try KernelCryptography.OTP.TOTP(secret: dataSHA1, digits: 8, timeInterval: 30, algorithm: .sha1)
        #expect(try totp.generate(secondsPast1970: 1111111109) == "07081804")
    }
    
    @Test
    func testTOTP05() throws {
        let totp = try KernelCryptography.OTP.TOTP(secret: dataSHA256, digits: 8, timeInterval: 30, algorithm: .sha256)
        #expect(try totp.generate(secondsPast1970: 1111111109) == "68084774")
    }
    
    @Test
    func testTOTP06() throws {
        let totp = try KernelCryptography.OTP.TOTP(secret: dataSHA512, digits: 8, timeInterval: 30, algorithm: .sha512)
        #expect(try totp.generate(secondsPast1970: 1111111109) == "25091201")
    }
    
    @Test
    func testTOTP07() throws {
        let totp = try KernelCryptography.OTP.TOTP(secret: dataSHA1, digits: 8, timeInterval: 30, algorithm: .sha1)
        #expect(try totp.generate(secondsPast1970: 1111111111) == "14050471")
    }
    
    @Test
    func testTOTP08() throws {
        let totp = try KernelCryptography.OTP.TOTP(secret: dataSHA256, digits: 8, timeInterval: 30, algorithm: .sha256)
        #expect(try totp.generate(secondsPast1970: 1111111111) == "67062674")
    }
    
    @Test
    func testTOTP09() throws {
        let totp = try KernelCryptography.OTP.TOTP(secret: dataSHA512, digits: 8, timeInterval: 30, algorithm: .sha512)
        #expect(try totp.generate(secondsPast1970: 1111111111) == "99943326")
    }
    
    @Test
    func testTOTP10() throws {
        let totp = try KernelCryptography.OTP.TOTP(secret: dataSHA1, digits: 8, timeInterval: 30, algorithm: .sha1)
        #expect(try totp.generate(secondsPast1970: 1234567890) == "89005924")
    }
    
    @Test
    func testTOTP11() throws {
        let totp = try KernelCryptography.OTP.TOTP(secret: dataSHA256, digits: 8, timeInterval: 30, algorithm: .sha256)
        #expect(try totp.generate(secondsPast1970: 1234567890) == "91819424")
    }
    
    @Test
    func testTOTP12() throws {
        let totp = try KernelCryptography.OTP.TOTP(secret: dataSHA512, digits: 8, timeInterval: 30, algorithm: .sha512)
        #expect(try totp.generate(secondsPast1970: 1234567890) == "93441116")
    }
    
    @Test
    func testTOTP13() throws {
        let totp = try KernelCryptography.OTP.TOTP(secret: dataSHA1, digits: 8, timeInterval: 30, algorithm: .sha1)
        #expect(try totp.generate(secondsPast1970: 2000000000) == "69279037")
    }
    
    @Test
    func testTOTP14() throws {
        let totp = try KernelCryptography.OTP.TOTP(secret: dataSHA256, digits: 8, timeInterval: 30, algorithm: .sha256)
        #expect(try totp.generate(secondsPast1970: 2000000000) == "90698825")
    }
    
    @Test
    func testTOTP15() throws {
        let totp = try KernelCryptography.OTP.TOTP(secret: dataSHA512, digits: 8, timeInterval: 30, algorithm: .sha512)
        #expect(try totp.generate(secondsPast1970: 2000000000) == "38618901")
    }
    
    @Test
    func testTOTP16() throws {
        let totp = try KernelCryptography.OTP.TOTP(secret: dataSHA1, digits: 8, timeInterval: 30, algorithm: .sha1)
        #expect(try totp.generate(secondsPast1970: 20000000000) == "65353130")
    }
    
    @Test
    func testTOTP17() throws {
        let totp = try KernelCryptography.OTP.TOTP(secret: dataSHA256, digits: 8, timeInterval: 30, algorithm: .sha256)
        #expect(try totp.generate(secondsPast1970: 20000000000) == "77737706")
    }
    
    @Test
    func testTOTP18() throws {
        let totp = try KernelCryptography.OTP.TOTP(secret: dataSHA512, digits: 8, timeInterval: 30, algorithm: .sha512)
        #expect(try totp.generate(secondsPast1970: 20000000000) == "47863826")
    }
    
    @Test
    func testTOTPAfter20Seconds() throws {
        let sendTime = Date(timeIntervalSince1970: 20000000000)
        let totp = try KernelCryptography.OTP.TOTP(secret: dataSHA512, digits: 8, timeInterval: 30, algorithm: .sha512)
        let sentCode = try totp.generate(time: sendTime)
        let receivedCode = try totp.generate(time: sendTime.addingTimeInterval(5))
        let receivedLaterCode = try totp.generate(secondsPast1970: Int(sendTime.timeIntervalSince1970) + 40)
        #expect(sentCode == receivedCode)
        #expect(sentCode != receivedLaterCode)
    }
}

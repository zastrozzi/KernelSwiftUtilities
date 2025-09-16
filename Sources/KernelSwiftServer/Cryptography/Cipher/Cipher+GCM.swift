//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/10/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCryptography.Cipher {
    public struct GCM: CipherStrategy {
        public static let blockMode: KernelCryptography.Cipher.BlockMode = .GCM
        
        public var aes: AES
        public var macSecret: [UInt8]
        public var mode: CipherMode
        
        public var h: Block = val.blockZero
        public var j0: Block = val.blockZero
        public var cbi: Block = val.blockZero
        public var m0: [Block] = .init(repeating: val.blockZero, count: 16)
        
        public init(secret: [UInt8], macSecret: [UInt8]) {
            self.init(secret, macSecret)
            let c = macSecret.count * 8
            j0 = c == 96 ? .init(macSecret + .zeroes(3) + [1]) : .init(macSecret)
            self.macSecret = []
            h = encryptBlock(val.blockZero)
            m0[val.shoupTable[1]] = h
            for i in stride(from: 2, to: 16, by: 2) {
                m0[val.shoupTable[i]] = m0[val.shoupTable[i >> 1]]
                m0[val.shoupTable[i]].double()
                m0[val.shoupTable[i + 1]] = m0[val.shoupTable[i]]
                m0[val.shoupTable[i + 1]].add(h)
            }
            if c != 96 {
                gHash(val.blockZero, &j0)
                gHash(.init(hi: .zero, lo: 128), &j0)
            }
            cbi = j0
        }
        
        public init(aes: AES, macSecret: [UInt8], mode: CipherMode) {
            self.aes = aes
            self.macSecret = macSecret
            self.mode = mode
        }
        
        public func encryptBlock(_ block: Block) -> Block { .init(AES.encrypt(block.bytes, aes: aes)) }
        
        public func gHash(_ lhs: Block, _ rhs: inout Block) {
            rhs.add(lhs)
            multiplyH(&rhs)
        }
        
        public func gCtr(_ icb: Block, _ lhs: inout Block) {  lhs.add(encryptBlock(icb)) }
        
        public func gCtr(_ icb: Block, _ lhs: inout Block, removeCount: Int) {
            lhs.add(encryptBlock(icb))
            lhs.removeBytes(removeCount)
        }
        
        public func multiplyH(_ lhs: inout Block) {
            var (zhi, zlo): (Block.DoubleWord, Block.DoubleWord) = (.zero, .zero), lhi = lhs.hi, llo = lhs.lo
            for _ in stride(from: .zero, to: 64, by: 4) {
                let ri: Int = .init(zlo & 0xf)
                let n: Int = .init(llo & 0xf)
                zlo >>= 4
                zlo |= zhi << 60
                zhi >>= 4
                zhi ^= val.reductionTable[ri]
                zhi ^= m0[n].hi
                zlo ^= m0[n].lo
                llo >>= 4
            }
            for _ in stride(from: .zero, to: 64, by: 4) {
                let ri: Int = .init(zlo & 0xf)
                let n: Int = .init(lhi & 0xf)
                zlo >>= 4
                zlo |= zhi << 60
                zhi >>= 4
                zhi ^= val.reductionTable[ri]
                zhi ^= m0[n].hi
                zlo ^= m0[n].lo
                lhi >>= 4
            }
            lhs.hi = zhi
            lhs.lo = zlo
        }
        
        @discardableResult
        public mutating func decrypt(_ input: inout [UInt8]) throws -> [UInt8] { processBytes(&input, .decryption) }
        
        @discardableResult
        public mutating func encrypt(_ input: inout [UInt8]) throws -> [UInt8] { processBytes(&input, .encryption) }
        
        public mutating func processBytes(_ input: inout [UInt8], _ mode: CipherMode) -> [UInt8] {
            var t = val.blockZero, k = Int.zero, idx = Int.zero, buff: [UInt8] = .zeroes(AES.val.blockSize)
            for i in .zero..<input.count {
                buff[idx] = input[i]
                idx += 1
                if idx == AES.val.blockSize {
                    var b: Block = .init(buff)
                    cbi.increment()
                    gCtr(cbi, &b)
                    gHash(mode == .encryption ? b : .init(buff), &t)
                    let bBytes = b.bytes
                    for ii in .zero..<AES.val.blockSize {
                        input[k] = bBytes[ii]
                        k += 1
                    }
                    idx = .zero
                }
            }
            if idx > .zero {
                for i in idx..<buff.count { buff[i] = .zero }
                var b: Block = .init(buff)
                cbi.increment()
                gCtr(cbi, &b, removeCount: 16 - idx)
                gHash(mode == .encryption ? b : .init(buff), &t)
                let bBytes = b.bytes
                for ii in .zero..<idx {
                    input[k] = bBytes[ii]
                    k += 1
                }
            }
            gHash(.init(hi: .zero, lo: .init(input.count * 8)), &t)
            gCtr(j0, &t)
            return t.bytes
        }
    }
}


//public mutating func processBytes(_ input: inout ByteBuffer, _ mode: CipherMode) -> [UInt8] {
//    var t = val.blockZero, k = Int.zero, idx = Int.zero, buff: ByteBuffer = .init(bytes: [UInt8].zeroes(AES.val.blockSize))
//    for i in .zero..<input.readableBytes {
//        buff.setBytes(input.getBytes(at: i, length: 1)!, at: idx)
//        idx += 1
//        if idx == AES.val.blockSize {
//            var b: Block = .init(buff.readableBytesView.copyBytes())
//            cbi.increment()
//            gCtr(cbi, &b)
//            gHash(mode == .encryption ? b : .init(buff.readableBytesView.copyBytes()), &t)
//            let bBytes = b.bytes
//            for ii in .zero..<AES.val.blockSize {
//                input.setBytes(bBytes[0..<AES.val.blockSize], at: k)
//                //                        k += 1
//            }
//            idx = .zero
//        }
//    }
//    if idx > .zero {
//        for i in idx..<buff.count { buff[i] = .zero }
//        var b: Block = .init(buff)
//        cbi.increment()
//        gCtr(cbi, &b, removeCount: 16 - idx)
//        gHash(mode == .encryption ? b : .init(buff), &t)
//        let bBytes = b.bytes
//        for ii in .zero..<idx {
//            input[k] = bBytes[ii]
//            k += 1
//        }
//    }
//    gHash(.init(hi: .zero, lo: .init(input.count * 8)), &t)
//    gCtr(j0, &t)
//    return t.bytes
//}

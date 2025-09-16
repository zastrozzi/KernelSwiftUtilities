//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 16/10/2023.
//

import Foundation
import Collections

extension KernelNumerics.BigInt.ConstantValues {
    public typealias prime = Prime
    
    @_documentation(visibility: private)
    public enum Prime {
        @_documentation(visibility: private)
        public typealias BigInt = KernelNumerics.BigInt
        @_documentation(visibility: private)
        public typealias DoubleWord = KernelNumerics.BigInt.DoubleWord
        @_documentation(visibility: private)
        public typealias DoubleWords = KernelNumerics.BigInt.DoubleWords
        
        public static let smallPrimeProduct: KernelNumerics.BigInt = .init(smallPrimeInts.reduce(1, *))
        
        public static let smallPrimeDws: DoubleWords = [
            p1dw, p2dw, p3dw, p4dw, p5dw, p6dw,
            p7dw, p8dw, p9dw, p10dw, p11dw, p12dw
        ]
        
        public static let smallPrimeInts: [Int] = [
            p1i, p2i, p3i, p4i, p5i, p6i,
            p7i, p8i, p9i, p10i, p11i, p12i
        ]
        
        public static let rootPrimeInts: [Int] = [
            p0i, p1i, p2i, p3i, p4i, p5i, p6i, p7i, p8i, p9i
        ]
        
        public static let p0dw  : DoubleWord = 0x0000000000000002;  public static let p10dw : DoubleWord = 0x000000000000001f
        public static let p1dw  : DoubleWord = 0x0000000000000003;  public static let p11dw : DoubleWord = 0x0000000000000025
        public static let p2dw  : DoubleWord = 0x0000000000000005;  public static let p12dw : DoubleWord = 0x0000000000000029
        public static let p3dw  : DoubleWord = 0x0000000000000007;  public static let p13dw : DoubleWord = 0x000000000000002b
        public static let p4dw  : DoubleWord = 0x000000000000000b;  public static let p14dw : DoubleWord = 0x000000000000002f
        public static let p5dw  : DoubleWord = 0x000000000000000d;  public static let p15dw : DoubleWord = 0x0000000000000035
        public static let p6dw  : DoubleWord = 0x0000000000000011;  public static let p16dw : DoubleWord = 0x000000000000003b
        public static let p7dw  : DoubleWord = 0x0000000000000013;  public static let p17dw : DoubleWord = 0x000000000000003d
        public static let p8dw  : DoubleWord = 0x0000000000000017;  public static let p18dw : DoubleWord = 0x0000000000000043
        public static let p9dw  : DoubleWord = 0x000000000000001d;  public static let p19dw : DoubleWord = 0x0000000000000047
        
        public static let p0i  : Int = 0x0000000000000002;  public static let p10i : Int = 0x000000000000001f
        public static let p1i  : Int = 0x0000000000000003;  public static let p11i : Int = 0x0000000000000025
        public static let p2i  : Int = 0x0000000000000005;  public static let p12i : Int = 0x0000000000000029
        public static let p3i  : Int = 0x0000000000000007;  public static let p13i : Int = 0x000000000000002b
        public static let p4i  : Int = 0x000000000000000b;  public static let p14i : Int = 0x000000000000002f
        public static let p5i  : Int = 0x000000000000000d;  public static let p15i : Int = 0x0000000000000035
        public static let p6i  : Int = 0x0000000000000011;  public static let p16i : Int = 0x000000000000003b
        public static let p7i  : Int = 0x0000000000000013;  public static let p17i : Int = 0x000000000000003d
        public static let p8i  : Int = 0x0000000000000017;  public static let p18i : Int = 0x0000000000000043
        public static let p9i  : Int = 0x000000000000001d;  public static let p19i : Int = 0x0000000000000047
    }
}


extension KernelNumerics.BigInt {
    public enum Prime {
        @_documentation(visibility: private)
        public typealias BigInt = KernelNumerics.BigInt
        @_documentation(visibility: private)
        public typealias val = KernelNumerics.BigInt.ConstantValues.Prime
        
//        @inlinable @inline(__always)
        public static func isProbable(_ lhs: borrowing BigInt, _ p: Int = 30) throws -> Bool {
            precondition(p > .zero, "invalid probability")
            if lhs == .two { return true }
            if lhs.isEven || lhs < 2 { return false }
            var r: Int = switch lhs.bitWidth {
            case ..<100:        50
            case 100..<256:     27
            case 256..<512:     15
            case 512..<768:     8
            case 768..<1024:    4
            default:            2
            }
            r = min((p + 1) / 2, r)
            for _ in .zero..<r {
                try Task.checkCancellation()
                if !pass(lhs, BigInt.randomLessThan(lhs - 1) + 1) { return false }
            }
            return true
        }
        
//        @inlinable @inline(__always)
        public static func pass(_ lhs: borrowing BigInt, _ rhs: BigInt) -> Bool {
            let lm = lhs - 1, t = lm.trailingZeroBitCount, lt = lm >> t
            var e = rhs.expMod(lt, lhs)
            if e == 1 { return true }
            if t > .zero {
                for _ in .zero..<(t - 1) {
                    if e == lm { return true }
                    e = (e ** 2) % lhs
                }
            }
            return e == lm
        }
        
        
        
        public static func small(bitCount bc: Int) throws -> BigInt {
            let m = bc.and(0x7, equals: .zero), l = m ? (bc + 7) >> 3 + 1 : (bc + 7) >> 3
            let hiBit: UInt8 = .init(1 << ((bc + 7) & 0x7))
            let hiMask: UInt8 = .init((Int(hiBit) << 1) - 1)
            
            gen: while true {
                var b: [UInt8] = .generateSecRandom(count: l)
//                guard SecRandomCopyBytes(kSecRandomDefault, l, &b) == errSecSuccess else { preconditionFailure("sec random failed") }
                if m {
                    b[.zero] = .zero
                    b[1] = (b[1] & hiMask) | hiBit
                } 
                else { b[.zero] = (b[.zero] & hiMask) | hiBit }
                let res: BigInt = .init(signedBytes: b)
                if bc > 6 {
                    let r = res % val.smallPrimeProduct
                    sc: for p in val.smallPrimeInts { if r % p == .zero { continue gen } }
                }
                if try isProbable(res) { return res }
            }
        }
        
        public static func large(bitCount bc: Int, _ p: Int) throws -> BigInt {
            var b: BigInt = .init(bitWidth: bc)
            b.setBit(bc - 1)
            b.clearBit(.zero)
            var bs: BitSieve = .init(b, p)
            var c = try bs.retrieve()
            while c == nil || c!.bitWidth != bc {
                try Task.checkCancellation()
                b += .init(2 * bs.length)
                if b.bitWidth != bc {
                    b = .init(bitWidth: bc)
                    b.setBit(bc - 1)
                }
                b.clearBit(.zero)
                bs = .init(b, p)
                c = try bs.retrieve()
            }
            return c!
        }
        
        public static func next(_ lhs: borrowing BigInt, _ p: Int = 30) throws -> BigInt {
            if lhs < .two { return .two }
            var res = lhs + .one
            if res.bitWidth < 100 {
                if res.isEven { res += .one }
                gen: while true {
                    if res.bitWidth > 6 {
                        let r = res % val.smallPrimeProduct
                        sc: for p in val.smallPrimeInts {
                            if r % p == .zero {
                                res += .two
                                continue gen
                            }
                        }
                    }
                    if res.bitWidth < 4 { return res }
                    if try isProbable(res, p) { return res }
                    res += .two
                }
            }
            if res.isOdd { res -= .one }
            while true {
                let bs: BitSieve = .init(res, p)
                let c = try bs.retrieve()
                if c != nil { return c! }
                res += 2 * bs.length
            }
        }
        
        public static func probable(bitCount bc: Int, _ p: Int = 30) throws -> BigInt {
            precondition(bc > 1, "bit count is too small")

            return bc < 100 ? try small(bitCount: bc) : try large(bitCount: bc, p)
        }
        
        public static func probable(_ bc: Int, _ p: Int = 30, total: Int, concurrentCoreCount coreCount: Int = 10, retriesPerCore: Int = 3) async throws -> [BigInt] {
            switch total {
            case 1:
                let p0: KernelNumerics.BigInt = try await KernelNumerics.BigInt.Prime.probable(bc, p, concurrentCoreCount: coreCount, retriesPerCore: retriesPerCore)
                return [p0]
            case 2:
                let (p0, p1) = try await KernelNumerics.BigInt.Prime.probable(bc, p, concurrentCoreCount: coreCount, retriesPerCore: retriesPerCore)
                return [p0, p1]
            case 3:
                let (p0, p1, p2) = try await KernelNumerics.BigInt.Prime.probable(bc, p, concurrentCoreCount: coreCount, retriesPerCore: retriesPerCore)
                return [p0, p1, p2]
            case 4:
                let (p0, p1, p2, p3) = try await KernelNumerics.BigInt.Prime.probable(bc, p, concurrentCoreCount: coreCount, retriesPerCore: retriesPerCore)
                return [p0, p1, p2, p3]
            case 5:
                let (p0, p1, p2, p3, p4) = try await KernelNumerics.BigInt.Prime.probable(bc, p, concurrentCoreCount: coreCount, retriesPerCore: retriesPerCore)
                return [p0, p1, p2, p3, p4]
            case 6:
                let (p0, p1, p2, p3, p4, p5) = try await KernelNumerics.BigInt.Prime.probable(bc, p, concurrentCoreCount: coreCount, retriesPerCore: retriesPerCore)
                return [p0, p1, p2, p3, p4, p5]
            case 7:
                let (p0, p1, p2, p3, p4, p5, p6) = try await KernelNumerics.BigInt.Prime.probable(bc, p, concurrentCoreCount: coreCount, retriesPerCore: retriesPerCore)
                return [p0, p1, p2, p3, p4, p5, p6]
            case 8:
                let (p0, p1, p2, p3, p4, p5, p6, p7) = try await KernelNumerics.BigInt.Prime.probable(bc, p, concurrentCoreCount: coreCount, retriesPerCore: retriesPerCore)
                return [p0, p1, p2, p3, p4, p5, p6, p7]
            case 9:
                let (p0, p1, p2, p3, p4, p5, p6, p7, p8) = try await KernelNumerics.BigInt.Prime.probable(bc, p, concurrentCoreCount: coreCount, retriesPerCore: retriesPerCore)
                return [p0, p1, p2, p3, p4, p5, p6, p7, p8]
            case 10:
                let (p0, p1, p2, p3, p4, p5, p6, p7, p8, p9) = try await KernelNumerics.BigInt.Prime.probable(bc, p, concurrentCoreCount: coreCount, retriesPerCore: retriesPerCore)
                return [p0, p1, p2, p3, p4, p5, p6, p7, p8, p9]
            default: preconditionFailure("total primes should be between 1 and 10")
            }
        }
        
        public static func probable(_ bc: Int, _ p: Int = 30, concurrentCoreCount: Int = 10, total: Int = 10) async throws -> [BigInt] {
            var concurrentCoreCount = concurrentCoreCount
            guard concurrentCoreCount > .zero else { preconditionFailure("Concurrent Prime Generator requires at least one cpu core") }
            let availableCoreCount = ProcessInfo.processInfo.activeProcessorCount
            if concurrentCoreCount >= availableCoreCount {
                KernelNumerics.logger.warning("Concurrent Prime Generator cannot run on more cpu cores than available to the system. Automatically reconfiguring generator to use \(availableCoreCount - 1) cores.")
                concurrentCoreCount = availableCoreCount - 1
            }
            return try await withThrowingTaskGroup(of: (Int, BigInt).self, returning: Array<BigInt>.self) { group in
                do {
                    var primes: [BigInt] = []
//                    var retryCount: Int = .zero
//                    var currentTasks: Int = .zero
                    for ci in .zero..<concurrentCoreCount {
                        let _ = group.addTaskUnlessCancelled(priority: .high) { return try (ci, probable(bitCount: bc, p)) }
                    }
                    while primes.count < total {
                        guard let r1 = try await group.next() else {
                            KernelNumerics.logger.warning("using additional cycle")
                            let _ = group.addTaskUnlessCancelled(priority: .high) { return try (999, probable(bitCount: bc, p)) }
                            continue
                        }
                        primes.append(r1.1)
                        let _ = group.addTaskUnlessCancelled(priority: .high) { return try (r1.0, probable(bitCount: bc, p)) }
                    }
                    group.cancelAll()
                    return primes
                    
                } catch let error {
                    KernelNumerics.logger.error("PRIME GEN ERROR: \(error.localizedDescription)")
                    throw error
                }
            }
        }
        
        public static func probablePairs(_ bc: Int, _ p: Int = 50, concurrentCoreCount: Int = 10, total: Int = 10, keySizeTolerance: Int = 0) async throws -> [(BigInt, BigInt)] {
            var concurrentCoreCount = concurrentCoreCount
            guard concurrentCoreCount > .zero else { preconditionFailure("Concurrent Prime Generator requires at least one cpu core") }
            let availableCoreCount = ProcessInfo.processInfo.activeProcessorCount
            if concurrentCoreCount >= availableCoreCount {
                KernelNumerics.logger.warning("Concurrent Prime Generator cannot run on more cpu cores than available to the system. Automatically reconfiguring generator to use \(availableCoreCount - 1) cores.")
                concurrentCoreCount = availableCoreCount - 1
            }
            return try await withThrowingTaskGroup(of: BigInt.self, returning: [(BigInt, BigInt)].self) { group in
                do {
                    var primePairs: [(BigInt, BigInt)] = []
                    var unusedPrimes: Deque<BigInt> = []
                    for _ in .zero..<concurrentCoreCount {
                        let _ = group.addTaskUnlessCancelled(priority: .high) { return try probable(bitCount: bc, p) }
                    }
                    primeLoop: while primePairs.count < total {
                        if unusedPrimes.count > 3 {
                            let r1 = unusedPrimes[unusedPrimes.endIndex - 2], r2 = unusedPrimes[unusedPrimes.endIndex - 1]
                            for cr in .zero..<(unusedPrimes.endIndex - 2) {
                                let rc = unusedPrimes[cr]
                                let d1 = (bc * 2) - (r1 * rc).bitWidth
                                
                                if d1.magnitude <= keySizeTolerance {
                                    
                                    unusedPrimes.remove(at: cr)
                                    unusedPrimes.remove(at: unusedPrimes.endIndex - 2)
                                    primePairs.append((r1, rc))

                                    continue primeLoop
                                } else {
                                    let d2 = (bc * 2) - (r2 * rc).bitWidth
                                    if d2.magnitude <= keySizeTolerance {
                                        
                                        unusedPrimes.remove(at: cr)
                                        unusedPrimes.remove(at: unusedPrimes.endIndex - 1)
                                        primePairs.append((r2, rc))
                                        continue primeLoop
                                    }
                                }
                            }
                        }
                        guard let r1 = try await group.next() else {
                            let _ = group.addTaskUnlessCancelled(priority: .high) { return try probable(bitCount: bc, p) }
                            continue
                        }
                        let _ = group.addTaskUnlessCancelled(priority: .high) { return try probable(bitCount: bc, p) }
                        if let r2 = unusedPrimes.popFirst() {
                            let d = (bc * 2) - (r1 * r2).bitWidth
                            if d.magnitude <= keySizeTolerance {
                                primePairs.append((r1, r2))
                            } else {
                                unusedPrimes.append(r1)
                                unusedPrimes.append(r2)
                            }
                        } else {
                            guard let r2 = try await group.next() else {
//                                KernelNumerics.logger.warning("using additional cycle")
                                let _ = group.addTaskUnlessCancelled(priority: .high) { return try probable(bitCount: bc, p) }
                                continue
                            }
                            let d = (bc * 2) - (r1 * r2).bitWidth
                            if d.magnitude <= keySizeTolerance {
                                primePairs.append((r1, r2))
                            } else {
                                unusedPrimes.append(r1)
                                unusedPrimes.append(r2)
                            }
                            let _ = group.addTaskUnlessCancelled(priority: .high) { return try probable(bitCount: bc, p) }
                        }
                            
                        
                        
                    }
                    group.cancelAll()
                    return primePairs
                    
                } catch let error {
                    KernelNumerics.logger.error("PRIME GEN ERROR: \(error.localizedDescription)")
                    throw error
                }
            }
        }
        
        public static func probable(_ bc: Int, _ p: Int = 30, concurrentCoreCount: Int = 10, retriesPerCore: Int = 3) async throws -> BigInt {
            var concurrentCoreCount = concurrentCoreCount
            guard concurrentCoreCount > .zero else { preconditionFailure("Concurrent Prime Generator requires at least one cpu core") }
            let availableCoreCount = ProcessInfo.processInfo.activeProcessorCount
            if concurrentCoreCount >= availableCoreCount {
                KernelNumerics.logger.warning("Concurrent Prime Generator cannot run on more cpu cores than available to the system. Automatically reconfiguring generator to use \(availableCoreCount - 1) cores.")
                concurrentCoreCount = availableCoreCount - 1
            }
            return try await withThrowingTaskGroup(of: BigInt.self, returning: BigInt.self) { group in
                do {
                    var retryCount: Int = .zero
                    while retryCount < retriesPerCore {
                        for _ in .zero..<concurrentCoreCount {
                            let _ = group.addTaskUnlessCancelled {
                                return try probable(bitCount: bc, p)
                            }
                        }
                        guard let r1 = try await group.next() else {
                            retryCount += 1
                            KernelNumerics.logger.debug("using additional cycle \(retryCount)")
                            continue
                        }
                        group.cancelAll()
                        return r1
                    }
                    throw KernelNumerics.TypedError(.primeGenerationFailed)
                    
                } catch let error {
                    KernelNumerics.logger.error("\(error.localizedDescription)")
                    throw error
                }
            }
        }
        
        public static func probable(_ bc: Int, _ p: Int = 30, concurrentCoreCount: Int = 10, retriesPerCore: Int = 3) async throws -> (BigInt, BigInt) {
            var concurrentCoreCount = concurrentCoreCount
            guard concurrentCoreCount > 0 else { preconditionFailure("Concurrent Prime Generator requires at least one cpu core") }
            let availableCoreCount = ProcessInfo.processInfo.activeProcessorCount
            if concurrentCoreCount >= availableCoreCount {
                KernelNumerics.logger.warning("Concurrent Prime Generator cannot run on more cpu cores than available to the system. Automatically reconfiguring generator to use \(availableCoreCount - 1) cores.")
                concurrentCoreCount = availableCoreCount - 1
            }
            return try await withThrowingTaskGroup(of: BigInt.self, returning: (BigInt, BigInt).self) { group in
                do {
                    var retryCount: Int = 0
                    while retryCount < retriesPerCore {
                        for _ in 0..<concurrentCoreCount {
                            let _ = group.addTaskUnlessCancelled {
                                return try probable(bitCount: bc, p)
                            }
                        }
                        guard let r1 = try await group.next(), let r2 = try await group.next() else {
                            retryCount += 1
                            KernelNumerics.logger.debug("using additional cycle \(retryCount)")
                            continue
                        }
                        group.cancelAll()
                        return (r1, r2)
                    }
                    throw KernelNumerics.TypedError(.primeGenerationFailed)
                    
                } catch let error {
                    KernelNumerics.logger.error("\(error.localizedDescription)")
                    throw error
                }
            }
        }
        
        public static func probable(
            _ bc: Int,
            _ p: Int = 30,
            concurrentCoreCount: Int = 10,
            retriesPerCore: Int = 3
        ) async throws -> (BigInt, BigInt, BigInt) {
            var concurrentCoreCount = concurrentCoreCount
            guard concurrentCoreCount > 0 else { preconditionFailure("Concurrent Prime Generator requires at least one cpu core") }
            let availableCoreCount = ProcessInfo.processInfo.activeProcessorCount
            if concurrentCoreCount >= availableCoreCount {
                KernelNumerics.logger.warning("Concurrent Prime Generator cannot run on more cpu cores than available to the system. Automatically reconfiguring generator to use \(availableCoreCount - 1) cores.")
                concurrentCoreCount = availableCoreCount - 1
            }
            return try await withThrowingTaskGroup(of: BigInt.self, returning: (BigInt, BigInt, BigInt).self) { group in
                do {
                    var retryCount: Int = 0
                    while retryCount < retriesPerCore {
                        for _ in 0..<concurrentCoreCount {
                            let _ = group.addTaskUnlessCancelled {
                                return try probable(bitCount: bc, p)
                            }
                        }
                        guard
                            let r1 = try await group.next(),
                            let r2 = try await group.next(),
                            let r3 = try await group.next()
                        else {
                            retryCount += 1
                            KernelNumerics.logger.debug("using additional cycle \(retryCount)")
                            continue
                        }
                        group.cancelAll()
                        return (r1, r2, r3)
                    }
                    throw KernelNumerics.TypedError(.primeGenerationFailed)
                    
                } catch let error {
                    KernelNumerics.logger.error("\(error.localizedDescription)")
                    throw error
                }
            }
        }
        
        public static func probable(
            _ bc: Int,
            _ p: Int = 30,
            concurrentCoreCount: Int = 10,
            retriesPerCore: Int = 3
        ) async throws -> (BigInt, BigInt, BigInt, BigInt) {
            var concurrentCoreCount = concurrentCoreCount
            guard concurrentCoreCount > 0 else { preconditionFailure("Concurrent Prime Generator requires at least one cpu core") }
            let availableCoreCount = ProcessInfo.processInfo.activeProcessorCount
            if concurrentCoreCount >= availableCoreCount {
                KernelNumerics.logger.warning("Concurrent Prime Generator cannot run on more cpu cores than available to the system. Automatically reconfiguring generator to use \(availableCoreCount - 1) cores.")
                concurrentCoreCount = availableCoreCount - 1
            }
            return try await withThrowingTaskGroup(of: BigInt.self, returning: (BigInt, BigInt, BigInt, BigInt).self) { group in
                do {
                    var retryCount: Int = 0
                    while retryCount < retriesPerCore {
                        for _ in 0..<concurrentCoreCount {
                            let _ = group.addTaskUnlessCancelled {
                                return try probable(bitCount: bc, p)
                            }
                        }
                        guard
                            let r1 = try await group.next(),
                            let r2 = try await group.next(),
                            let r3 = try await group.next(),
                            let r4 = try await group.next()
                        else {
                            retryCount += 1
                            KernelNumerics.logger.debug("using additional cycle \(retryCount)")
                            continue
                        }
                        group.cancelAll()
                        return (r1, r2, r3, r4)
                    }
                    throw KernelNumerics.TypedError(.primeGenerationFailed)
                    
                } catch let error {
                    KernelNumerics.logger.error("\(error.localizedDescription)")
                    throw error
                }
            }
        }
        
        public static func probable(
            _ bc: Int,
            _ p: Int = 30,
            concurrentCoreCount: Int = 10,
            retriesPerCore: Int = 3
        ) async throws -> (BigInt, BigInt, BigInt, BigInt, BigInt) {
            var concurrentCoreCount = concurrentCoreCount
            guard concurrentCoreCount > 0 else { preconditionFailure("Concurrent Prime Generator requires at least one cpu core") }
            let availableCoreCount = ProcessInfo.processInfo.activeProcessorCount
            if concurrentCoreCount >= availableCoreCount {
                KernelNumerics.logger.warning("Concurrent Prime Generator cannot run on more cpu cores than available to the system. Automatically reconfiguring generator to use \(availableCoreCount - 1) cores.")
                concurrentCoreCount = availableCoreCount - 1
            }
            return try await withThrowingTaskGroup(of: BigInt.self, returning: (BigInt, BigInt, BigInt, BigInt, BigInt).self) { group in
                do {
                    var retryCount: Int = 0
                    while retryCount < retriesPerCore {
                        for _ in 0..<concurrentCoreCount {
                            let _ = group.addTaskUnlessCancelled {
                                return try probable(bitCount: bc, p)
                            }
                        }
                        guard
                            let r1 = try await group.next(),
                            let r2 = try await group.next(),
                            let r3 = try await group.next(),
                            let r4 = try await group.next(),
                            let r5 = try await group.next()
                        else {
                            retryCount += 1
                            KernelNumerics.logger.debug("using additional cycle \(retryCount)")
                            continue
                        }
                        group.cancelAll()
                        return (r1, r2, r3, r4, r5)
                    }
                    throw KernelNumerics.TypedError(.primeGenerationFailed)
                    
                } catch let error {
                    KernelNumerics.logger.error("\(error.localizedDescription)")
                    throw error
                }
            }
        }
        
        public static func probable(
            _ bc: Int,
            _ p: Int = 30,
            concurrentCoreCount: Int = 10,
            retriesPerCore: Int = 3
        ) async throws -> (BigInt, BigInt, BigInt, BigInt, BigInt, BigInt) {
            var concurrentCoreCount = concurrentCoreCount
            guard concurrentCoreCount > 0 else { preconditionFailure("Concurrent Prime Generator requires at least one cpu core") }
            let availableCoreCount = ProcessInfo.processInfo.activeProcessorCount
            if concurrentCoreCount >= availableCoreCount {
                KernelNumerics.logger.warning("Concurrent Prime Generator cannot run on more cpu cores than available to the system. Automatically reconfiguring generator to use \(availableCoreCount - 1) cores.")
                concurrentCoreCount = availableCoreCount - 1
            }
            return try await withThrowingTaskGroup(of: BigInt.self, returning: (BigInt, BigInt, BigInt, BigInt, BigInt, BigInt).self) { group in
                do {
                    var retryCount: Int = 0
                    while retryCount < retriesPerCore {
                        for _ in 0..<concurrentCoreCount {
                            let _ = group.addTaskUnlessCancelled {
                                return try probable(bitCount: bc, p)
                            }
                        }
                        guard
                            let r1 = try await group.next(),
                            let r2 = try await group.next(),
                            let r3 = try await group.next(),
                            let r4 = try await group.next(),
                            let r5 = try await group.next(),
                            let r6 = try await group.next()
                        else {
                            retryCount += 1
                            KernelNumerics.logger.debug("using additional cycle \(retryCount)")
                            continue
                        }
                        group.cancelAll()
                        return (r1, r2, r3, r4, r5, r6)
                    }
                    throw KernelNumerics.TypedError(.primeGenerationFailed)
                    
                } catch let error {
                    KernelNumerics.logger.error("\(error.localizedDescription)")
                    throw error
                }
            }
        }
        
        public static func probable(
            _ bc: Int,
            _ p: Int = 30,
            concurrentCoreCount: Int = 10,
            retriesPerCore: Int = 3
        ) async throws -> (BigInt, BigInt, BigInt, BigInt, BigInt, BigInt, BigInt) {
            var concurrentCoreCount = concurrentCoreCount
            guard concurrentCoreCount > 0 else { preconditionFailure("Concurrent Prime Generator requires at least one cpu core") }
            let availableCoreCount = ProcessInfo.processInfo.activeProcessorCount
            if concurrentCoreCount >= availableCoreCount {
                KernelNumerics.logger.warning("Concurrent Prime Generator cannot run on more cpu cores than available to the system. Automatically reconfiguring generator to use \(availableCoreCount - 1) cores.")
                concurrentCoreCount = availableCoreCount - 1
            }
            return try await withThrowingTaskGroup(of: BigInt.self, returning: (BigInt, BigInt, BigInt, BigInt, BigInt, BigInt, BigInt).self) { group in
                do {
                    var retryCount: Int = 0
                    while retryCount < retriesPerCore {
                        for _ in 0..<concurrentCoreCount {
                            let _ = group.addTaskUnlessCancelled {
                                return try probable(bitCount: bc, p)
                            }
                        }
                        guard
                            let r1 = try await group.next(),
                            let r2 = try await group.next(),
                            let r3 = try await group.next(),
                            let r4 = try await group.next(),
                            let r5 = try await group.next(),
                            let r6 = try await group.next(),
                            let r7 = try await group.next()
                        else {
                            retryCount += 1
                            KernelNumerics.logger.debug("using additional cycle \(retryCount)")
                            continue
                        }
                        group.cancelAll()
                        return (r1, r2, r3, r4, r5, r6, r7)
                    }
                    throw KernelNumerics.TypedError(.primeGenerationFailed)
                    
                } catch let error {
                    KernelNumerics.logger.error("\(error.localizedDescription)")
                    throw error
                }
            }
        }
        
        public static func probable(
            _ bc: Int,
            _ p: Int = 30,
            concurrentCoreCount: Int = 10,
            retriesPerCore: Int = 3
        ) async throws -> (BigInt, BigInt, BigInt, BigInt, BigInt, BigInt, BigInt, BigInt) {
            var concurrentCoreCount = concurrentCoreCount
            guard concurrentCoreCount > 0 else { preconditionFailure("Concurrent Prime Generator requires at least one cpu core") }
            let availableCoreCount = ProcessInfo.processInfo.activeProcessorCount
            if concurrentCoreCount >= availableCoreCount {
                KernelNumerics.logger.warning("Concurrent Prime Generator cannot run on more cpu cores than available to the system. Automatically reconfiguring generator to use \(availableCoreCount - 1) cores.")
                concurrentCoreCount = availableCoreCount - 1
            }
            return try await withThrowingTaskGroup(of: BigInt.self, returning: (BigInt, BigInt, BigInt, BigInt, BigInt, BigInt, BigInt, BigInt).self) { group in
                do {
                    var retryCount: Int = 0
                    while retryCount < retriesPerCore {
                        for _ in 0..<concurrentCoreCount {
                            let _ = group.addTaskUnlessCancelled {
                                return try probable(bitCount: bc, p)
                            }
                        }
                        guard
                            let r1 = try await group.next(),
                            let r2 = try await group.next(),
                            let r3 = try await group.next(),
                            let r4 = try await group.next(),
                            let r5 = try await group.next(),
                            let r6 = try await group.next(),
                            let r7 = try await group.next(),
                            let r8 = try await group.next()
                        else {
                            retryCount += 1
                            KernelNumerics.logger.debug("using additional cycle \(retryCount)")
                            continue
                        }
                        group.cancelAll()
                        return (r1, r2, r3, r4, r5, r6, r7, r8)
                    }
                    throw KernelNumerics.TypedError(.primeGenerationFailed)
                    
                } catch let error {
                    KernelNumerics.logger.error("\(error.localizedDescription)")
                    throw error
                }
            }
        }
        
        public static func probable(
            _ bc: Int,
            _ p: Int = 30,
            concurrentCoreCount: Int = 10,
            retriesPerCore: Int = 3
        ) async throws -> (BigInt, BigInt, BigInt, BigInt, BigInt, BigInt, BigInt, BigInt, BigInt) {
            var concurrentCoreCount = concurrentCoreCount
            guard concurrentCoreCount > 0 else { preconditionFailure("Concurrent Prime Generator requires at least one cpu core") }
            let availableCoreCount = ProcessInfo.processInfo.activeProcessorCount
            if concurrentCoreCount >= availableCoreCount {
                KernelNumerics.logger.warning("Concurrent Prime Generator cannot run on more cpu cores than available to the system. Automatically reconfiguring generator to use \(availableCoreCount - 1) cores.")
                concurrentCoreCount = availableCoreCount - 1
            }
            return try await withThrowingTaskGroup(of: BigInt.self, returning: (BigInt, BigInt, BigInt, BigInt, BigInt, BigInt, BigInt, BigInt, BigInt).self) { group in
                do {
                    var retryCount: Int = 0
                    while retryCount < retriesPerCore {
                        for _ in 0..<concurrentCoreCount {
                            let _ = group.addTaskUnlessCancelled {
                                return try probable(bitCount: bc, p)
                            }
                        }
                        guard
                            let r1 = try await group.next(),
                            let r2 = try await group.next(),
                            let r3 = try await group.next(),
                            let r4 = try await group.next(),
                            let r5 = try await group.next(),
                            let r6 = try await group.next(),
                            let r7 = try await group.next(),
                            let r8 = try await group.next(),
                            let r9 = try await group.next()
                        else {
                            retryCount += 1
                            KernelNumerics.logger.debug("using additional cycle \(retryCount)")
                            continue
                        }
                        group.cancelAll()
                        return (r1, r2, r3, r4, r5, r6, r7, r8, r9)
                    }
                    throw KernelNumerics.TypedError(.primeGenerationFailed)
                    
                } catch let error {
                    KernelNumerics.logger.error("\(error.localizedDescription)")
                    throw error
                }
            }
        }
        
        public static func probable(
            _ bc: Int,
            _ p: Int = 30,
            concurrentCoreCount: Int = 10,
            retriesPerCore: Int = 3
        ) async throws -> (BigInt, BigInt, BigInt, BigInt, BigInt, BigInt, BigInt, BigInt, BigInt, BigInt) {
            var concurrentCoreCount = concurrentCoreCount
            guard concurrentCoreCount > 0 else { preconditionFailure("Concurrent Prime Generator requires at least one cpu core") }
            let availableCoreCount = ProcessInfo.processInfo.activeProcessorCount
            if concurrentCoreCount >= availableCoreCount {
                KernelNumerics.logger.warning("Concurrent Prime Generator cannot run on more cpu cores than available to the system. Automatically reconfiguring generator to use \(availableCoreCount - 1) cores.")
                concurrentCoreCount = availableCoreCount - 1
            }
            return try await withThrowingTaskGroup(of: BigInt.self, returning: (BigInt, BigInt, BigInt, BigInt, BigInt, BigInt, BigInt, BigInt, BigInt, BigInt).self) { group in
                do {
                    var retryCount: Int = 0
                    while retryCount < retriesPerCore {
                        for _ in 0..<concurrentCoreCount {
                            let _ = group.addTaskUnlessCancelled {
                                return try probable(bitCount: bc, p)
                            }
                        }
                        guard
                            let r1 = try await group.next(),
                            let r2 = try await group.next(),
                            let r3 = try await group.next(),
                            let r4 = try await group.next(),
                            let r5 = try await group.next(),
                            let r6 = try await group.next(),
                            let r7 = try await group.next(),
                            let r8 = try await group.next(),
                            let r9 = try await group.next(),
                            let r10 = try await group.next()
                        else {
                            retryCount += 1
                            KernelNumerics.logger.debug("using additional cycle \(retryCount)")
                            continue
                        }
                        group.cancelAll()
                        return (r1, r2, r3, r4, r5, r6, r7, r8, r9, r10)
                    }
                    throw KernelNumerics.TypedError(.primeGenerationFailed)
                    
                } catch let error {
                    KernelNumerics.logger.error("\(error.localizedDescription)")
                    throw error
                }
            }
        }
        
        public static func primorial(_ n: Int) -> BigInt {
            precondition(n >= .zero, "negative primorial")
            var p: BigInt = .one
            if n > .zero {
                var bs: [Bool] = .init(repeating: true, count: n + 1), idx = 2
                bs[.zero] = false; bs[1] = false
                while idx < bs.count {
                    if bs[idx] {
                        for i in stride(from: idx + idx, to: bs.count, by: idx) { bs[i] = false }
                    }
                    idx += 1
                }
                for i in .zero...n {
                    if bs[i] { p *= i }
                }
            }
            return p
        }
    }
}

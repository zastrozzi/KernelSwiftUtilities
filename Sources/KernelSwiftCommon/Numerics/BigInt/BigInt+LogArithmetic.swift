//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 18/10/2023.
//

import Foundation

extension KernelNumerics.BigInt {
    public func root(_ n: Int) -> Self {
        precondition(!isNegative || n.andEquals(1), "cannot root negative number")
        precondition(n > .zero, "n must be positive")
        if isZero { return .zero }
        let a = abs, b: Self = .one, bm = b - 1
        var s: Self = .one << (a.bitWidth / n + 1)
        while true {
            let se = s ** (n - 1), sf = (a / se + s * bm) / b
            if sf >= s { return isNegative ? -s : s }
            s = sf
        }
    }
    
    public func rootRemainder(_ n: Int) -> (rt: Self, rm: Self) {
        let rn = root(n)
        return (rt: rn, rm: self - rn ** n)
    }
    
    public func sqrtRemainder() -> (rt: Self, rm: Self) {
        precondition(!isNegative, "cannot root negative number")
        let l = (count - 1) >> 2
        if l == .zero {
            let sq = quickSqrt()
            return (sq, self - sq ** 2)
        }
        let sh = l * 64, l0 = Int.zero, l1 = l, l2 = 2 * l, l3 = 3 * l, l4 = count
        let a0: Self = .init(.init(storage[l0..<l1]))
        let a1: Self = .init(.init(storage[l1..<l2]))
        let a2: Self = .init(.init(storage[l2..<l3]))
        let a3: Self = .init(.init(storage[l3..<l4]))
        let (s0, r0) = (a3 << sh + a2).sqrtRemainder()
        let (q, u) = (r0 << sh + a1).quotientAndRemainder(dividingBy: s0 << 1)
        var s = s0 << sh + q, r = u << sh + a0 - q ** 2
        if r.isNegative {
            r += 2 * s - 1
            s -= 1
        }
        return (s, r)
    }
    
    public func isPerfectRoot() -> Bool {
        if abs < .two { return true }
        for p in val.prime.rootPrimeInts {
            if mod(p) == .zero && mod(p * p) > .zero { return false }
        }
        if isPerfectSquare() { return true }
        if rootRemainder(3).rm.isZero { return true }
        if rootRemainder(5).rm.isZero { return true }
        let w = util.rootWheel
        var wi = Int.zero, n = 7
        while n < bitWidth {
            if rootRemainder(n).rm.isZero { return true }
            n += w[wi]
            wi = (wi + 1) % w.count
        }
        return false
    }
    
    public func isPerfectSquare() -> Bool {
        if isNegative { return false }
        return util.squareMap[.init(storage[.zero] & 0xff)] ? sqrtRemainder().rm.isZero : false
    }
    
    public func sqrt() -> Self { sqrtRemainder().rt }
    
    public func quickSqrt() -> Self {
        if isZero { return .zero }
        var s0 = .one << (bitWidth / 2 + 1)
        while true {
            let s1 = (self / s0 + s0) >> 1
            if s1 >= s0 { return s0 }
            s0 = s1
        }
    }
    
    public func sqrtMod(_ p: Self) -> Self? {
        if Symbol.jacobi(self, p) != 1 { return nil }
        let A = self % p
        switch p.mod(8) {
        case 3, 7: return A.expMod((p + 1) >> 2, p)
            
        case 5:
            var x = A.expMod((p + 3) >> 3, p)
            if (x ** 2) % p != A % p { x = x * .two.expMod((p - 1) >> 2, p) % p }
            return x
            
        case 1:
            let pm1 = p - 1
            var d: Self = .zero
            let pm3 = p - 3
            while true {
                d = Self.randomLessThan(pm3) + 2
                if Symbol.jacobi(d, p) == -1 { break }
            }
            var s = Int.zero, t = pm1
            while t.isEven {
                s += 1
                t >>= 1
            }
            let A1 = A.expMod(t, p)
            let D = d.expMod(t, p)
            var m: Self = .zero, exp = .one << (s - 1)
            for i in .zero..<s {
                if ((D.expMod(m * exp, p) * A1.expMod(exp, p))).mod(p) == pm1 { m.setBit(i) }
                exp >>= 1
            }
            return (A.expMod((t + 1) >> 1, p) * D.expMod(m >> 1, p)) % p
        default: return nil
        }
    }
    
    public static func sqrtMod(_ s: borrowing Self, _ p: Int) -> Int? {
        if Symbol.jacobi(s, p) != 1 { return nil }
        let A = (s % p).toInt()!
        switch p % 8 {
        case 3, 7: return quickExpMod(A, (p + 1) >> 2, p)
            
        case 5:
            var x = quickExpMod(A, (p + 3) >> 3, p)
            if mulMod(x, x, p) != A % p { x = mulMod(x, quickExpMod(2, (p - 1) >> 2, p), p) }
            return x
            
        case 1:
            let pm1 = p - 1
            var d = Int.zero
            while true {
                d = Int.random(in: 2...(p - 3))
                if Symbol.jacobi(.init(d), p) == -1 { break }
            }
            var s = Int.zero, t = pm1
            while t.and(1, equals: .zero) {
                s += 1
                t >>= 1
            }
            let A1 = quickExpMod(A, t, p), D = quickExpMod(d, t, p)
            var m = Int.zero, exp = 1 << (s - 1), mask = 1
            for _ in .zero..<s {
                let Dx = quickExpMod(D, m * exp, p), Ax = quickExpMod(A1, exp, p)
                if mulMod(Dx, Ax, p) == pm1 { m |= mask }
                mask <<= 1
                exp >>= 1
            }
            return mulMod(quickExpMod(A, (t + 1) >> 1, p), quickExpMod(D, m >> 1, p), p)
            
        default: return nil
        }
    }

}

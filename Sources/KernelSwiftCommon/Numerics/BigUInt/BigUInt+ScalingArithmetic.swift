//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/06/2023.
//

precedencegroup ExponentiationPrecedence {
    associativity: left
    higherThan: MultiplicationPrecedence
    lowerThan: BitwiseShiftPrecedence
}

infix operator ** : ExponentiationPrecedence

extension KernelNumerics.BigUInt {
    public static let directMultiplicationLimit: Int = 1024
    
//    @inlinable
    public static func *=(a: inout KernelNumerics.BigUInt, b: KernelNumerics.BigUInt) { a = a * b }
    
//    @inlinable
    public static func *(x: KernelNumerics.BigUInt, y: KernelNumerics.BigUInt) -> KernelNumerics.BigUInt {
        let xc = x.count
        let yc = y.count
        if xc == 0 { return KernelNumerics.BigUInt() }
        if yc == 0 { return KernelNumerics.BigUInt() }
        if yc == 1 { return x.multiplied(byWord: y[0]) }
        if xc == 1 { return y.multiplied(byWord: x[0]) }

        if Swift.min(xc, yc) <= directMultiplicationLimit {
            // Long multiplication.
            let left = (xc < yc ? y : x)
            let right = (xc < yc ? x : y)
            var result = KernelNumerics.BigUInt()
            for i in (0 ..< right.count).reversed() {
                result.multiplyAndAdd(left, right[i], shiftedBy: i)
            }
            return result
        }

        if yc < xc {
            let (xh, xl) = x.split
            var r = xl * y
            r.add(xh * y, shiftedBy: x.middleIndex)
            return r
        }
        else if xc < yc {
            let (yh, yl) = y.split
            var r = yl * x
            r.add(yh * x, shiftedBy: y.middleIndex)
            return r
        }

        let shift = x.middleIndex

        let (a, b) = x.split
        let (c, d) = y.split

        let high = a * c
        let low = b * d
        let xp = a >= b
        let yp = c >= d
        let xm = (xp ? a - b : b - a)
        let ym = (yp ? c - d : d - c)
        let m = xm * ym

        var r = low
        r.add(high, shiftedBy: 2 * shift)
        r.add(low, shiftedBy: shift)
        r.add(high, shiftedBy: shift)
        if xp == yp {
            r.subtract(m, shiftedBy: shift)
        }
        else {
            r.add(m, shiftedBy: shift)
        }
        return r
    }
    
    @inlinable
    public func squareRoot() -> KernelNumerics.BigUInt {
        guard !self.isZero else { return KernelNumerics.BigUInt() }
        var x = KernelNumerics.BigUInt(1) << ((self.bitWidth + 1) / 2)
        var y: KernelNumerics.BigUInt = 0
        while true {
            y.load(self)
            y /= x
            y += x
            y >>= 1
            if x == y || x == y - 1 { break }
            x = y
        }
        return x
    }
    
    @inlinable
    public func greatestCommonDivisor(with b: KernelNumerics.BigUInt) -> KernelNumerics.BigUInt {
        if self.isZero { return b }
        if b.isZero { return self }

        let az = self.trailingZeroBitCount
        let bz = b.trailingZeroBitCount
        let twos = Swift.min(az, bz)

        var (x, y) = (self >> az, b >> bz)
        if x < y { swap(&x, &y) }

        while !x.isZero {
            x >>= x.trailingZeroBitCount
            if x < y { swap(&x, &y) }
            x -= y
        }
        return y << twos
    }
    
    @inlinable
    public func inverse(modulus: KernelNumerics.BigUInt) -> KernelNumerics.BigUInt? {
        precondition(modulus > 1)
        var t1 = KernelNumerics._BigInt(0)
        var t2 = KernelNumerics._BigInt(1)
        var r1 = modulus
        var r2 = self
        while !r2.isZero {
            let quotient = r1 / r2
            (t1, t2) = (t2, t1 - KernelNumerics._BigInt(quotient) * t2)
            (r1, r2) = (r2, r1 - quotient * r2)
        }
        if r1 > 1 { return nil }
        if t1.signum() < 0 { return modulus - t1.magnitude }
        return .init(t1.magnitude)
    }
    
    @inlinable
    public func inverseNoOpt(modulus: KernelNumerics.BigUInt) -> KernelNumerics.BigUInt {
//        precondition(modulus > 1)
        var t1 = KernelNumerics._BigInt(0)
        var t2 = KernelNumerics._BigInt(1)
        var r1 = modulus
        var r2 = self
        while !r2.isZero {
            let quotient = r1 / r2
            (t1, t2) = (t2, t1 - KernelNumerics._BigInt(quotient) * t2)
            (r1, r2) = (r2, r1 - quotient * r2)
        }
//        if r1 > 1 { preconditionFailure() }
        if t1.sign == .minus { return modulus - t1.magnitude }
//        print("not minus")
        return t1.magnitude
    }
    
    @inlinable
    public func power(_ exponent: Int) -> KernelNumerics.BigUInt {
        if exponent == 0 { return 1 }
        if exponent == 1 { return self }
        if exponent < 0 {
            precondition(!self.isZero)
            return self == 1 ? 1 : 0
        }
        if self <= 1 { return self }
        var result = KernelNumerics.BigUInt(1)
        var b = self
        var e = exponent
        while e > 0 {
            if e.andEquals(0x01) {
                result *= b
            }
            e >>= 1
            b *= b
        }
        return result
    }
    
    @inline(__always)
    public static func multiplyMod(_ v: KernelNumerics.BigUInt, by: KernelNumerics.BigUInt, mod: KernelNumerics.BigUInt) -> KernelNumerics.BigUInt {
        var res: KernelNumerics.BigUInt = 0
        var v = v
        var by = by
        while v != 0 {
            if (v & 1) != 0 { res = (res + by) % mod }
            v >>= 1
            by = (by << 1) % mod
        }
        return res
    }
    
    @inline(__always)
    public static func powerMod(_ v: KernelNumerics.BigUInt, exp: KernelNumerics.BigUInt, mod: KernelNumerics.BigUInt) -> KernelNumerics.BigUInt {
        var res: KernelNumerics.BigUInt = 1
        var v = v
        var exp = exp
        v %= mod
        while exp > 0 {
            if exp % 2 == 1 { res = multiplyMod(res, by: v, mod: mod) }
            v = multiplyMod(v, by: v, mod: mod)
            exp >>= 1
        }
        return res % mod
    }
    
    @inline(__always)
    public static func power(for base: KernelNumerics.BigUInt, _ exponent: KernelNumerics.BigUInt, modulus: KernelNumerics.BigUInt) -> KernelNumerics.BigUInt {
//        precondition(!modulus.isZero)
        if modulus == 1 { return 0 }
        let shift = modulus.leadingZeroBitCount
        let normalizedModulus = modulus << shift
        var result = KernelNumerics.BigUInt(1)
        var b = base
        formRemainder(for: &b, dividingBy: normalizedModulus, normalizedBy: shift)
        for var e in exponent.words {
            for _ in 0 ..< Word.bitWidth {
                if e & 1 == 1 {
                    result *= b
                    formRemainder(for: &result, dividingBy: normalizedModulus, normalizedBy: shift)
                }
                e >>= 1
                b *= b
                formRemainder(for: &b, dividingBy: normalizedModulus, normalizedBy: shift)
            }
        }
        return result
    }

    @inline(__always)
    public func power(_ exponent: KernelNumerics.BigUInt, modulus: KernelNumerics.BigUInt) -> KernelNumerics.BigUInt {
        precondition(!modulus.isZero)
        if modulus == 1 { return 0 }
        let shift = modulus.leadingZeroBitCount
        let normalizedModulus = modulus << shift
        var result = KernelNumerics.BigUInt(1)
        var b = self
        b.formRemainder(dividingBy: normalizedModulus, normalizedBy: shift)
        for var e in exponent.words {
            for _ in 0 ..< Word.bitWidth {
                if e & 1 == 1 {
                    result *= b
                    result.formRemainder(dividingBy: normalizedModulus, normalizedBy: shift)
                }
                e >>= 1
                b *= b
                b.formRemainder(dividingBy: normalizedModulus, normalizedBy: shift)
            }
        }
        return result
    }
    
    @inline(__always)
    public mutating func multiply(byWord y: Word) {
        guard y != 0 else { self = 0; return }
        guard y != 1 else { return }
        var carry: Word = 0
        let c = self.count
        for i in 0 ..< c {
            let (h, l) = self[i].multipliedFullWidth(by: y)
            let (low, o) = l.addingReportingOverflow(carry)
            self[i] = low
            carry = (o ? h + 1 : h)
        }
        self[c] = carry
    }

    @inlinable
    public func multiplied(byWord y: Word) -> KernelNumerics.BigUInt {
        var r = self
        r.multiply(byWord: y)
        return r
    }

    @inlinable
    public mutating func multiplyAndAdd(_ x: KernelNumerics.BigUInt, _ y: Word, shiftedBy shift: Int = 0) {
        precondition(shift >= 0)
        guard y != 0 && x.count > 0 else { return }
        guard y != 1 else { self.add(x, shiftedBy: shift); return }
        var mulCarry: Word = 0
        var addCarry = false
        let xc = x.count
        var xi = 0
        while xi < xc || addCarry || mulCarry > 0 {
            let (h, l) = x[xi].multipliedFullWidth(by: y)
            let (low, o) = l.addingReportingOverflow(mulCarry)
            mulCarry = (o ? h + 1 : h)

            let ai = shift + xi
            let (sum1, so1) = self[ai].addingReportingOverflow(low)
            if addCarry {
                let (sum2, so2) = sum1.addingReportingOverflow(1)
                self[ai] = sum2
                addCarry = so1 || so2
            }
            else {
                self[ai] = sum1
                addCarry = so1
            }
            xi += 1
        }
    }

    @inlinable
    public func multiplied(by y: KernelNumerics.BigUInt) -> KernelNumerics.BigUInt {
        return self * y
    }

    @inlinable
    mutating func divide(byWord y: Word) -> Word {
        precondition(y > 0)
        if y == 1 { return 0 }
        
        var remainder: Word = 0
        for i in (0 ..< count).reversed() {
            let u = self[i]
            (self[i], remainder) = y.fastDividingFullWidth((remainder, u))
        }
        return remainder
    }
    
    @inlinable
    static func divide(_ x: KernelNumerics.BigUInt, byWord y: Word) -> Word {
        precondition(y > 0)
        if y == 1 { return 0 }
        var x = x
        var remainder: Word = 0
        for i in (0 ..< x.count).reversed() {
            let u = x[i]
            (x[i], remainder) = Word.fastDividingFullWidth(y, dividend: (remainder, u))
        }
        return remainder
    }

    @inlinable
    public func quotientAndRemainder(dividingByWord y: Word) -> (quotient:  KernelNumerics.BigUInt, remainder: Word) {
        var div = self
        let mod = div.divide(byWord: y)
        return (div, mod)
    }

    @inlinable
    static func divide(_ x: inout  KernelNumerics.BigUInt, by y: inout  KernelNumerics.BigUInt) {
        precondition(!y.isZero)
        if x < y {
            (x, y) = (0, x)
            return
        }
        if y.count == 1 {
            y = KernelNumerics.BigUInt(x.divide(byWord: y[0]))
            return
        }

        let z = y.leadingZeroBitCount
        y <<= z
        x <<= z
        var quotient = KernelNumerics.BigUInt()
        assert(y.leadingZeroBitCount == 0)

        let dc = y.count
        let d1 = y[dc - 1]
        let d0 = y[dc - 2]
        var product: KernelNumerics.BigUInt = 0
        for j in (dc ... x.count).reversed() {
            let r2 = x[j]
            let r1 = x[j - 1]
            let r0 = x[j - 2]
            let q = Word.approximateQuotient(dividing: (r2, r1, r0), by: (d1, d0))

            product.load(y)
            product.multiply(byWord: q)
            if product <= x.extract(j - dc ..< j + 1) {
                x.subtract(product, shiftedBy: j - dc)
                quotient[j - dc] = q
            }
            else {
                x.add(y, shiftedBy: j - dc)
                x.subtract(product, shiftedBy: j - dc)
                quotient[j - dc] = q - 1
            }
        }
        x >>= z
        y = x
        x = quotient
    }
    
    @inline(__always)
    public static func formRemainder(for x: inout KernelNumerics.BigUInt, dividingBy y: KernelNumerics.BigUInt, normalizedBy shift: Int) {
//        precondition(!y.isZero)
//        assert(y.leadingZeroBitCount == 0)
        if y.count == 1 {
            let remainder = divide(x, byWord: y[0] >> shift)
            x.load(KernelNumerics.BigUInt(remainder))
            return
        }
        x <<= shift
        if x >= y {
            let dc = y.count
            let d1 = y[dc - 1]
            let d0 = y[dc - 2]
            var product: KernelNumerics.BigUInt = 0
            for j in (dc ... x.count).reversed() {
                let r2 = x[j]
                let r1 = x[j - 1]
                let r0 = x[j - 2]
                let q = Word.approximateQuotient(dividing: (r2, r1, r0), by: (d1, d0))
                product.load(y)
                product.multiply(byWord: q)
                if product <= x.extract(j - dc ..< j + 1) {
                    x.subtract(product, shiftedBy: j - dc)
                }
                else {
                    x.add(y, shiftedBy: j - dc)
                    x.subtract(product, shiftedBy: j - dc)
                }
            }
        }
        x >>= shift
    }

    @inlinable
    public mutating func formRemainder(dividingBy y: KernelNumerics.BigUInt, normalizedBy shift: Int) {
        precondition(!y.isZero)
        assert(y.leadingZeroBitCount == 0)
        if y.count == 1 {
            let remainder = self.divide(byWord: y[0] >> shift)
            self.load(KernelNumerics.BigUInt(remainder))
            return
        }
        self <<= shift
        if self >= y {
            let dc = y.count
            let d1 = y[dc - 1]
            let d0 = y[dc - 2]
            var product: KernelNumerics.BigUInt = 0
            for j in (dc ... self.count).reversed() {
                let r2 = self[j]
                let r1 = self[j - 1]
                let r0 = self[j - 2]
                let q = Word.approximateQuotient(dividing: (r2, r1, r0), by: (d1, d0))
                product.load(y)
                product.multiply(byWord: q)
                if product <= self.extract(j - dc ..< j + 1) {
                    self.subtract(product, shiftedBy: j - dc)
                }
                else {
                    self.add(y, shiftedBy: j - dc)
                    self.subtract(product, shiftedBy: j - dc)
                }
            }
        }
        self >>= shift
    }

    @inlinable
    public func quotientAndRemainder(dividingBy y:  KernelNumerics.BigUInt) -> (quotient:  KernelNumerics.BigUInt, remainder:  KernelNumerics.BigUInt) {
        var x = self
        var y = y
        KernelNumerics.BigUInt.divide(&x, by: &y)
        return (x, y)
    }

//    @inlinable
    public static func /(x: KernelNumerics.BigUInt, y: KernelNumerics.BigUInt) -> KernelNumerics.BigUInt {
        return x.quotientAndRemainder(dividingBy: y).quotient
    }
    
//    @inlinable
    public static func %(x: KernelNumerics.BigUInt, y: KernelNumerics.BigUInt) -> KernelNumerics.BigUInt {
        var x = x
        let shift = y.leadingZeroBitCount
        x.formRemainder(dividingBy: y << shift, normalizedBy: shift)
        return x
    }

//    @inlinable
    public static func /=(x: inout  KernelNumerics.BigUInt, y:  KernelNumerics.BigUInt) {
        var y = y
         divide(&x, by: &y)
    }
    
//    @inlinable
    public static func %=(x: inout KernelNumerics.BigUInt, y: KernelNumerics.BigUInt) {
        let shift = y.leadingZeroBitCount
        x.formRemainder(dividingBy: y << shift, normalizedBy: shift)
    }
    
}

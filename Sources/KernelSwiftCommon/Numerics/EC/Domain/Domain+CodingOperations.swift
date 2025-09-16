//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 22/10/2023.
//

extension KernelNumerics.EC.Domain {
    public enum CodingOperations {
        @_documentation(visibility: private)
        public typealias Arithmetic = KernelNumerics.EC.Arithmetic
        
        public static func encode(
            _ p: KernelNumerics.EC.Point,
            _ compressed: Bool,
            d: borrowing KernelNumerics.EC.Domain
        ) -> [UInt8] {
            var b: [UInt8]
            if p.isInfinite { b = .zeroes(1) }
            else {
                let l = (d.p.bitWidth + 7) / 8, bx = p.x.magnitudeBytes()
                if compressed {
                    b = .zeroes(l + 1)
                    b[.zero] = p.y.isEven ? 2 : 3
                    var x = 1 + l - bx.count
                    for i in .zero..<bx.count { b[x] = bx[i]; x += 1 }
                } 
                else {
                    let by = p.y.magnitudeBytes()
                    b = .zeroes(2 * l + 1)
                    b[.zero] = 4
                    var x = 1 + l - bx.count
                    for i in .zero..<bx.count { b[x] = bx[i]; x += 1 }
                    x += l - by.count
                    for i in .zero..<by.count { b[x] = by[i]; x += 1 }
                }
            }
            return b
        }
        
        public static func decode(
            _ b: [UInt8],
            d: borrowing KernelNumerics.EC.Domain
        ) throws -> KernelNumerics.EC.Point {
            var p: KernelNumerics.EC.Point
            let l = b.count, bw = (d.p.bitWidth + 7) / 8
            if l == 1 {
                if b[.zero] == .zero { p = .infinity }
                else { throw ArithmeticError.ecPointDecoding }
            }
            else if l == bw + 1 {
                let x: KernelNumerics.BigInt = .init(magnitudeBytes: .init(b[1..<l]))
                let x3 = Arithmetic.Barrett.addMod(
                    Arithmetic.Barrett.multiplyMod(Arithmetic.Barrett.squareMod(x, d: d), x, d: d),
                    Arithmetic.Barrett.addMod(Arithmetic.Barrett.multiplyMod(x, d.a, d: d), d.b, d: d),
                    d: d
                )
                if let y = x3.sqrtMod(d.p) {
                    if b[0] == 2 { p = .init(x: x, y: y.isEven ? y : d.p - y) }
                    else if b[0] == 3 { p = .init(x: x, y: y.isOdd ? y : d.p - y) }
                    else { throw ArithmeticError.ecPointDecoding }
                } 
                else { throw ArithmeticError.ecPointDecoding }
            } else if l == 2 * bw + 1 {
                if b[0] != 4 { throw ArithmeticError.ecPointDecoding }
                let x: KernelNumerics.BigInt = .init(magnitudeBytes: .init(b[1 ... l / 2]))
                let y: KernelNumerics.BigInt = .init(magnitudeBytes: .init(b[l / 2 + 1 ..< l]))
                p = .init(x: x, y: y)
            }
            else { throw ArithmeticError.ecPointDecoding }
            return p
        }
        

    }
}

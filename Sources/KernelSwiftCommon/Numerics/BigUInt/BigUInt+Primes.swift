//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/06/2023.
//

import Collections
import Foundation
import Logging
//import System
//import NIOCore
//import Vapor
//import KernelSwiftCommon

extension KernelNumerics {
    @inline(__always)
    nonisolated(unsafe) public static var primesTupleBigUInt:
        (   /*0x00*/    /*0x01*/    /*0x02*/    /*0x03*/    /*0x04*/    /*0x05*/    /*0x06*/    /*0x07*/    /*0x08*/    /*0x09*/    /*0x0a*/    /*0x0b*/    /*0x0c*/    /*0x0d*/    /*0x0e*/    /*0x0f*/
/*0x00*/    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,
/*0x01*/    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,
/*0x02*/    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,
/*0x03*/    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,
/*0x04*/    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,
/*0x05*/    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,
/*0x06*/    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,
/*0x07*/    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,
/*0x08*/    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,
/*0x09*/    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,
/*0x0a*/    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,
/*0x0b*/    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,
/*0x0c*/    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,
/*0x0d*/    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,
/*0x0e*/    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,
/*0x0f*/    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt,    BigUInt
        ) =
    (       /*0x00*/    /*0x01*/    /*0x02*/    /*0x03*/    /*0x04*/    /*0x05*/    /*0x06*/    /*0x07*/    /*0x08*/    /*0x09*/    /*0x0a*/    /*0x0b*/    /*0x0c*/    /*0x0d*/    /*0x0e*/    /*0x0f*/
/*0x00*/    2,          3,          5,          7,          11,         13,         17,         19,         23,         29,         31,         37,         41,         43,         47,         53,
/*0x01*/    59,         61,         67,         71,         73,         79,         83,         89,         97,         101,        103,        107,        109,        113,        127,        131,
/*0x02*/    137,        139,        149,        151,        157,        163,        167,        173,        179,        181,        191,        193,        197,        199,        211,        223,
/*0x03*/    227,        229,        233,        239,        241,        251,        257,        263,        269,        271,        277,        281,        283,        293,        307,        311,
/*0x04*/    313,        317,        331,        337,        347,        349,        353,        359,        367,        373,        379,        383,        389,        397,        401,        409,
/*0x05*/    419,        421,        431,        433,        439,        443,        449,        457,        461,        463,        467,        479,        487,        491,        499,        503,
/*0x06*/    509,        521,        523,        541,        547,        557,        563,        569,        571,        577,        587,        593,        599,        601,        607,        613,
/*0x07*/    617,        619,        631,        641,        643,        647,        653,        659,        661,        673,        677,        683,        691,        701,        709,        719,
/*0x08*/    727,        733,        739,        743,        751,        757,        761,        769,        773,        787,        797,        809,        811,        821,        823,        827,
/*0x09*/    829,        839,        853,        857,        859,        863,        877,        881,        883,        887,        907,        911,        919,        929,        937,        941,
/*0x0a*/    947,        953,        967,        971,        977,        983,        991,        997,        1009,       1013,       1019,       1021,       1031,       1033,       1039,       1049,
/*0x0b*/    1051,       1061,       1063,       1069,       1087,       1091,       1093,       1097,       1103,       1109,       1117,       1123,       1129,       1151,       1153,       1163,
/*0x0c*/    1171,       1181,       1187,       1193,       1201,       1213,       1217,       1223,       1229,       1231,       1237,       1249,       1259,       1277,       1279,       1283,
/*0x0d*/    1289,       1291,       1297,       1301,       1303,       1307,       1319,       1321,       1327,       1361,       1367,       1373,       1381,       1399,       1409,       1423,
/*0x0e*/    1427,       1429,       1433,       1439,       1447,       1451,       1453,       1459,       1471,       1481,       1483,       1487,       1489,       1493,       1499,       1511,
/*0x0f*/    1523,       1531,       1543,       1549,       1553,       1559,       1567,       1571,       1579,       1583,       1597,       1601,       1607,       1609,       1613,       1619
    )
    
    @inline(__always)
    public static func primeBigUIntFromTuple(_ index: Int) -> BigUInt {
        return withUnsafeBytes(of: &primesTupleBigUInt) {
            $0.load(fromByteOffset: index * 32, as: BigUInt.self)
        }
    }
    
//    @inlinable
    @inline(__always)
    public static let primesBigUInt: [BigUInt] =
    [       /*0x00*/    /*0x01*/    /*0x02*/    /*0x03*/    /*0x04*/    /*0x05*/    /*0x06*/    /*0x07*/    /*0x08*/    /*0x09*/    /*0x0a*/    /*0x0b*/    /*0x0c*/    /*0x0d*/    /*0x0e*/    /*0x0f*/
/*0x00*/    2,          3,          5,          7,          11,         13,         17,         19,         23,         29,         31,         37,         41,         43,         47,         53,
/*0x01*/    59,         61,         67,         71,         73,         79,         83,         89,         97,         101,        103,        107,        109,        113,        127,        131,
/*0x02*/    137,        139,        149,        151,        157,        163,        167,        173,        179,        181,        191,        193,        197,        199,        211,        223,
/*0x03*/    227,        229,        233,        239,        241,        251,        257,        263,        269,        271,        277,        281,        283,        293,        307,        311,
/*0x04*/    313,        317,        331,        337,        347,        349,        353,        359,        367,        373,        379,        383,        389,        397,        401,        409,
/*0x05*/    419,        421,        431,        433,        439,        443,        449,        457,        461,        463,        467,        479,        487,        491,        499,        503,
/*0x06*/    509,        521,        523,        541,        547,        557,        563,        569,        571,        577,        587,        593,        599,        601,        607,        613,
/*0x07*/    617,        619,        631,        641,        643,        647,        653,        659,        661,        673,        677,        683,        691,        701,        709,        719,
/*0x08*/    727,        733,        739,        743,        751,        757,        761,        769,        773,        787,        797,        809,        811,        821,        823,        827,
/*0x09*/    829,        839,        853,        857,        859,        863,        877,        881,        883,        887,        907,        911,        919,        929,        937,        941,
/*0x0a*/    947,        953,        967,        971,        977,        983,        991,        997,        1009,       1013,       1019,       1021,       1031,       1033,       1039,       1049,
/*0x0b*/    1051,       1061,       1063,       1069,       1087,       1091,       1093,       1097,       1103,       1109,       1117,       1123,       1129,       1151,       1153,       1163,
/*0x0c*/    1171,       1181,       1187,       1193,       1201,       1213,       1217,       1223,       1229,       1231,       1237,       1249,       1259,       1277,       1279,       1283,
/*0x0d*/    1289,       1291,       1297,       1301,       1303,       1307,       1319,       1321,       1327,       1361,       1367,       1373,       1381,       1399,       1409,       1423,
/*0x0e*/    1427,       1429,       1433,       1439,       1447,       1451,       1453,       1459,       1471,       1481,       1483,       1487,       1489,       1493,       1499,       1511,
/*0x0f*/    1523,       1531,       1543,       1549,       1553,       1559,       1567,       1571,       1579,       1583,       1597,       1601,       1607,       1609,       1613,       1619
    ]
    
    public static func rand1024BitBigUInt() -> BigUInt {
        return min1024BitBigUInt + BigUInt.randomBits(1021)
    }
    
    public static let min1024BitBigUInt: BigUInt = "141884656743115795386465259539451236680898848947115328636715040578866337902750481566354238661203768010560056939935696678829394884407208311246423715319737062188883946712432742638151109800623047059726541476042502884419075341171231440736956555270413618581675255342293149119973622969239858152417678164812112068609"
//    public static let min1024BitBigUInt: BigUInt =
//    "89884656743115795386465259539451236680898848947115328636715040578866337902750481566354238661203768010560056939935696678829394884407208311246423715319737062188883946712432742638151109800623047059726541476042502884419075341171231440736956555270413618581675255342293149119973622969239858152417678164812112068608"
    
    public static let max1024BitBigUInt: BigUInt = "179769313486231590772930519078902473361797697894230657273430081157732675805500963132708477322407536021120113879871393357658789768814416622492847430639474124377767893424865485276302219601246094119453082952085005768838150682342462881473913110540827237163350510684586298239947245938479716304835356329624224137215"
    
    public static let diff1024BitBigUInt: BigUInt = "89884656743115795386465259539451236680898848947115328636715040578866337902750481566354238661203768010560056939935696678829394884407208311246423715319737062188883946712432742638151109800623047059726541476042502884419075341171231440736956555270413618581675255342293149119973622969239858152417678164812112068607"
    
    public static let min2048BitBigUInt: BigUInt = "16158503035655503650357438344334975980222051334857742016065172713762327569433945446598600705761456731844358980460949009747059779575245460547544076193224141560315438683650498045875098875194826053398028819192033784138396109321309878080919047169238085235290822926018152521443787945770532904303776199561965192760957166694834171210342487393282284747428088017663161029038902829665513096354230157075129296432088558362971801859230928678799175576150822952201848806616643615613562842355410104862578550863465661734839271290328348967522998634176499319107762583194718667771801067716614802322659239302476074096777926805529798115328"
}

extension KernelNumerics.BigUInt {
   
    public static func mulMod(a: KernelNumerics.BigUInt, b: KernelNumerics.BigUInt, m: KernelNumerics.BigUInt) -> KernelNumerics.BigUInt {
        var res: KernelNumerics.BigUInt = 0
        var a = a
        var b = b
        while a != 0 {
            if (a & 1) != 0 { res = (res + b) % m }
            a >>= 1
            b = (b << 1) % m
        }
        return res
    }
    
    public static func powMod(a: KernelNumerics.BigUInt, b: KernelNumerics.BigUInt, n: KernelNumerics.BigUInt) -> KernelNumerics.BigUInt {
        var x: KernelNumerics.BigUInt = 1
        var a = a
        var b = b
        a %= n
        while b > 0 {
            if b % 2 == 1 { x = mulMod(a: x, b: a, m: n) }
            a = mulMod(a: a, b: a, m: n)
            b >>= 1
        }
        return x % n
    }
    
    
    
    public static func randomBits(_ width: Int) -> KernelNumerics.BigUInt {
        let innerBits: BitArray = .randomBits(count: 146)
        let bits: BitArray = [false] + innerBits + innerBits + innerBits + innerBits + innerBits + innerBits + innerBits
        return .init(bits)
    }
    
}

extension KernelNumerics.BigUInt {
    @usableFromInline
    static let primes: [Word] = [
        2,      3,      5,      7,      11,     13,     17,     19,
        23,     29,     31,     37,     41,     43,     47,     53,
        59,     61,     67,     71,     73,     79,     83,     89,
        97,     101,    103,    107,    109,    113,    127,    131,
        137,    139,    149,    151,    157,    163,    167,    173,
        179,    181,    191,    193,    197,    199,    211,    223,
        227,    229,    233,    239,    241,    251,    257,    263,
        269,    271,    277,    281,    283,    293,    307,    311,
        313,    317,    331,    337,    347,    349,    353,    359,
        367,    373,    379,    383,    389,    397,    401,    409,
        419,    421,    431,    433,    439,    443,    449,    457,
        461,    463,    467,    479,    487,    491,    499,    503,
        509,    521,    523,    541,    547,    557,    563,    569,
        571,    577,    587,    593,    599,    601,    607,    613,
        617,    619,    631,    641,    643,    647,    653,    659,
        661,    673,    677,    683,    691,    701,    709,    719,
        727,    733,    739,    743,    751,    757,    761,    769,
        773,    787,    797,    809,    811,    821,    823,    827,
        829,    839,    853,    857,    859,    863,    877,    881,
        883,    887,    907,    911,    919,    929,    937,    941,
        947,    953,    967,    971,    977,    983,    991,    997
    ]

    @usableFromInline
    static let pseudoPrimes: [KernelNumerics.BigUInt] = [
        /*  2 */ 2_047,
        /*  3 */ 1_373_653,
        /*  5 */ 25_326_001,
        /*  7 */ 3_215_031_751,
        /* 11 */ 2_152_302_898_747,
        /* 13 */ 3_474_749_660_383,
        /* 17 */ 341_550_071_728_321,
        /* 19 */ 341_550_071_728_321,
        /* 23 */ 3_825_123_056_546_413_051,
        /* 29 */ 3_825_123_056_546_413_051,
        /* 31 */ 3_825_123_056_546_413_051
    ]
}

public extension KernelNumerics.BigUInt {
    @inlinable
    static func generatePrimesPair(_ width: Int, concurrentCoreCount: Int = 10, retriesPerCore: Int = 3) async throws -> (KernelNumerics.BigUInt, KernelNumerics.BigUInt) {
        var concurrentCoreCount = concurrentCoreCount
        
        guard concurrentCoreCount > 0 else { preconditionFailure("Concurrent Prime Generator requires at least one cpu core") }
        let availableCoreCount = ProcessInfo.processInfo.activeProcessorCount
        if concurrentCoreCount >= availableCoreCount {
            KernelNumerics.logger.warning("Concurrent Prime Generator cannot run on more cpu cores than available to the system. Automatically reconfiguring generator to use \(availableCoreCount - 1) cores.")
            concurrentCoreCount = availableCoreCount - 1
        }
        //        var groupResult: KernelNumerics.BigUInt = 0
        
        return try await withThrowingTaskGroup(of: KernelNumerics.BigUInt.self, returning: (KernelNumerics.BigUInt, KernelNumerics.BigUInt).self) { group in
            do {
                var retryCount: Int = 0
                retryLoop: while retryCount < retriesPerCore {
                    concurrentLoop: for _ in 0..<concurrentCoreCount {
                        let _ = group.addTaskUnlessCancelled {
                            var cand = KernelNumerics.BigUInt.randomOddInteger(withExactWidth: width)
                            switch width {
                            case 1024:
                                coreLoop: while !Task.isCancelled, try !isPrime(prime: cand, largerThan: KernelNumerics.min1024BitBigUInt) {
                                    if Task.isCancelled { break coreLoop }
                                    cand = KernelNumerics.BigUInt.randomOddInteger(withExactWidth: width)
                                }
                                return cand
                            case 2048:
                                coreLoop: while !Task.isCancelled, try !isPrime(prime: cand, largerThan: KernelNumerics.min2048BitBigUInt) {
                                    if Task.isCancelled { break coreLoop }
                                    cand = KernelNumerics.BigUInt.randomOddInteger(withExactWidth: width)
                                }
                                
                                return cand
                            default:
                                coreLoop: while !Task.isCancelled, try !isPrime(prime: cand) {
                                    if Task.isCancelled { break coreLoop }
                                    cand = KernelNumerics.BigUInt.randomOddInteger(withExactWidth: width)
                                }
                                return cand
                            }
                            
                        }
                    }
                    while !group.isCancelled, let r1 = try? await group.next(), let r2 = try? await group.next() {
                        guard KernelNumerics.BigUInt(65537).inverseNoOpt(modulus: (r1 - 1) * (r2 - 1)).bitWidth == width * 2 else { continue }
                        group.cancelAll()
                        return (r1, r2)
                    }

                    retryCount += 1
                    KernelNumerics.logger.debug("using additional cycle \(retryCount)")
                }
                
                
                
                throw KernelNumerics.TypedError(.primeGenerationFailed)
                
            } catch let error {
                KernelNumerics.logger.error("\(error.localizedDescription)")
                throw error
            }
        }
        //        return groupResult
        //        if let groupResult { print(groupResult) }
    }
    
    @inlinable
    static func generatePrimeNoAsync(_ width: Int) throws -> KernelNumerics.BigUInt {
        var cand = KernelNumerics.BigUInt.randomOddInteger(withExactWidth: width)
        while try !isPrime(prime: cand) {
            cand = KernelNumerics.BigUInt.randomOddInteger(withExactWidth: width)
        }
        return cand

    }
    
    @inlinable
    static func isStrongProbablePrime(_ orig: KernelNumerics.BigUInt, _ base: KernelNumerics.BigUInt) throws -> Bool {
        let dec = orig - 1

        let r = dec.trailingZeroBitCount
        let d = dec >> r

        var test = power(for: base, d, modulus: orig)
        if test == 1 || test == dec { return true }

        if r > 0 {
            let shift = orig.leadingZeroBitCount
            let normalized = orig << shift
            for _ in 1 ..< r {
                if Task.isCancelled { break }
                test *= test
                formRemainder(for: &test, dividingBy: normalized, normalizedBy: shift)
                if test == 1 {
                    return false
                }
                if test == dec { return true }
            }
        }
        return false
    }
}

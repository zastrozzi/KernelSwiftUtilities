//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 9/19/23.
//

import Foundation

extension KernelNumerics.BigUInt {

    @inlinable
    public static func isPrime(prime: KernelNumerics.BigUInt, largerThan: KernelNumerics.BigUInt = 0) throws -> Bool {
        if prime[.zero].and(0x01, equals: .zero) { return false }
        guard prime > largerThan else { return false }
        
        for smPrime in KernelNumerics.primesBigUInt {
//            try Task.checkCancellation()
            if prime % smPrime == 0 { return false }
        }

        let random = randomInteger(lessThan: prime - 2) + 2
        let isProbable = try isStrongProbablePrime(prime, random)
        guard isProbable else { return false }

        return true
    }
}

////
////  File.swift
////  
////
////  Created by Jimmy Hough Jr on 9/19/23.
////
//
//import Foundation
//import Logging
//
//extension KernelNumerics.BigInt {
//    @inlinable
//    public static func generatePrimesPair(_ width: Int, concurrentCoreCount: Int = 10, retriesPerCore: Int = 3) async throws -> (KernelNumerics.BigUInt, KernelNumerics.BigUInt) {
//        var concurrentCoreCount = concurrentCoreCount
//        //        print(concurrentCoreCount, "CORES")
//        guard concurrentCoreCount > 0 else { preconditionFailure("Concurrent Prime Generator requires at least one cpu core") }
//        let availableCoreCount = ProcessInfo.processInfo.activeProcessorCount
//        if concurrentCoreCount >= availableCoreCount {
//            KernelNumerics.logger.warning("Concurrent Prime Generator cannot run on more cpu cores than available to the system. Automatically reconfiguring generator to use \(availableCoreCount - 1) cores.")
//            concurrentCoreCount = availableCoreCount - 1
//        }
////                let groupResult: KernelNumerics.BigUInt = 0
//        
//        return try await withThrowingTaskGroup(of: KernelNumerics.BigUInt.self, returning: (KernelNumerics.BigUInt, KernelNumerics.BigUInt).self) { group in
//            do {
//                var retryCount: Int = 0
//                while retryCount < retriesPerCore {
//                    for _ in 0..<concurrentCoreCount {
//                        let _ = group.addTaskUnlessCancelled {
//                            try Task.checkCancellation()
//                            var cand = KernelNumerics.BigUInt.randomOddInteger(withExactWidth: width)
//                            switch width {
//                            case 1024:
//                                while try !KernelNumerics.BigUInt.isPrime(prime: cand, largerThan: KernelNumerics.min1024BitBigUInt) {
//                                    try Task.checkCancellation()
//                                    cand = KernelNumerics.BigUInt.randomOddInteger(withExactWidth: width)
//                                }
//                                return cand
//                            default:
//                                while try !KernelNumerics.BigUInt.isPrime(prime: cand) {
//                                    try Task.checkCancellation()
//                                    cand = KernelNumerics.BigUInt.randomOddInteger(withExactWidth: width)
//                                }
//                                return cand
//                            }
//                            
//                        }
//                    }
//                    while let r1 = try? await group.next(), let r2 = try? await group.next() {
//                        guard KernelNumerics.BigUInt(65537).inverseNoOpt(modulus: (r1 - 1) * (r2 - 1)).bitWidth == width * 2 else { continue }
//                        //                        print(retryCount, "retry counter")
//                        group.cancelAll()
//                        return (r1, r2)
//                    }
//                    
//                    retryCount += 1
//                    KernelNumerics.logger.debug("prime generator using additional cycle \(retryCount)")
//                }
//                
//                
//                
//                throw KernelNumerics.TypedError(.primeGenerationFailed)
//                
//            } catch let error {
//                KernelNumerics.logger.error("BigInt.generatePrimesPair - \(error.localizedDescription)")
//                throw error
//            }
//        }
//        //        return groupResult
//        //        if let groupResult { print(groupResult) }
//    }
//}

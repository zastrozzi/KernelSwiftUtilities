//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 11/04/2023.
//

import Foundation

extension KernelCryptography.Algorithms {
    public typealias SigningAlgorithm = Either<AsymmetricSigningAlgorithm, SymmetricSigningAlgorithm>
}

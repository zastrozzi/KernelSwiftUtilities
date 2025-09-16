//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 05/11/2023.
//

import Foundation

extension KernelNumerics.EC.Curve {
    public typealias bn = BarretoNaehrig
    
    public enum BarretoNaehrig {
        public static let bn158: KernelNumerics.EC.Domain = .init(
            oid: .unknownOID("bn158"),
            p: "0x24240D8241D5445106C8442084001384E0000013",
            a: "0x0000000000000000000000000000000000000000",
            b: "0x0000000000000000000000000000000000000011",
            g: .init(
                x: "0x24240D8241D5445106C8442084001384E0000012",
                y: "0x0000000000000000000000000000000000000004"
            ),
            order: "0x24240D8241D5445106C7E3F07E0010842000000D",
            cofactor: 0x01
        )
    }
}

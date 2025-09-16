//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 02/10/2023.
//

import Foundation

extension KernelNumerics.EC.Curve {
    public typealias anssi = ANSSI
    
    public enum ANSSI {
        public static let frp256v1: KernelNumerics.EC.Domain = .init(
            oid: .frp256v1,
            p: "0xf1fd178c0b3ad58f10126de8ce42435b3961adbcabc8ca6de8fcf353d86e9c03",
            a: "0xf1fd178c0b3ad58f10126de8ce42435b3961adbcabc8ca6de8fcf353d86e9c00",
            b: "0xee353fca5428a9300d4aba754a44c00fdfec0c9ae4b1a1803075ed967b7bb73f",
            g: .init(
                x: "0xb6b3d4c356c139eb31183d4749d423958c27d2dcaf98b70164c97a2dd98f5cff",
                y: "0x6142e0f7c8b204911f9271f0f3ecef8c2701c307e8e4c9e183115a1554062cfb"
            ),
            order: "0xf1fd178c0b3ad58f10126de8ce42435b53dc67e140d2bf941ffdd459c6d655e1",
            cofactor: 0x1
        )
    }
}

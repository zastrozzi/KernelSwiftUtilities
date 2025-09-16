//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 30/09/2023.
//

import Foundation

extension KernelNumerics.EC.Arithmetic {
    public enum Warren {
        public static func reduce(_ t: inout KernelNumerics.EC.Vector, d: borrowing KernelNumerics.EC.Domain) {
            var u = t
            while u.count > d.radixSize { u.storage.removeLast() }
            u.multiply(d.modPrime)
            while u.count > d.radixSize { u.storage.removeLast() }
            u.multiply(d.mod)
            u.add(t)
            
            if u.count > d.radixSize {
                for _ in .zero ..< d.radixSize {
                    u.storage.removeFirst()
                }
            }
            else { u = .zero }
            if u.compare(d.mod) >= .zero { u.subtract(d.mod) }
            t = u
        }
    }
}

//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 23/05/2023.
//

import Foundation
//import KernelCShims

public struct KernelUnicodeScalarSet {
    public enum SetType {
        case lowercaseLetter
        case uppercaseLetter
        case canonicalDecomposable
        case caseIgnorable
        case graphemeExtend
    }
    
    public var charset: SetType
    public static let bitshiftForByte: UInt16 = 3
    public static let bitshiftForMask: UInt16 = 7
    
    
    public init(type: SetType) {
        charset = type
    }
    
    
//    public var bitmapTableIndex: Int {
//        switch charset {
//        case .lowercaseLetter: return 2
//        case .uppercaseLetter: return 3
//        case .canonicalDecomposable: return 5
//        case .caseIgnorable: return 20
//        case .graphemeExtend: return 21
//        }
//    }
    
    @inlinable
    public func contains(_ scalar: Unicode.Scalar) -> Bool {
        let plane = Int((scalar.value >> 16) & 0xff)
        let bitmap = bitmapPtrForPlane(plane)
        return isMemberOfBitmap(scalar, bitmap)
    }
    
    @inlinable
    public func bitmapPtrForPlane(_ plane: Int) -> UnsafePointer<UInt8>? {
        fatalError("KERNEL UNICODE SCALARS DISABLED")
//        let tableIndex = charset.bitmapTableIndex
//        guard tableIndex < __KernelCFUniCharNumberOfBitmaps else { return nil }
//        
//        let data = withUnsafePointer(to: __KernelCFUniCharBitmapDataArray) { ptr in
//            ptr.withMemoryRebound(to: __KernelCFUniCharBitmapData.self, capacity: Int(__KernelCFUniCharNumberOfBitmaps)) { pointer in
//                pointer.advanced(by: tableIndex).pointee
//            }
//        }
//        return plane < data._numPlanes ? data._planes[plane] : nil
    }
    
    @inlinable
    public func isMemberOfBitmap(_ scalar: Unicode.Scalar, _ bitmap: UnsafePointer<UInt8>?) -> Bool {
        guard  let bitmap else { return false }
        let char = UInt16(truncatingIfNeeded: scalar.value)
        let pos = bitmap[Int(char >> Self.bitshiftForByte)]
        let mask = char & Self.bitshiftForMask
        let new = Int(pos).and(Int(UInt32(1) << mask), not: .zero)
        return new
    }
}

extension KernelUnicodeScalarSet.SetType {
    public var bitmapTableIndex: Int {
        switch self {
        case .lowercaseLetter: return 2
        case .uppercaseLetter: return 3
        case .canonicalDecomposable: return 5
        case .caseIgnorable: return 20
        case .graphemeExtend: return 21
        }
    }
}

extension KernelUnicodeScalarSet {
    nonisolated(unsafe) public static let uppercaseLetters: Self = .init(type: .uppercaseLetter)
    nonisolated(unsafe) public static let lowercaseLetters: Self = .init(type: .lowercaseLetter)
    nonisolated(unsafe) public static let caseIgnorables: Self = .init(type: .caseIgnorable)
    nonisolated(unsafe) public static let graphemeExtends: Self = .init(type: .graphemeExtend)
    nonisolated(unsafe) public static let canonicalDecomposables: Self = .init(type: .canonicalDecomposable)
}

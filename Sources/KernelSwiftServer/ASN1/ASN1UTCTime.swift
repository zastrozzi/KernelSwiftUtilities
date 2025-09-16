//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 15/06/2023.
//
import Vapor

extension KernelASN1 {
    public struct ASN1UTCTime: ASN1Codable, ASN1TimeRepresentable {
        public var underlyingData: [UInt8]?
        public var string: String
        public static let format: String = "yyMMddHHmmss'Z'"
        
        public init(string: String) {
            self.string = string
        }
        
        public func isEqualTo<O>(_ other: O) -> Bool where O : ASN1Codable {
            guard let other = other as? Self else { return false }
            return self.string == other.string
        }
        
    }
}

extension KernelASN1 {
    public enum ASN1TimeUnit: String {
        case year = "y"
        case month = "M"
        case day = "d"
        case hours = "H"
        case minutes = "m"
        case seconds = "s"
    }
}

extension KernelASN1.ASN1TimeUnit {
    public func rangeForFormatString(_ str: String) -> ClosedRange<String.Index> {
        guard let range = str.range(of: self.rawValue) else { return .init(uncheckedBounds: (lower: .init(utf16Offset: 0, in: ""), upper: .init(utf16Offset: 0, in: ""))) }
        return range.lowerBound...range.upperBound
    }
}

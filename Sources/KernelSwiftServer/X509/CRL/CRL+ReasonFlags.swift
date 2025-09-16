//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/07/2023.
//
import KernelSwiftCommon

extension KernelX509.CRL {
    public enum ReasonFlag: String, Codable, Equatable, CaseIterable, RawRepresentableAsString, FluentStringEnum, OpenAPIStringEnumSampleable, Sendable {
        public static let fluentEnumName: String = "k_x509-crl_reason_flag"
        case unused
        case keyCompromise
        case caCompromise
        case affiliationChanged
        case superseded
        case cessationOfOperation
        case certificateHold
        case privilegeWithdrawn
        case aaCompromise
    }
}

extension KernelX509.CRL.ReasonFlag {
//    public var byteValue: UInt8 {
//        switch self {
//        case .unused: 0x00
//        case .keyCompromise: 0x01
//        case .caCompromise: 0x02
//        case .affiliationChanged: 0x03
//        case .superseded: 0x04
//        case .cessationOfOperation: 0x05
//        case .certificateHold: 0x06
//        case .privilegeWithdrawn: 0x07
//        case .aaCompromise: 0x08
//        }
//    }
//    
//    public init(from byteValue: UInt8) throws {
//        switch byteValue {
//        case 0x00: self = .unused
//        case 0x01: self = .keyCompromise
//        case 0x02: self = .caCompromise
//        case 0x03: self = .affiliationChanged
//        case 0x04: self = .superseded
//        case 0x05: self = .cessationOfOperation
//        case 0x06: self = .certificateHold
//        case 0x07: self = .privilegeWithdrawn
//        case 0x08: self = .aaCompromise
//        default: throw KernelX509.Error(.extensionDecodingFailed)
//        }
//    }
    
    public var bitMask: UInt16 {
        switch self {
        case .unused: 0x8000
        case .keyCompromise: 0x4000
        case .caCompromise: 0x2000
        case .affiliationChanged: 0x1000
        case .superseded: 0x0800
        case .cessationOfOperation: 0x0400
        case .certificateHold: 0x0200
        case .privilegeWithdrawn: 0x0100
        case .aaCompromise: 0x0080
        }
    }
    
    public static var firstByteValues: [Self] {[
        .unused, .keyCompromise, .caCompromise, .affiliationChanged,
        .superseded, .cessationOfOperation, .certificateHold, .privilegeWithdrawn
    ]}
}

extension KernelX509.CRL {
    public struct ReasonFlags {
        public var flags: Set<ReasonFlag>
        
        public init(flags: Set<ReasonFlag>) {
            self.flags = flags
        }
    }
}

extension KernelX509.CRL.ReasonFlags: ASN1Decodable, ASN1Buildable {
    public func composedValue() -> UInt16 {
        //            var root: UInt16 = 0x0000
        return KernelX509.CRL.ReasonFlag.allCases.reduce(into: UInt16(0x0000)) { acc, next in
            if flags.contains(next) { acc |= next.bitMask } else { acc &= (~next.bitMask) }
        }
        //            return root
    }
    
    var valueBytes: [UInt8] {
        let composed = composedValue()
        let byte: UInt8 = .init(truncatingIfNeeded: composed >> 8)
        if flags.contains(.aaCompromise) {
            return [byte, .init(truncatingIfNeeded: composed)]
        } else {
            return [byte]
        }
    }
    
    public init(from asn1Type: KernelASN1.ASN1Type) throws {
        guard case let .bitString(bitString) = asn1Type else { throw Self.decodingError(.bitString, asn1Type) }
//        guard bitString.value.allSatisfy({ $0 <= 0x09 }) else { throw Self.decodingError(.bitString, asn1Type) }
        var flagSet: Set<KernelX509.CRL.ReasonFlag> = .init()
        
        var recomposed: UInt16 = .init(bitString.value[0]) << 8
        if bitString.value.count > 1 {
            recomposed += .init(bitString.value[1])
        }
        KernelX509.CRL.ReasonFlag.allCases.forEach {
            if recomposed & $0.bitMask == $0.bitMask { flagSet.insert($0) }
        }
        self.flags = flagSet
    }
    
    public func buildASN1Type() -> KernelASN1.ASN1Type {
//        let rawByteSet = self.flags.map { $0.byteValue }.sorted()
        return .bitString(.init(unusedBits: .init(truncatingIfNeeded: valueBytes.last!.trailingZeroBitCount), data: .init(valueBytes)))
    }
}

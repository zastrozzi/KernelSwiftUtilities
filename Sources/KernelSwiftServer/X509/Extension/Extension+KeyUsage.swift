//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 21/06/2023.
//

import KernelSwiftCommon

extension KernelX509.Extension {
    public struct KeyUsage: X509ExtensionTransformable {
        public var critical: Bool
        public var flags: Set<KernelX509.Common.KeyUsageFlag>
        
        internal func composedValue() -> UInt16 {
//            var root: UInt16 = 0x0000
//            print(flags)
            return KernelX509.Common.KeyUsageFlag.allCases.reduce(into: UInt16(0x0000)) { acc, next in
                if flags.contains(next) { acc |= next.bitMask } else { acc &= (~next.bitMask) }
            }
//            return root
        }
        
        public init(critical: Bool = true, flags: KernelX509.Common.KeyUsageFlag...) {
            self.init(critical: critical, flags: flags)
        }
        
        public init(critical: Bool = true, flags: [KernelX509.Common.KeyUsageFlag]) {
            self.critical = critical
            self.flags = .init(flags)
        }
    }
}

extension KernelX509.Extension.KeyUsage {
    var valueBytes: [UInt8] {
        let composed = composedValue()
        let byte: UInt8 = .init(truncatingIfNeeded: composed >> 8)
        if flags.contains(.decipherOnly) {
            return [byte, .init(truncatingIfNeeded: composed)]
        } else {
            return [byte]
        }
    }
}

extension KernelX509.Extension.KeyUsage: X509ExtensionBuildable {
//    public func buildExtension() throws -> KernelX509.Extension {
//        let bytes = KernelASN1.ASN1Writer.dataForObjectType(tag: 0x03, valueBytes)
//        return .init(extId: .keyUsage, critical: critical, extValue: bytes)
//    }
    
    public func buildExtensionData() throws -> KernelASN1.ASN1Type {
        let bytes = valueBytes
        return .bitString(.init(unusedBits: .init(truncatingIfNeeded: bytes.last!.trailingZeroBitCount), data: bytes))
    }
}
//
//extension KernelX509.Extension.KeyUsage: ASN1TypedDecodable {
//    public static var asn1DecodingSchema: Array<ASN1CodingKeySchemaItem<Self>> = [
//        .init(from: \.critical, dataType: .boolean, decodedType: Bool.self),
//        .init(from: \.flags, dataType: .octetString, decodedType: Set<KernelX509.Common.KeyUsageFlag>.self)
//    ]
//}

extension KernelX509.Extension.KeyUsage: X509ExtensionDecodable {
    public static var extIdentifier: KernelX509.Extension.ExtensionIdentifier { .keyUsage }
    public init(from ext: KernelX509.Extension) throws {
        guard ext.extId == Self.extIdentifier else { throw Self.extensionDecodingFailed() }
        self.critical = ext.critical
        guard case let .bitString(bits) = try KernelASN1.ASN1Parser4.objectFromBytes(ext.extValue).asn1(), bits.value.count < 3 else { throw Self.extensionDecodingFailed() }
        var recomposed: UInt16 = .init(bits.value[0]) << 8
        if bits.value.count > 1 {
            recomposed += .init(bits.value[1])
        }
        var foundFlags: Set<KernelX509.Common.KeyUsageFlag> = []
        KernelX509.Common.KeyUsageFlag.allCases.forEach {
            if recomposed & $0.bitMask == $0.bitMask { foundFlags.insert($0) }
        }
        self.flags = foundFlags
    }
}

public protocol X509ExtensionDecodable {
    var critical: Bool { get set }
    static var extIdentifier: KernelX509.Extension.ExtensionIdentifier { get }
    init(from ext: KernelX509.Extension) throws
}

extension X509ExtensionDecodable {
    public static func extensionDecodingFailed() -> KernelX509.TypedError {
        KernelX509.TypedError.extensionDecodingFailed(Self.self)
    }
}

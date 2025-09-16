//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 15/06/2023.
//
import KernelSwiftCommon

extension KernelASN1 {
    public struct ASN1ObjectIdentifier: ASN1Codable {
        public var underlyingData: [UInt8]?
        public var identifier: [Int]
        public var oid: KernelSwiftCommon.ObjectID?
        
        public init(identifier: [Int]) {
            self.identifier = identifier
            self.oid = .init(id: identifier)
        }
        
        public init(oid: KernelSwiftCommon.ObjectID) {
            self.identifier = oid.identifier
            self.oid = oid
        }
        
        public func isEqualTo<O>(_ other: O) -> Bool where O : ASN1Codable {
            guard let other = other as? Self else { return false }
            return self.identifier == other.identifier
        }
    }
}

extension KernelASN1.ASN1ObjectIdentifier: ASN1Decodable, ASN1Buildable {
    public init(from asn1Type: KernelASN1.ASN1Type) throws {
        if case let .any(asn1) = asn1Type {
            //            print(asn1.underlyingData?.toHexString() ?? "", "UNDERLYING")
            var bytes = asn1.underlyingData ?? [0]
            bytes[0] = .asn1.typeTag.objectIdentifier
            let parsed = try KernelASN1.ASN1Parser4.objectFromBytes(bytes)
//            KernelASN1.ASN1Printer.printObjectVerbose(parsed)
            guard case let .objectIdentifier(asn1) = parsed.asn1() else { throw Self.decodingError(.objectIdentifier, parsed.asn1()) }
            self = asn1
            return
        }
        guard case let .objectIdentifier(asn1) = asn1Type else { throw Self.decodingError(.objectIdentifier, asn1Type) }
        self = asn1
    }
    
    public func buildASN1Type() -> KernelASN1.ASN1Type { .objectIdentifier(self) }
    
    public var writableBytes: [UInt8] {
        let prefix: UInt8 = .init(identifier[0] * 40 + identifier[1])
        var writableData: [UInt8] = [prefix]
        for var v in identifier[2..<identifier.count] {
            var values: [Int] = []
            repeat {
                values.append(v & .asn1.mask.multiByteMask)
                v = v >> 7
            } while v != 0
            writableData += values[1..<values.count].reversed().map { .init(.asn1.class.contextSpecific | $0)}
            writableData += [.init(values[0])]
        }
        return writableData
    }
}

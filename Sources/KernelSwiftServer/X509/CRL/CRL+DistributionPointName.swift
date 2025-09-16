//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/07/2023.
//

extension KernelX509.CRL {
    public enum DistributionPointName {
        case fullName(KernelX509.Common.GeneralName)
        case nameRelativeToCRLIssuer(KernelX509.Common.RelativeDistinguishedName)
    }
}

extension KernelX509.CRL.DistributionPointName: ASN1Decodable, ASN1Buildable {
    public init(from asn1Type: KernelASN1.ASN1Type) throws {
        var asn1Type = asn1Type
        //        print(asn1Type, "GOT?")
        if case let .sequence(seqItems) = asn1Type {
            asn1Type = seqItems[0]
            guard case let .tagged(tag, .constructed(constrASN1Types)) = asn1Type else { throw Self.decodingError(nil, asn1Type) }
            switch tag {
            case 0: self = .fullName(try .init(from: constrASN1Types[0]))
            case 1: self = .nameRelativeToCRLIssuer(try .init(from: constrASN1Types[0]))
            default:
                print("FAILED DISTRIBUTION POINT NAME DECODE", tag, constrASN1Types[0])
                throw Self.decodingError(nil, asn1Type)
            }
        }
        //        if case let .tagged(tag, .implicit(taggedASN1Type)) = asn1Type {
        //            print(asn1Type)
        //        }
        else {
            guard case let .tagged(tag, .implicit(taggedASN1Type)) = asn1Type else { throw Self.decodingError(nil, asn1Type) }
            switch tag {
            case 0: self = .fullName(try .init(from: taggedASN1Type))
            case 1: self = .nameRelativeToCRLIssuer(try .init(from: taggedASN1Type))
            default:
                print("FAILED DISTRIBUTION POINT NAME DECODE", tag, taggedASN1Type)
                throw Self.decodingError(nil, asn1Type)
            }
        }
    }
    
    public init(from decoder: Decoder) throws {
        fatalError()
    }
    
    public func buildASN1Type() -> KernelASN1.ASN1Type {
        switch self {
        case let .fullName(wrapped): .tagged(0, .constructed([wrapped.buildASN1Type()]))
        case let .nameRelativeToCRLIssuer(wrapped): .tagged(1, .constructed([wrapped.buildASN1Type()]))
        }
    }
}

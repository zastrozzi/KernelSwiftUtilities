//
//  File.swift
//
//
//  Created by Jonathan Forbes on 12/07/2023.
//

extension KernelX509.CRL {
    public struct DistributionPoint: ASN1Decodable, ASN1Buildable {
        public var distributionPoint: DistributionPointName?
        public var reasons: ReasonFlags?
        public var crlIssuer: KernelX509.Common.GeneralName?
        
        public init(
            distributionPoint: DistributionPointName? = nil,
            reasons: ReasonFlags? = nil,
            crlIssuer: KernelX509.Common.GeneralName? = nil
        ) {
            self.distributionPoint = distributionPoint
            self.reasons = reasons
            self.crlIssuer = crlIssuer
        }
        
        public init(from asn1Type: KernelASN1.ASN1Type) throws {
            guard case let .sequence(sequenceItems) = asn1Type else { throw Self.decodingError(.sequence, asn1Type) }
            switch sequenceItems.count {
            case 3:
                guard case let .tagged(_, wrapped0) = sequenceItems[0] else { throw Self.decodingError(.sequence, sequenceItems[0]) }
                guard case let .tagged(_, wrapped1) = sequenceItems[1] else { throw Self.decodingError(.sequence, sequenceItems[1]) }
                guard case let .tagged(_, wrapped2) = sequenceItems[2] else { throw Self.decodingError(.sequence, sequenceItems[2]) }
                let dPoint: KernelX509.CRL.DistributionPointName = try .init(from: wrapped0.unwrapped)
                let reasonFlags: KernelX509.CRL.ReasonFlags = try .init(from: wrapped1.unwrapped)
                let crlIss: KernelX509.Common.GeneralName = try .init(from: wrapped2.unwrapped)
                self.distributionPoint = dPoint
                self.reasons = reasonFlags
                self.crlIssuer = crlIss
                return
                
            case 2:
                guard case let .tagged(tag0, wrapped0) = sequenceItems[0] else { throw Self.decodingError(.sequence, sequenceItems[0]) }
                guard case let .tagged(tag1, wrapped1) = sequenceItems[1] else { throw Self.decodingError(.sequence, sequenceItems[1]) }
                switch (tag0, tag1) {
                case (0, 1):
                    let dPoint: KernelX509.CRL.DistributionPointName = try .init(from: wrapped0.unwrapped)
                    let reasonFlags: KernelX509.CRL.ReasonFlags = try .init(from: wrapped1.unwrapped)
                    self.distributionPoint = dPoint
                    self.reasons = reasonFlags
                    self.crlIssuer = nil
                    return
                case (0, 2):
                    let dPoint: KernelX509.CRL.DistributionPointName = try .init(from: wrapped0.unwrapped)
                    let crlIss: KernelX509.Common.GeneralName = try .init(from: wrapped0.unwrapped)
                    self.distributionPoint = dPoint
                    self.reasons = nil
                    self.crlIssuer = crlIss
                    return
                case (1, 2):
                    let reasonFlags: KernelX509.CRL.ReasonFlags = try .init(from: wrapped0.unwrapped)
                    let crlIss: KernelX509.Common.GeneralName = try .init(from: wrapped1.unwrapped)
                    self.distributionPoint = nil
                    self.reasons = reasonFlags
                    self.crlIssuer = crlIss
                    return
                default: throw Self.decodingError(.sequence, asn1Type)
                }
            case 1:
                guard case let .tagged(tag, wrapped) = sequenceItems[0] else { throw Self.decodingError(.sequence, sequenceItems[0]) }
                switch tag {
                case 0:
                    let dPoint: KernelX509.CRL.DistributionPointName = try .init(from: wrapped.unwrapped)
                    self.distributionPoint = dPoint
                    self.reasons = nil
                    self.crlIssuer = nil
                    return
                case 1:
                    let reasonFlags: KernelX509.CRL.ReasonFlags = try .init(from: wrapped.unwrapped)
                    self.distributionPoint = nil
                    self.reasons = reasonFlags
                    self.crlIssuer = nil
                    return
                case 2:
                    let crlIss: KernelX509.Common.GeneralName = try .init(from: wrapped.unwrapped)
                    self.distributionPoint = nil
                    self.reasons = nil
                    self.crlIssuer = crlIss
                    return
                default: throw Self.decodingError(.sequence, asn1Type)
                }
            case 0:
                self.distributionPoint = nil
                self.reasons = nil
                self.crlIssuer = nil
                return
            default: throw Self.decodingError(.sequence, asn1Type)
            }
        }
        
        public func buildASN1Type() -> KernelASN1.ASN1Type {
            if let distributionPoint, let reasons, let crlIssuer {
                .sequence([
                    .tagged(0, .constructed([distributionPoint.buildASN1Type()])),
                    .tagged(1, .constructed([reasons.buildASN1Type()])),
                    .tagged(2, .constructed([crlIssuer.buildASN1Type()]))
                ])
            } else if let distributionPoint, let reasons {
                .sequence([
                    .tagged(0, .constructed([distributionPoint.buildASN1Type()])),
                    .tagged(1, .constructed([reasons.buildASN1Type()]))
                ])
            } else if let distributionPoint, let crlIssuer {
                .sequence([
                    .tagged(0, .constructed([distributionPoint.buildASN1Type()])),
                    .tagged(2, .constructed([crlIssuer.buildASN1Type()]))
                ])
            } else if let reasons, let crlIssuer {
                .sequence([
                    .tagged(1, .constructed([reasons.buildASN1Type()])),
                    .tagged(2, .constructed([crlIssuer.buildASN1Type()]))
                ])
            } else if let distributionPoint {
                .sequence([
                    .tagged(0, .constructed([distributionPoint.buildASN1Type()]))
                ])
            } else if let reasons {
                .sequence([
                    
                    .tagged(1, .constructed([reasons.buildASN1Type()]))
                    
                ])
            } else if let crlIssuer {
                .sequence([
                    .tagged(2, .constructed([crlIssuer.buildASN1Type()]))
                ])
            } else {
                .sequence([])
            }
        }
    }
}

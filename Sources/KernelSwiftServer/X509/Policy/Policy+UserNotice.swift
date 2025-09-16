//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 11/07/2023.
//

extension KernelX509.Policy {
    public struct UserNotice: ASN1Decodable {
        public var noticeRef: NoticeReference?
        public var explicitText: KernelX509.Policy.DisplayText?
        
        public init(
            noticeRef: NoticeReference? = nil,
            explicitText: KernelX509.Policy.DisplayText? = nil
        ) {
            self.noticeRef = noticeRef
            self.explicitText = explicitText
        }

        public init(from decoder: Decoder) throws {
            fatalError()
        }
        
        public init(from asn1Type: KernelASN1.ASN1Type) throws {
            
            guard case let .sequence(items) = asn1Type else { throw Self.decodingError(.sequence, asn1Type) }
            switch items.count {
            case 2:
                let notRef: KernelX509.Policy.NoticeReference = try .init(from: items[0])
                self.noticeRef = notRef
                let explText: KernelX509.Policy.DisplayText = try .init(from: items[1])
                self.explicitText = explText
                return
            case 1:
                if case let .sequence(sub) = items[0] {
                    let notRef: KernelX509.Policy.NoticeReference = try .init(from: .sequence(sub))
                    self.noticeRef = notRef
                    self.explicitText = nil
                    return
                } else {
//                    print("USER NOTICE", items[0])
                    self.noticeRef = nil
                    let explText: KernelX509.Policy.DisplayText = try .init(from: items[0])
                    self.explicitText = explText
                    return
                }
            case 0:
                self.noticeRef = nil
                self.explicitText = nil
                return
            default: throw Self.decodingError(.sequence, asn1Type)
            }
            
        }
        
    }
}

extension KernelX509.Policy.UserNotice: ASN1Buildable {
    public func buildASN1Type() -> KernelASN1.ASN1Type {
        if let noticeRef, let explicitText {
            .sequence([
                noticeRef.buildASN1Type(),
                explicitText.buildASN1Type()
            ])
        }
        else if let noticeRef {
            .sequence([
                noticeRef.buildASN1Type()
            ])
        }
        else if let explicitText {
            .sequence([
                explicitText.buildASN1Type()
            ])
        }
        else {
            .sequence([])
        }
    }
}

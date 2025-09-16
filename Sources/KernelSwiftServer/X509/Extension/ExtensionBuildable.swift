//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 21/06/2023.
//

public protocol X509ExtensionBuildable: ASN1Decodable {
    var critical: Bool { get set }
    static var extIdentifier: KernelX509.Extension.ExtensionIdentifier { get }
    func buildExtension() throws -> KernelX509.Extension
    func buildExtensionData() throws -> KernelASN1.ASN1Type
    func buildNonSerialisedExtension() throws -> KernelASN1.ASN1Type
}

extension X509ExtensionBuildable {
    public func buildExtension() throws -> KernelX509.Extension {
        let serialised = KernelASN1.ASN1Writer.dataFromObject(try buildExtensionData())
        return .init(extId: Self.extIdentifier, critical: critical, extValue: serialised)
    }
    
    public func buildExtensionData() throws -> KernelASN1.ASN1Type {
        throw KernelASN1.TypedError(.notImplemented)
    }
    
    public func buildNonSerialisedExtension() throws -> KernelASN1.ASN1Type {
        if critical {
            .sequence([
                Self.extIdentifier.buildASN1Type(),
                .boolean(.init(value: true)),
                try buildExtensionData()
            ])
        } else {
            .sequence([
                Self.extIdentifier.buildASN1Type(),
                try buildExtensionData()
            ])
        }
    }
}

//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 19/05/2025.
//

import KernelSwiftCommon
import AVFoundation

extension AVMetadataObject.ObjectType {
    public static let code11: AVMetadataObject.ObjectType = .init(rawValue: "org.iso.Code11")
    public static let code128a: AVMetadataObject.ObjectType = .init(rawValue: "org.iso.Code128-A")
    public static let code128b: AVMetadataObject.ObjectType = .init(rawValue: "org.iso.Code128-B")
    public static let code128c: AVMetadataObject.ObjectType = .init(rawValue: "org.iso.Code128-C")
    public static let msi: AVMetadataObject.ObjectType = .init(rawValue: "org.msi.MSI")
    public static let rm4scc: AVMetadataObject.ObjectType = .init(rawValue: "org.royal-mail.RM4SCC")
    public static let upca: AVMetadataObject.ObjectType = .init(rawValue: "org.gs1.UPC-A")
    public static let uspsIntelligentMail: AVMetadataObject.ObjectType = .init(rawValue: "org.usps.IntelligentMail")
    public static let uspsPostnet: AVMetadataObject.ObjectType = .init(rawValue: "org.usps.Postnet")
    public static let maxiCode: AVMetadataObject.ObjectType = .init(rawValue: "org.maxicode.MaxiCode")
}

extension KernelSwiftCommon.Barcode.CodeType {
    public var avMetadataObjectType: AVMetadataObject.ObjectType {
        switch self {
        case .codabar: .codabar
        case .code11: .code11
        case .code39: .code39
        case .code39Mod43: .code39Mod43
        case .code93: .code93
        case .code128: .code128
        case .code128a: .code128a
        case .code128b: .code128b
        case .code128c: .code128c
        case .ean8: .ean8
        case .ean13: .ean13
        case .gs1DataBar: .gs1DataBar
        case .gs1DataBarExpanded: .gs1DataBarExpanded
        case .gs1DataBarLimited: .gs1DataBarLimited
        case .interleaved2of5: .interleaved2of5
        case .interleaved2of5Mod10: .interleaved2of5 // DANGEROUS!
        case .itf14: .itf14
        case .msi: .msi
        case .rm4scc: .rm4scc
        case .upca: .upca
        case .upce: .upce
        case .uspsIntelligentMail: .uspsIntelligentMail
        case .uspsPostnet: .uspsPostnet
        case .aztec: .aztec
        case .dataMatrix: .dataMatrix
        case .maxiCode: .maxiCode
        case .microPDF417: .microPDF417
        case .microQR: .microQR
        case .pdf417: .pdf417
        case .qr: .qr
        }
    }
}

//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 16/06/2024.
//

extension KernelSwiftCommon.Barcode {
    public enum CodeType: String, Codable, Equatable, CaseIterable, Sendable {
        // 1D Barcodes
        case codabar = "codabar"
        case code11 = "code_11"
        case code39 = "code_39"
        case code39Mod43 = "code_39_mod_43"
        case code93 = "code_93"
        case code128 = "code_128"
        case code128a = "code_128a"
        case code128b = "code_128b"
        case code128c = "code_128c"
        case ean8 = "ean_8"
        case ean13 = "ean_13"
        case gs1DataBar = "gs1_data_bar"
        case gs1DataBarExpanded = "gs1_databar_expanded"
        case gs1DataBarLimited = "gs1_databar_limited"
        case interleaved2of5 = "interleaved_2_5"
        case interleaved2of5Mod10 = "interleaved_2_5_mod_10"
        case itf14 = "itf_14"
        case msi = "msi"
        case rm4scc = "rm_4_scc"
        case upca = "upca"
        case upce = "upce"
        case uspsIntelligentMail = "usps_intelligent_mail"
        case uspsPostnet = "usps_postnet"
        
        // 2D Barcodes
        case aztec = "aztec"
        case dataMatrix = "data_matrix"
        case maxiCode = "maxi_code"
        case microPDF417 = "micro_pdf_417"
        case microQR = "micro_qr"
        case pdf417 = "pdf_417"
        case qr = "qr"
    }
}

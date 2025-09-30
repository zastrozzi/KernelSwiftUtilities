//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 20/05/2025.
//

import SwiftUI
import CoreImage.CIFilterBuiltins
import AVFoundation
//import ZXingObjC

public struct BarcodeImageView: View {
    let context = CIContext()
    
    var text: String
    var type: AVMetadataObject.ObjectType
    
    public init(text: String, type: AVMetadataObject.ObjectType) {
        self.text = text
        self.type = type
    }
    
    public var body: some View {
        if let barcodeImage = generateBarcode() {
            if case .qr = type {
                barcodeImage.resizable().interpolation(.none).aspectRatio(contentMode: .fit)
            } else {
                barcodeImage.resizable().interpolation(.none)
            }
            
        } else {
            Image(systemName: "barcode")
        }
    }
    
    func generateBarcode() -> Image? {
        switch type {
        case .codabar: generateCodabar(text: text)
        case .code39: generateCode39(text: text)
        case .code93: generateCode93(text: text)
        case .code128: generateCode128(text: text)
        case .qr: generateQRCode(text: text)
        case .ean8: generateEAN8(text: text)
        case .ean13: generateEAN13(text: text)
        case .itf14: generateITF(text: text)
        case .upca: generateUPCA(text: text)
        case .upce: generateUPCE(text: text)
        case .aztec: generateAztec(text: text)
        case .dataMatrix: generateDataMatrix(text: text)
        case .pdf417: generatePDF417(text: text)
        default: nil
        }
    }
}

// MARK: - Code Generators (iOS)

#if os(iOS)
extension BarcodeImageView {
    
    func generateCode128(text: String) -> Image? {
        let generator = CIFilter.code128BarcodeGenerator()
        generator.message = Data(text.utf8)
        generator.barcodeHeight = 100
        generator.quietSpace = 0
        
        if
            let outputImage = generator.outputImage?.premultiplyingAlpha(),
            let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
        {
            let uiImage = UIImage(cgImage: cgImage)
            return Image(uiImage: uiImage)
        } else {
            return nil
        }
    }
    
    func generateQRCode(text: String) -> Image? {
        let generator = CIFilter.qrCodeGenerator()
        generator.message = Data(text.utf8)
        
        if
            let outputImage = generator.outputImage?.premultiplyingAlpha(),
            let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
        {
            let uiImage = UIImage(cgImage: cgImage)
            return Image(uiImage: uiImage)
        } else {
            return nil
        }
    }
    
    func generateCodabar(
        text: String,
        targetWidth: Int = 800,
        height: Int = 100,
        module: Int = 2,          // base (narrow) module width in pixels
        wideRatio: Int = 3,       // wide = ratio * module
        quietZoneModules: Int = 10
    ) -> Image? {
        guard let ui = CodabarRenderer.render(
            text: text,
            targetWidth: targetWidth,
            height: height,
            module: module,
            wideRatio: wideRatio,
            quietZoneModules: quietZoneModules
        )
        else { return nil }
        return Image(uiImage: ui)
    }
    
    func generateAztec(text: String) -> Image? {
        let generator = CIFilter.aztecCodeGenerator()
        generator.message = Data(text.utf8)
        
        if
            let outputImage = generator.outputImage?.premultiplyingAlpha(),
            let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
        {
            let uiImage = UIImage(cgImage: cgImage)
            return Image(uiImage: uiImage)
        } else {
            return nil
        }
    }
    
    func generatePDF417(text: String) -> Image? {
        let generator = CIFilter.pdf417BarcodeGenerator()
        generator.message = Data(text.utf8)
        generator.minHeight = 100
        
        if
            let outputImage = generator.outputImage?.premultiplyingAlpha(),
            let cgImage = context.createCGImage(outputImage, from: outputImage.extent)
        {
            let uiImage = UIImage(cgImage: cgImage)
            return Image(uiImage: uiImage)
        } else {
            return nil
        }
    }
    
    // ZXing Methods to be replaced
//    func generateCode39(text: String) -> Image? {
//        let writer = ZXCode39Writer()
//        do {
//            let result = try writer.encode(text, format: kBarcodeFormatCode39, width: 800, height: 100)
//            let cgImage = ZXImage(matrix: result).cgimage
//            if let cgImage = cgImage {
//                let uiImage = UIImage(cgImage: cgImage)
//                return Image(uiImage: uiImage).resizable().interpolation(.none)
//            }
//            else { return nil }
//        }
//        catch { return nil }
//    }
//    
//    func generateCode93(text: String) -> Image? {
//        let writer = ZXMultiFormatWriter()
//        do {
//            let result = try writer.encode(text, format: kBarcodeFormatCode93, width: 800, height: 100)
//            let cgImage = ZXImage(matrix: result).cgimage
//            if let cgImage = cgImage {
//                let uiImage = UIImage(cgImage: cgImage)
//                return Image(uiImage: uiImage)
//            }
//            else { return nil }
//        }
//        catch { return nil }
//    }
//    
//    func generateEAN8(text: String) -> Image? {
//        let writer = ZXEAN8Writer()
//        do {
//            let result = try writer.encode(text, format: kBarcodeFormatEan8, width: 800, height: 100)
//            let cgImage = ZXImage(matrix: result).cgimage
//            if let cgImage = cgImage {
//                let uiImage = UIImage(cgImage: cgImage)
//                return Image(uiImage: uiImage)
//            }
//            else { return nil }
//        }
//        catch { return nil }
//    }
//    
//    func generateEAN13(text: String) -> Image? {
//        let writer = ZXEAN13Writer()
//        do {
//            let result = try writer.encode(text, format: kBarcodeFormatEan13, width: 800, height: 100)
//            let cgImage = ZXImage(matrix: result).cgimage
//            if let cgImage = cgImage {
//                let uiImage = UIImage(cgImage: cgImage)
//                return Image(uiImage: uiImage)
//            }
//            else { return nil }
//        }
//        catch { return nil }
//    }
//    
//    func generateITF(text: String) -> Image? {
//        let writer = ZXITFWriter()
//        do {
//            let result = try writer.encode(text, format: kBarcodeFormatITF, width: 800, height: 100)
//            let cgImage = ZXImage(matrix: result).cgimage
//            if let cgImage = cgImage {
//                let uiImage = UIImage(cgImage: cgImage)
//                return Image(uiImage: uiImage)
//            }
//            else { return nil }
//        }
//        catch { return nil }
//    }
//    
//    func generateUPCA(text: String) -> Image? {
//        let writer = ZXUPCAWriter()
//        do {
//            let result = try writer.encode(text, format: kBarcodeFormatUPCA, width: 800, height: 100)
//            let cgImage = ZXImage(matrix: result).cgimage
//            if let cgImage = cgImage {
//                let uiImage = UIImage(cgImage: cgImage)
//                return Image(uiImage: uiImage).resizable().interpolation(.none)
//            }
//            else { return nil }
//        }
//        catch { return nil }
//    }
//    
//    func generateUPCE(text: String) -> Image? {
//        let writer = ZXUPCEWriter()
//        do {
//            let result = try writer.encode(text, format: kBarcodeFormatUPCE, width: 800, height: 100)
//            let cgImage = ZXImage(matrix: result).cgimage
//            if let cgImage = cgImage {
//                let uiImage = UIImage(cgImage: cgImage)
//                return Image(uiImage: uiImage)
//            }
//            else { return nil }
//        }
//        catch { return nil }
//    }
//    
//    
//    
//    func generateDataMatrix(text: String) -> Image? {
//        let writer = ZXDataMatrixWriter()
//        do {
//            let result = try writer.encode(text, format: kBarcodeFormatDataMatrix, width: 800, height: 800)
//            let cgImage = ZXImage(matrix: result).cgimage
//            if let cgImage = cgImage {
//                let uiImage = UIImage(cgImage: cgImage)
//                return Image(uiImage: uiImage)
//            }
//            else { return nil }
//        }
//        catch { return nil }
//    }
//    
//    func generateQR(text: String) -> Image? {
//        let writer = ZXQRCodeWriter()
//        do {
//            let result = try writer.encode(text, format: kBarcodeFormatQRCode, width: 100, height: 100)
//            let cgImage = ZXImage(matrix: result).cgimage
//            if let cgImage = cgImage {
//                let uiImage = UIImage(cgImage: cgImage)
//                return Image(uiImage: uiImage)
//            }
//            else { return nil }
//        }
//        catch { return nil }
//    }
    
    // Temporary fills for ZXing replacement work
    func generateCode39(text: String) -> Image? {
        Image(systemName: "exclamationmark.triangle")
    }
    
    func generateCode93(text: String) -> Image? {
        Image(systemName: "exclamationmark.triangle")
    }
    
    func generateEAN8(text: String) -> Image? {
        Image(systemName: "exclamationmark.triangle")
    }
    
    func generateEAN13(text: String) -> Image? {
        Image(systemName: "exclamationmark.triangle")
    }
    
    func generateITF(text: String) -> Image? {
        Image(systemName: "exclamationmark.triangle")
    }
    
    func generateUPCA(text: String) -> Image? {
        Image(systemName: "exclamationmark.triangle")
    }
    
    func generateUPCE(text: String) -> Image? {
        Image(systemName: "exclamationmark.triangle")
    }
    
    func generateDataMatrix(text: String) -> Image? {
        Image(systemName: "exclamationmark.triangle")
    }
}
#else
extension BarcodeImageView {
    func generateCodabar(text: String) -> Image? {
        Image(systemName: "exclamationmark.triangle")
    }
    
    func generateCode39(text: String) -> Image? {
        Image(systemName: "exclamationmark.triangle")
    }
    
    func generateCode93(text: String) -> Image? {
        Image(systemName: "exclamationmark.triangle")
    }
    
    func generateCode128(text: String) -> Image? {
        Image(systemName: "exclamationmark.triangle")
    }
    
    func generateQRCode(text: String) -> Image? {
        Image(systemName: "exclamationmark.triangle")
    }
    
    func generateEAN8(text: String) -> Image? {
        Image(systemName: "exclamationmark.triangle")
    }
    
    func generateEAN13(text: String) -> Image? {
        Image(systemName: "exclamationmark.triangle")
    }
    
    func generateITF(text: String) -> Image? {
        Image(systemName: "exclamationmark.triangle")
    }
    
    func generateUPCA(text: String) -> Image? {
        Image(systemName: "exclamationmark.triangle")
    }
    
    func generateUPCE(text: String) -> Image? {
        Image(systemName: "exclamationmark.triangle")
    }
    
    func generateAztec(text: String) -> Image? {
        Image(systemName: "exclamationmark.triangle")
    }
    
    func generateDataMatrix(text: String) -> Image? {
        Image(systemName: "exclamationmark.triangle")
    }
    
    func generatePDF417(text: String) -> Image? {
        Image(systemName: "exclamationmark.triangle")
    }
    
}
#endif

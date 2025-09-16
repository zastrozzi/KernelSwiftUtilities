//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 18/05/2025.
//

import Foundation
import AVFoundation
import SwiftUI

extension KernelAppUtils.CodeScanner {
    public struct CodeScannerView: UIViewControllerRepresentable {
        public let codeTypes: [AVMetadataObject.ObjectType]
        public let scanMode: ScanMode
        public let manualSelect: Bool
        public let scanInterval: Double
        public let showViewfinder: Bool
        public let requiresPhotoOutput: Bool
        public var simulatedData = ""
        public var shouldVibrateOnSuccess: Bool
        public var isTorchOn: Bool
        public var isPaused: Bool
        public var isGalleryPresented: Binding<Bool>
        public var videoCaptureDevice: AVCaptureDevice?
        public var completion: (Result<ScanResult, ScanError>) -> Void
        
        public init(
            codeTypes: [AVMetadataObject.ObjectType],
            scanMode: ScanMode = .once,
            manualSelect: Bool = false,
            scanInterval: Double = 2.0,
            showViewfinder: Bool = false,
            requiresPhotoOutput: Bool = true,
            simulatedData: String = "",
            shouldVibrateOnSuccess: Bool = true,
            isTorchOn: Bool = false,
            isPaused: Bool = false,
            isGalleryPresented: Binding<Bool> = .constant(false),
            videoCaptureDevice: AVCaptureDevice? = AVCaptureDevice.bestForVideo,
            completion: @escaping (Result<ScanResult, ScanError>) -> Void
        ) {
            self.codeTypes = codeTypes
            self.scanMode = scanMode
            self.manualSelect = manualSelect
            self.showViewfinder = showViewfinder
            self.requiresPhotoOutput = requiresPhotoOutput
            self.scanInterval = scanInterval
            self.simulatedData = simulatedData
            self.shouldVibrateOnSuccess = shouldVibrateOnSuccess
            self.isTorchOn = isTorchOn
            self.isPaused = isPaused
            self.isGalleryPresented = isGalleryPresented
            self.videoCaptureDevice = videoCaptureDevice
            self.completion = completion
        }
        
        public func makeUIViewController(context: Context) -> ScannerViewController {
            return ScannerViewController(showViewfinder: showViewfinder, parentView: self)
        }
        
        public func updateUIViewController(_ uiViewController: ScannerViewController, context: Context) {
            uiViewController.parentView = self
            uiViewController.updateViewController(
                isTorchOn: isTorchOn,
                isGalleryPresented: isGalleryPresented.wrappedValue,
                isManualCapture: scanMode.isManual,
                isManualSelect: manualSelect
            )
        }
        
    }
    
    
}

@available(macCatalyst 14.0, *)
extension KernelAppUtils.CodeScanner.CodeScannerView {
    
    @available(*, deprecated, renamed: "requiresPhotoOutput")
    public var requirePhotoOutput: Bool {
        requiresPhotoOutput
    }
}

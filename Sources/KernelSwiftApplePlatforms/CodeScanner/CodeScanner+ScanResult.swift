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
    public struct ScanResult {
        public let string: String
        public let type: AVMetadataObject.ObjectType
        public let image: KSNativeImage?
        public let corners: [CGPoint]
    }
}

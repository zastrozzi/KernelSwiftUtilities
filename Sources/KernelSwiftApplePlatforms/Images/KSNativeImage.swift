//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 31/10/2025.
//

import Foundation
import SwiftUI

#if os(macOS)
import AppKit
public typealias KSNativeImage = NSImage
#else
import UIKit
public typealias KSNativeImage = UIImage
#endif

extension Image {
    public init(nativeImage: KSNativeImage) {
        #if os(macOS)
        self = .init(nsImage: nativeImage)
        #else
        self = .init(uiImage: nativeImage)
        #endif
    }
}

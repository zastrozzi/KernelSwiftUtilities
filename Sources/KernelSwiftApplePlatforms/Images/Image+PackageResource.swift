//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 15/01/2025.
//

import SwiftUI

extension Image {
    public init(packageResource name: String, ofType type: String, bundle: Bundle) {
        #if canImport(UIKit)
        guard let path = bundle.path(forResource: name, ofType: type),
              let image = UIImage(contentsOfFile: path) else {
            self.init(name)
            return
        }
        self.init(uiImage: image)
        #elseif canImport(AppKit)
        guard let path = bundle.path(forResource: name, ofType: type),
              let image = NSImage(contentsOfFile: path) else {
            self.init(name)
            return
        }
        self.init(nsImage: image)
        #else
        self.init(name)
        #endif
    }
}

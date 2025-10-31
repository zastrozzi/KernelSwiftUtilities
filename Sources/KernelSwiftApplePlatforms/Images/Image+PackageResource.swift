//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 15/01/2025.
//

import SwiftUI

extension Image {
    public init(packageResource name: String, ofType type: String, bundle: Bundle) {
        guard let path = bundle.path(forResource: name, ofType: type),
              let image = KSNativeImage(contentsOfFile: path) else {
            self.init(name)
            return
        }
        self.init(nativeImage: image)
    }
}

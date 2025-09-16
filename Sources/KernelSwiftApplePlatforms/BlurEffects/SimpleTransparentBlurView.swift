//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 02/09/2023.
//

import Foundation
import SwiftUI

#if os(iOS)
import UIKit

public struct SimpleTransparentBlurView: UIViewRepresentable {
    public var removingFilters: Bool = false
    
    
    public func makeUIView(context: Context) -> UIVisualEffectView {
        let v = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
        return v
    }
    
    public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        DispatchQueue.main.async {
            if let backdropLayer = uiView.layer.sublayers?.first {
                if removingFilters {
                    backdropLayer.filters = []
                } else {
                    backdropLayer.filters?.removeAll(where: { filter in
                        String(describing: filter) != "gaussianBlur"
                    })
                }
            }
        }
    }
}
#endif

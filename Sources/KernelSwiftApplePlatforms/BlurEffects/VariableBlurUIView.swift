//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 02/09/2023.
//

//import Foundation
//import SwiftUI
//import VariableBlurEffect
//
//#if os(iOS)
//import UIKit
//
//public class VariableBlurUIView: UIVisualEffectView {
//    public init(gradientMask: UIImage, maxBlurRadius: CGFloat = 20) {
//        super.init(effect: UIBlurEffect(style: .regular))
//        let variableBlur = CAFilter.filter(withType: "variableBlur") as! NSObject
//        
//        guard let gradientImageRef = gradientMask.cgImage else {
//            preconditionFailure("Could not decode gradient")
//        }
//        
//        variableBlur.setValue(maxBlurRadius, forKey: "inputRadius")
//        variableBlur.setValue(gradientImageRef, forKey: "inputMaskImage")
//        variableBlur.setValue(true, forKey: "inputNormalizeEdges")
//        
//        let tintOverlay = subviews[1]
//        tintOverlay.alpha = 0
//        let backdropLayer = subviews.first?.layer
//        backdropLayer?.filters = [variableBlur]
//    }
//    
//    required public init?(coder: NSCoder) {
//        preconditionFailure("init(coder) not implemented")
//    }
//}
//
//public struct VariableBlurView: UIViewRepresentable {
//    public typealias UIViewType = VariableBlurUIView
//    
//    public init() {}
//    
//    public func makeUIView(context: Context) -> VariableBlurUIView {
//        VariableBlurUIView(gradientMask: UIImage(named: "alpha-gradient", in: .module, with: nil)!)
//    }
//    
//    public func updateUIView(_ uiView: VariableBlurUIView, context: Context) {
//        // No-op
//    }
//}
//
//#endif

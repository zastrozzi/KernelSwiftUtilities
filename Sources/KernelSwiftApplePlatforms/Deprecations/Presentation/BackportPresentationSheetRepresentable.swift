//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/09/2022.
//

import Foundation
import SwiftUI

#if os(iOS)
import UIKit

@available(iOS 15, *)
public struct BackportPresentationSheetRepresentable: UIViewControllerRepresentable {
    
    let detents: Set<BackportPresentationDetent>
    let selection: Binding<BackportPresentationDetent>?
    let largestUndimmed: BackportPresentationDetent?
    
    public func makeUIViewController(context: Context) -> BackportPresentationSheetController {
        BackportPresentationSheetController(detents: detents, selection: selection, largestUndimmed: largestUndimmed)
    }
    
    public func updateUIViewController(_ controller: BackportPresentationSheetController, context: Context) {
        controller.update(detents: detents, selection: selection, largestUndimmed: largestUndimmed)
    }
}
#endif

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

public struct BackportPresentationInteractiveDismissDisabledRepresentable: UIViewControllerRepresentable {
    let isModal: Bool
    let onAttempt: (() -> Void)?
    
    public func makeUIViewController(context: Context) -> BackportPresentationInteractiveDismissDisabledController {
        BackportPresentationInteractiveDismissDisabledController(isModal: isModal, onAttempt: onAttempt)
    }
    
    public func updateUIViewController(_ controller: BackportPresentationInteractiveDismissDisabledController, context: Context) {
        controller.update(isModal: isModal, onAttempt: onAttempt)
    }
}
#endif

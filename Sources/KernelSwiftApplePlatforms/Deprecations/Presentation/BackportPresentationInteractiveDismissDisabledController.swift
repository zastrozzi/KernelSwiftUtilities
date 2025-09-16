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

public final class BackportPresentationInteractiveDismissDisabledController: UIViewController, UIAdaptivePresentationControllerDelegate {
    var isModal: Bool
    var onAttempt: (() -> Void)?
    nonisolated(unsafe) weak var _delegate: UIAdaptivePresentationControllerDelegate?
    
    public init(isModal: Bool, onAttempt: (() -> Void)?) {
        self.isModal = isModal
        self.onAttempt = onAttempt
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
    
    public override func responds(to aSelector: Selector!) -> Bool {
        if super.responds(to: aSelector) { return true }
        if _delegate?.responds(to: aSelector) ?? false { return true }
        return false
    }
    
    public override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if super.responds(to: aSelector) { return self }
        return _delegate
    }
    
    public override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        
        if let controller = parent?.presentationController {
            if controller.delegate !== self {
                _delegate = controller.delegate
                controller.delegate = self
            }
        }
        
        update(isModal: isModal, onAttempt: onAttempt)
    }
    
    public func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        onAttempt?()
    }
    
    public func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        parent?.isModalInPresentation == false
    }
    
    func update(isModal: Bool, onAttempt: (() -> Void)?) {
        self.isModal = isModal
        self.onAttempt = onAttempt
        
        parent?.isModalInPresentation = isModal
    }
}
#endif

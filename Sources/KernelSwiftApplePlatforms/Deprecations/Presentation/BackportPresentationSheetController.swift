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
public final class BackportPresentationSheetController: UIViewController, UISheetPresentationControllerDelegate {
    
    
    var detents: Set<BackportPresentationDetent>
    var selection: Binding<BackportPresentationDetent>?
    var largestUndimmed: BackportPresentationDetent?
    nonisolated(unsafe) weak var _delegate: UISheetPresentationControllerDelegate?
    
    init(detents: Set<BackportPresentationDetent>, selection: Binding<BackportPresentationDetent>?, largestUndimmed: BackportPresentationDetent?) {
        self.detents = detents
        self.selection = selection
        self.largestUndimmed = largestUndimmed
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
    
    public override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if let controller = parent?.sheetPresentationController {
            if controller.delegate !== self {
                _delegate = controller.delegate
                controller.delegate = self
            }
        }
        
        update(detents: detents, selection: selection, largestUndimmed: largestUndimmed)
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
    
    func update(detents: Set<BackportPresentationDetent>, selection: Binding<BackportPresentationDetent>?, largestUndimmed: BackportPresentationDetent?) {
        self.detents = detents
        self.selection = selection
        self.largestUndimmed = largestUndimmed
        
        if let controller = parent?.sheetPresentationController {
            controller.animateChanges {
                controller.detents = detents.sorted().map {
                    switch $0 {
                    case .medium: return .medium()
                    default: return .large()
                    }
                }
                
                controller.largestUndimmedDetentIdentifier = largestUndimmed.flatMap { .init(rawValue: $0.id.rawValue) }
                
                if let selection = selection {
                    controller.selectedDetentIdentifier = .init(selection.wrappedValue.id.rawValue)
                }
                
                controller.prefersScrollingExpandsWhenScrolledToEdge = true
            }
            
            UIView.animate(withDuration: 0.25) {
                if let undimmed = largestUndimmed {
                    controller.presentingViewController.view.tintAdjustmentMode = (selection?.wrappedValue ?? .large) >= undimmed ? .automatic : .normal
                } else {
                    controller.presentingViewController.view.tintAdjustmentMode = .automatic
                }
            }
        }
    }
    
    public func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        guard
            let selection = selection,
            let id = sheetPresentationController.selectedDetentIdentifier?.rawValue,
            selection.wrappedValue.id.rawValue != id
        else { return }
        
        selection.wrappedValue = .init(id: .init(rawValue: id))
    }
}
#endif

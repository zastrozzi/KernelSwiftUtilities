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

public extension View {
    
    @ViewBuilder
    @available(iOS 15, *)
    func backportInteractiveDismissDisabled(_ isDisabled: Bool = true) -> some View {
        self.background(BackportPresentationInteractiveDismissDisabledRepresentable(isModal: isDisabled, onAttempt: nil))
    }
    
    @ViewBuilder
    @available(iOS 15, *)
    func backportInteractiveDismissDisabled(_ isDisabled: Bool = true, onAttempt: @escaping () -> Void) -> some View {
        self.background(BackportPresentationInteractiveDismissDisabledRepresentable(isModal: isDisabled, onAttempt: onAttempt))
    }
}
#endif

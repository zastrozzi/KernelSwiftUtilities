//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 06/03/2025.
//

import SwiftUI

extension View {
    @ViewBuilder
    public func sheetPresentation<Sheet, Content>(item: Binding<SheetPresentationValue?>, as wrapped: Sheet.Type, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping (Sheet) -> Content) -> some View where Sheet: SheetPresentable, Content : View {
        sheet(item: item, onDismiss: onDismiss) { selection in
            content(selection.wrappedValue as! Sheet)
        }
    }
    
    @ViewBuilder
    public func fullScreenCoverPresentation<Sheet, Content>(item: Binding<SheetPresentationValue?>, as wrapped: Sheet.Type, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping (Sheet) -> Content) -> some View where Sheet: SheetPresentable, Content : View {
        #if os(iOS)
        fullScreenCover(item: item, onDismiss: onDismiss) { selection in
            content(selection.wrappedValue as! Sheet)
        }
        #else
        self
        #endif
    }
}

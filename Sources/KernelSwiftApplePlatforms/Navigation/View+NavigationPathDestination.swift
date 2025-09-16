//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 06/03/2025.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder
    public func navigationPathDestination<D, C>(for data: D.Type, @ViewBuilder destination: @escaping (D) -> C) -> some View where D : NavigationPathItem, C : View {
        navigationDestination(for: WrappedNavigationPathItem.self) { selection in
            if let val = selection.wrappedItem as? D { destination(val) } else { EmptyView() }
        }
    }
    
    @ViewBuilder
    public func typedNavigationPathDestination<D, C>(for data: D.Type, @ViewBuilder destination: @escaping (D) -> C) -> some View where D : NavigationPathItem, C : View {
        navigationDestination(for: TypedNavigationPathItem<D>.self) { selection in
            //            if let val = selection.wrappedItem as? D { destination(val) } else { EmptyView() }
            destination(selection.wrappedItem)
        }
    }
}

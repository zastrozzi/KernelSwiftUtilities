//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/08/2022.
//

import Foundation
import SwiftUI

#if compiler(>=5.7)
extension View {
    @available(iOS, deprecated: 17.0, message: "Use SwiftUI Navigation API")
    public func backportNavigationDestination<D: Hashable, C: View>(for pathElementType: D.Type, @ViewBuilder destination builder: @escaping (D) -> C) -> some View {
        // MARK: - made DestinationBuilder return signature (any View) over AnyView which allows builder not to be wrapped in AnyView
        return modifier(DestinationBuilderModifier(typedDestinationBuilder: { builder($0) }))
    }
}
#endif

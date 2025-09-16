//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/08/2022.
//

import Foundation
import SwiftUI

#if compiler(>=5.7)
public struct NavigationRouter<Screen, RootView: View, FixedToolbarContent: ToolbarContent, CustomBackButton: View>: View {
    
    @EnvironmentObject var pathHolder: NavigationPathHolder
    @EnvironmentObject var destinationBuilder: DestinationBuilderHolder
    @Binding var screens: [Screen]
    
    private var isActiveBinding: Binding<Bool>
    
    let rootView: RootView
    var customBackButton: () -> CustomBackButton
    var toolbarContent: () -> FixedToolbarContent
    
//    public init(rootView: RootView, screens: Binding<[Screen]>) {
//        // MARK: - made isactivebinding non computed
//        self.isActiveBinding = screens.wrappedValue.isEmpty ? .constant(false) : .init(
//            get: { !screens.wrappedValue.isEmpty },
//            set: { isShowing in
//                guard !isShowing else { return }
//                guard !screens.wrappedValue.isEmpty else { return }
//                screens.wrappedValue = []
//            }
//        )
//        self.customBackButton = nil
//        self.rootView = rootView
//        self._screens = screens
//    }
    
    public init(@ViewBuilder rootView: () -> RootView, @ViewBuilder customBackButton: @escaping () -> CustomBackButton, @ToolbarContentBuilder toolbarContent: @escaping () -> FixedToolbarContent, screens: Binding<[Screen]>) {
        // MARK: - made isactivebinding non computed
        self.isActiveBinding = screens.wrappedValue.isEmpty ? .constant(false) : .init(
            get: { !screens.wrappedValue.isEmpty },
            set: { isShowing in
                guard !isShowing else { return }
                guard !screens.wrappedValue.isEmpty else { return }
                screens.wrappedValue = []
            }
        )
        
        self.rootView = rootView()
        self.customBackButton = customBackButton
        self.toolbarContent = toolbarContent
        self._screens = screens
    }
    
    public var body: some View {
        if #available(iOS 16.0, *) { preconditionFailure("iOS 16 Deprecated") }
        else {
            rootView.background(NavigationLink(destination: pushedScreens, isActive: isActiveBinding, label: EmptyView.init).hidden())
        }
    }
    
    var pushedScreens: some View {
        NavigationNode(allScreens: screens, truncateToIndex: { screens = Array(screens.prefix($0)) }, index: 0, fixedOverlayContent: toolbarContent, customBackButton: customBackButton)
            .environmentObject(pathHolder)
            .environmentObject(destinationBuilder)
            
    }
    
    
}
#endif

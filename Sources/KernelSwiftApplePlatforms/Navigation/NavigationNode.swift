//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/08/2022.
//

import Foundation
import SwiftUI

//protocol CustomizableNavigationNode {
//    associatedtype V: View
////    associatedtype M: View
//    associatedtype FixedToolbarContent: CustomizableToolbarContent
//    associatedtype CustomBackButton: View
//    func modify(_ builtView: AnyView) -> AnyView
////
//    var fixedOverlayContent: () -> FixedToolbarContent { get set }
//    var customBackButton: () -> CustomBackButton { get set }
//}
//
//extension CustomizableNavigationNode {
//    func modify(_ builtView: AnyView) -> AnyView {
//
//        return AnyView(Text(String(describing: CustomBackButton.self)))
//    }
//
//    @_disfavoredOverload
//    func modify(_ builtView: AnyView) -> AnyView where CustomBackButton == EmptyView {
//        return AnyView(Color.red)
//    }
//}

#if compiler(>=5.7)
struct NavigationNode<Screen, FixedToolbarContent: ToolbarContent, CustomBackButton: View>: View {

    
    @EnvironmentObject var pathHolder: NavigationPathHolder
    @EnvironmentObject var destinationBuilder: DestinationBuilderHolder
    
    private var isActiveBinding: Binding<Bool>
    
    let allScreens: [Screen]
    let truncateToIndex: (Int) -> Void
    let index: Int
    let screen: Screen?
    var fixedOverlayContent: () -> FixedToolbarContent
    var customBackButton: () -> CustomBackButton
    
    init(allScreens: [Screen], truncateToIndex: @escaping (Int) -> Void, index: Int, @ToolbarContentBuilder fixedOverlayContent: @escaping () -> FixedToolbarContent, @ViewBuilder customBackButton: @escaping () -> CustomBackButton) {
        // MARK: - made is active binding non computed
        self.isActiveBinding = .init(
            get: { allScreens.count > index + 1 },
            set: { isShowing in
                guard !isShowing else { return }
                guard allScreens.count > index + 1 else { return }
                truncateToIndex(index + 1)
            }
        )
        
        self.allScreens = allScreens
        self.truncateToIndex = truncateToIndex
        self.index = index
        self.screen = allScreens[safe: index]
        self.fixedOverlayContent = fixedOverlayContent
        self.customBackButton = customBackButton
    }
    
    var body: some View {
        if #available(iOS 16.0, *) { preconditionFailure("iOS 16 Deprecated") }
        else {
            if CustomBackButton.self == EmptyView.self && FixedToolbarContent.self == ToolbarItem<(), EmptyView>.self {
                DestinationBuilderView(data: screen)
                    .background(NavigationLink(destination: next, isActive: isActiveBinding, label: EmptyView.init).hidden())
            } else if CustomBackButton.self == EmptyView.self {
                DestinationBuilderView(data: screen)
                    .toolbar(content: fixedOverlayContent)
                    .background(NavigationLink(destination: next, isActive: isActiveBinding, label: EmptyView.init).hidden())
            } else if FixedToolbarContent.self == ToolbarItem<(), EmptyView>.self {
                DestinationBuilderView(data: screen)
                    .navigationBarCleared()
                    #if os(iOS)
                    .toolbar { ToolbarItem(placement: .navigationBarLeading, content: customBackButton) }
                    #endif
                    .background(NavigationLink(destination: next, isActive: isActiveBinding, label: EmptyView.init).hidden())
            } else {
                DestinationBuilderView(data: screen)
                    .toolbar(content: fixedOverlayContent)
                    .navigationBarCleared()
                    #if os(iOS)
                    .toolbar { ToolbarItem(placement: .navigationBarLeading, content: customBackButton) }
                    #endif
                    .background(NavigationLink(destination: next, isActive: isActiveBinding, label: EmptyView.init).hidden())
            }
        }
        
    }
    
    
    
    
    var next: some View {
        NavigationNode(allScreens: allScreens, truncateToIndex: truncateToIndex, index: index + 1, fixedOverlayContent: fixedOverlayContent, customBackButton: customBackButton)
            .environmentObject(pathHolder)
            .environmentObject(destinationBuilder)
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
#endif

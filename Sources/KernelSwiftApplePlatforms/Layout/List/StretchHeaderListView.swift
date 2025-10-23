//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 23/10/2025.
//

import Foundation
import SwiftUI

public struct StretchHeaderListView<
    TopContent: View,
    Header: View,
    ListContent: View
>: View {
    @ViewBuilder var topContent: (_ progress: CGFloat, _ safeAreaTop: CGFloat) -> TopContent
    @ViewBuilder var header: (_ progress: CGFloat) -> Header
    @ViewBuilder var content: () -> ListContent
    
    @State private var headerProgress: CGFloat = 0
    @State private var safeAreaTop: CGFloat = 0
    @State private var topContentHeight: CGFloat = 0
    private var isInNavigationView: Bool
    
    @Namespace var stretchHeaderListViewNamespace
    
    @Environment(\.colorScheme) var colorScheme
    
    public init(
        isInNavigationView: Bool = false,
        @ViewBuilder topContent: @escaping (_ progress: CGFloat, _ safeAreaTop: CGFloat) -> TopContent,
        @ViewBuilder header: @escaping (_ progress: CGFloat) -> Header,
        @ViewBuilder content: @escaping () -> ListContent
    ) {
        self.isInNavigationView = isInNavigationView
        self.topContent = topContent
        self.header = header
        self.content = content
    }
    
    
    public var body: some View {
        
        List {
            topContent(headerProgress, safeAreaTop)
                .onGeometryChange(for: CGFloat.self, of: {
                    $0.size.height
                }) { newValue in
                    topContentHeight = newValue
                }
                .configurableListRow()
            
            Section {
                content()
            } header: {
                header(headerProgress)
                    .foregroundStyle(foregroundColor)
                    .onGeometryChange(for: CGFloat.self, of: { [topContentHeight, stretchHeaderListViewNamespace] in
                        topContentHeight == .zero ? 0 : $0.frame(in: .named(stretchHeaderListViewNamespace)).minY
                    }, action: { newValue in
                        guard topContentHeight != .zero else { return }
                        let progress = (newValue - safeAreaTop) / topContentHeight
                        let cappedProgress = 1 - max(min(progress, 1), 0)
                        self.headerProgress = cappedProgress
                    })
                    .configurableListRow()
            }
        }
        
        .listStyle(.plain)
        #if os(iOS)
        .listRowSpacing(0)
        .listSectionSpacing(0)
        #endif
        .coordinateSpace(.named(stretchHeaderListViewNamespace))
        .if(isInNavigationView) { view in
            let safeAreaTopPadding: CGFloat = safeAreaTop * (1 - (headerProgress * 0.5))
            view
                .safeAreaPadding(.top, safeAreaTopPadding)
                .ignoresSafeArea(.all, edges: .top)
        }
        
        .onGeometryChange(for: CGFloat.self) {
            $0.safeAreaInsets.top
        } action: { newValue in
            safeAreaTop = newValue
        }
    }
    
    var foregroundColor: Color {
        colorScheme == .dark ? .white : .black
    }
}


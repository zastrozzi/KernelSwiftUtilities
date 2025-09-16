//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/09/2022.
//

import Foundation
import SwiftUI

#if os(iOS)
public extension View {
    
    @ViewBuilder
    @available(iOS, introduced: 15, deprecated: 17, message: "Presentation detents are only supported in iOS 15+")
    func backportPresentationDetents(_ detents: Set<BackportPresentationDetent>) -> some View {
        self.background(BackportPresentationSheetRepresentable(detents: detents, selection: nil, largestUndimmed: .large))
    }
    
    @ViewBuilder
    @available(iOS, introduced: 15, deprecated: 17, message: "Presentation detents are only supported in iOS 15+")
    func backportPresentationDetents(_ detents: Set<BackportPresentationDetent>, selection: Binding<BackportPresentationDetent>) -> some View {
        self.background(BackportPresentationSheetRepresentable(detents: detents, selection: selection, largestUndimmed: .large))
    }
    
    @ViewBuilder
    @available(iOS, introduced: 15, deprecated: 17, message: "Presentation detents are only supported in iOS 15+")
    func backportPresentationDetents(_ detents: Set<BackportPresentationDetent>, selection: Binding<BackportPresentationDetent>, largestUndimmedDetent: BackportPresentationDetent? = nil) -> some View {
        self.background(BackportPresentationSheetRepresentable(detents: detents, selection: selection, largestUndimmed: largestUndimmedDetent))
    }
}
#endif

#if os(macOS)
public extension View {
    
    @ViewBuilder
    @available(iOS, introduced: 15, deprecated: 17, message: "Presentation detents are only supported in iOS 15+")
    func backportPresentationDetents(_ detents: Set<BackportPresentationDetent>) -> some View {
        self
    }
    
    @ViewBuilder
    @available(iOS, introduced: 15, deprecated: 17, message: "Presentation detents are only supported in iOS 15+")
    func backportPresentationDetents(_ detents: Set<BackportPresentationDetent>, selection: Binding<BackportPresentationDetent>) -> some View {
        self
    }
    
    @ViewBuilder
    @available(iOS, introduced: 15, deprecated: 17, message: "Presentation detents are only supported in iOS 15+")
    func backportPresentationDetents(_ detents: Set<BackportPresentationDetent>, selection: Binding<BackportPresentationDetent>, largestUndimmedDetent: BackportPresentationDetent? = nil) -> some View {
        self
    }
}
#endif

#if DEBUG
@available(iOS, introduced: 15, deprecated: 17, message: "Presentation detents are only supported in iOS 15+")
struct BackportPresentationDetentsExampleView: View {
    @State private var sheetShown = false
    @State private var sheetSize: BackportPresentationDetent = .medium
    
    var body: some View {
        VStack {
            Button("Show Bottom Sheet") { sheetShown.toggle() }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $sheetShown) {
            Text("Bottom Sheet")
                .backportPresentationDetents([.medium, .large], selection: $sheetSize)
        }
    }
}

@available(iOS, introduced: 15, deprecated: 17, message: "Presentation detents are only supported in iOS 15+")
struct BackportPresentationDetentsExampleView_Previews: PreviewProvider {
    
    static var previews: some View {
        BackportPresentationDetentsExampleView()
    }
}
#endif

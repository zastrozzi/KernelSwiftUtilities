//
//  File.swift
//
//
//  Created by Jonathan Forbes on 31/08/2022.
//

import Foundation
import SwiftUI

#if compiler(>=5.7)
@available(iOS, deprecated: 17.0, message: "Use SwiftUI Navigation API")
public struct BackportNavigationStack<Root: View, CustomBackButton: View, FixedToolbarContent: ToolbarContent>: View {
    
    @StateObject var destinationBuilder = DestinationBuilderHolder()
    @State var ownedPath: [any Hashable] = []
    
    var unownedPath: Binding<[any Hashable]>?
    var root: () -> Root
    var customBackButton: () -> CustomBackButton
    var fixedToolbarContent: () -> FixedToolbarContent
    
    public var body: some View {
        NavigationView {
            NavigationRouter(rootView: root, customBackButton: customBackButton, toolbarContent: fixedToolbarContent, screens: (unownedPath ?? $ownedPath))
                .environmentObject(NavigationPathHolder((unownedPath ?? $ownedPath)))
                .environmentObject(destinationBuilder)
                .toolbar(content: fixedToolbarContent)
        }
        .onAppear {
            if CustomBackButton.self != EmptyView.self {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.resetNavigationGestureDelegate()
                }
            }
        }
#if os(iOS)
        .navigationViewStyle(.stack)
#endif
    }
}

@available(iOS, deprecated: 17.0, message: "Use SwiftUI Navigation API")
extension BackportNavigationStack where FixedToolbarContent == ToolbarItem<(),EmptyView>, CustomBackButton == EmptyView {
    public init(
        path: Binding<[any Hashable]>?,
        _ emptyFixedToolbarContent: FixedToolbarContent = ToolbarItem(content: EmptyView.init),
        _ emptyBackButton: CustomBackButton = EmptyView(),
        @ViewBuilder root: @escaping () -> Root
    ) {
        let ownedPath: State<[any Hashable]> = .init(wrappedValue: [])
        self._ownedPath = ownedPath
        self.unownedPath = path
        self.root = root
        self.customBackButton = { emptyBackButton }
        self.fixedToolbarContent = { emptyFixedToolbarContent }
    }
    
    public init(
        path: Binding<[any Hashable]>,
        _ emptyFixedToolbarContent: FixedToolbarContent = ToolbarItem(content: EmptyView.init),
        _ emptyBackButton: CustomBackButton = EmptyView(),
        @ViewBuilder root: @escaping () -> Root
    ) {
        let ownedPath: State<[any Hashable]> = .init(wrappedValue: [])
        self._ownedPath = ownedPath
        self.unownedPath = path
        self.root = root
        self.customBackButton = { emptyBackButton }
        self.fixedToolbarContent = { emptyFixedToolbarContent }
    }
}

@available(iOS, deprecated: 17.0, message: "Use SwiftUI Navigation API")
extension BackportNavigationStack where FixedToolbarContent == ToolbarItem<(),EmptyView> {
    public init(
        path: Binding<[any Hashable]>,
        _ emptyFixedToolbarContent: FixedToolbarContent = ToolbarItem(content: EmptyView.init),
        @ViewBuilder customBackButton: @escaping () -> CustomBackButton,
        @ViewBuilder root: @escaping () -> Root
    ) {
        let ownedPath: State<[any Hashable]> = .init(wrappedValue: [])
        self._ownedPath = ownedPath
        self.unownedPath = path
        self.root = root
        self.customBackButton = customBackButton
        self.fixedToolbarContent = { emptyFixedToolbarContent }
    }
}



@available(iOS, deprecated: 17.0, message: "Use SwiftUI Navigation API")
extension BackportNavigationStack {
    public init(
        path: Binding<[any Hashable]>?,
        @ToolbarContentBuilder fixedToolbarContent: @escaping () -> FixedToolbarContent,
        @ViewBuilder root: @escaping () -> Root
    ) where FixedToolbarContent: CustomizableToolbarContent, CustomBackButton == EmptyView {
        let ownedPath: State<[any Hashable]> = .init(wrappedValue: [])
        self._ownedPath = ownedPath
        self.unownedPath = path
        self.root = root
        self.customBackButton = { EmptyView() }
        self.fixedToolbarContent = fixedToolbarContent
    }
    
    public init(
        path: Binding<[any Hashable]>,
        @ToolbarContentBuilder fixedToolbarContent: @escaping () -> FixedToolbarContent,
        @ViewBuilder root: @escaping () -> Root
    ) where FixedToolbarContent: CustomizableToolbarContent, CustomBackButton == EmptyView {
        let ownedPath: State<[any Hashable]> = .init(wrappedValue: [])
        self._ownedPath = ownedPath
        self.unownedPath = path
        self.root = root
        self.customBackButton = { EmptyView() }
        self.fixedToolbarContent = fixedToolbarContent
    }
    
    public init(
        path: Binding<[any Hashable]>,
        @ViewBuilder customBackButton: @escaping () -> CustomBackButton,
        @ToolbarContentBuilder fixedToolbarContent: @escaping () -> FixedToolbarContent,
        @ViewBuilder root: @escaping () -> Root
    ) where FixedToolbarContent: CustomizableToolbarContent {
        let ownedPath: State<[any Hashable]> = .init(wrappedValue: [])
        self._ownedPath = ownedPath
        self.unownedPath = path
        self.root = root
        self.customBackButton = customBackButton
        self.fixedToolbarContent = fixedToolbarContent
    }
}

@available(iOS, deprecated: 17.0, message: "Use SwiftUI Navigation API")
extension BackportNavigationStack where FixedToolbarContent == ToolbarItem<(), EmptyView>, CustomBackButton == EmptyView {
    public init(
        @ViewBuilder root: @escaping () -> Root
    ) {
        self.init(path: nil, root: root)
    }
}

@available(iOS, deprecated: 17.0, message: "Use SwiftUI Navigation API")
extension BackportNavigationStack where FixedToolbarContent == ToolbarItem<(), EmptyView> {
    public init(
        path: Binding<BackportNavigationPath>,
        @ViewBuilder customBackButton: @escaping () -> CustomBackButton,
        @ViewBuilder root: @escaping () -> Root
    ) {
        let path = Binding(get: { path.wrappedValue.elements }, set: { path.wrappedValue.elements = $0 })
        self.init(path: path, customBackButton: customBackButton, root: root)
    }
}

@available(iOS, deprecated: 17.0, message: "Use SwiftUI Navigation API")
extension BackportNavigationStack where FixedToolbarContent == ToolbarItem<(), EmptyView>, CustomBackButton == EmptyView {
    public init(
        path: Binding<BackportNavigationPath>,
        @ViewBuilder root: @escaping () -> Root
    ) {
        let path = Binding(get: { path.wrappedValue.elements }, set: { path.wrappedValue.elements = $0 })
        self.init(path: path, root: root)
    }
    
    public init(
        path: Binding<BackportNavigationPath>,
        _ emptyBackButton: CustomBackButton = EmptyView(),
        _ emptyToolbarContent: FixedToolbarContent = ToolbarItem(content: EmptyView.init),
        @ViewBuilder root: @escaping () -> Root
    ) {
        let path = Binding(get: { path.wrappedValue.elements }, set: { path.wrappedValue.elements = $0 })
        self.init(path: path, root: root)
    }
}

@available(iOS, deprecated: 17.0, message: "Use SwiftUI Navigation API")
extension BackportNavigationStack {
    
    public init(
        path: Binding<BackportNavigationPath>,
        @ToolbarContentBuilder fixedToolbarContent: @escaping () -> FixedToolbarContent,
        @ViewBuilder root: @escaping () -> Root
    ) where FixedToolbarContent: CustomizableToolbarContent, CustomBackButton == EmptyView {
        let path = Binding(get: { path.wrappedValue.elements }, set: { path.wrappedValue.elements = $0 })
        self.init(path: path, fixedToolbarContent: fixedToolbarContent, root: root)
    }
    
    public init(
        path: Binding<BackportNavigationPath>,
        @ViewBuilder customBackButton: @escaping () -> CustomBackButton,
        @ToolbarContentBuilder fixedToolbarContent: @escaping () -> FixedToolbarContent,
        @ViewBuilder root: @escaping () -> Root
    ) where FixedToolbarContent: CustomizableToolbarContent {
        let path = Binding(get: { path.wrappedValue.elements }, set: { path.wrappedValue.elements = $0 })
        self.init(path: path, customBackButton: customBackButton, fixedToolbarContent: fixedToolbarContent, root: root)
    }
    
}

#if DEBUG
@available(iOS, deprecated: 17.0, message: "Use SwiftUI Navigation API")
struct BackportNavigationPathExampleView: View, @unchecked Sendable {
    @State var encodedPathData: Data?
    @State var path = BackportNavigationPath()
    @State var isOverlayShown: Bool = false
    
    var body: some View {
        BackportNavigationStack(
            path: $path.removeDuplicates(),
            customBackButton: { Button("Back") { path.removeLast(1) } },
            fixedToolbarContent: backToRootToolbar
        ) {
            HomeView(show99RedBalloons: show99RedBalloons)
                .backportNavigationDestination(for: NumberList.self, destination: { numberList in
                    NumberListView(numberList: numberList)
                })
                .backportNavigationDestination(for: Int.self, destination: { number in
                    NumberView(number: number, goBackToRoot: { path.removeLast(path.count) })
                })
                .backportNavigationDestination(for: EmojiVisualisation.self, destination: { visualisation in
                    EmojiView(visualisation: visualisation)
                })
        }
        .sheet(isPresented: $isOverlayShown, content: overlayView)
        
    }
    
    @ToolbarContentBuilder
    func backToRootToolbar() -> some CustomizableToolbarContent {
        ToolbarItem(id: "fixedcontent1", placement: .principal) {
            HStack {
                Button("Encode!", action: encodePath).disabled(try! encodedPathData == JSONEncoder().encode(path.codable))
                Button("Decode", action: { Task { await decodePath() }}).disabled(encodedPathData == nil)
                Image(systemName: "checkmark.circle").opacity(isOverlayShown ? 0 : 1)
            }
        }
#if os(iOS)
        ToolbarItem(id: "fixedcontent2", placement: .navigationBarTrailing) {
            Button("Show", action: { isOverlayShown.toggle() })
        }
#endif
    }
    
    @ViewBuilder
    func overlayView() -> some View {
        Text("Overlay")
    }
    
    func encodePath() {
        guard let codable = path.codable else {
            return
        }
        encodedPathData = try! JSONEncoder().encode(codable)
    }
    
//    nonisolated(unsafe)
    func decodePath() async {
        guard let encodedPathData = encodedPathData else {
            return
        }
        _ = try! JSONDecoder().decode(BackportNavigationPath.CodableRepresentation.self, from: encodedPathData)
        
//        await $path {
//            $0 = BackportNavigationPath(codable)
//        }
    }
    
    @preconcurrency
    func show99RedBalloons() async {
        /*
         NOTE: Pushing two screens in one update doesn't work in older versions of SwiftUI.
         The second screen would not be pushed onto the stack, leaving the data and UI out of sync.
         E.g., this would not work:
         path.append(99)
         path.append(EmojiVisualisation(emoji: "🎈", count: 99))
         But if you make those changes to the path argument of the `withDelaysIfUnsupported` closure,
         NavigationBackport will break your changes down into a series of smaller changes, which will
         then be applied one at a time, with delays in between. In this case, the first screen will be
         pushed after which the second will be pushed. On newer versions of SwiftUI the changes will be
         made in a single update.
         */
//        await $path.withDelaysIfUnsupported {
//            $0.append(99)
//            $0.append(EmojiVisualisation(emoji: "🎈", count: 99))
//        }
    }
}

@available(iOS, deprecated: 17.0, message: "Use SwiftUI Navigation API")
private struct HomeView: View {
    let show99RedBalloons: () async -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            BackportNavigationLink(value: NumberList(range: 0 ..< 100), label: { Text("Pick a number") })
            Button("99 Red balloons", action: { Task { await show99RedBalloons() } })
        }
    }
}

@available(iOS, deprecated: 17.0, message: "Use SwiftUI Navigation API")
private struct NumberListView: View {
    let numberList: NumberList
    var body: some View {
        List {
            ForEach(numberList.range, id: \.self) { number in
                BackportNavigationLink("\(number)", value: number)
            }
        }.navigationTitle("List")
    }
}

@available(iOS, deprecated: 17.0, message: "Use SwiftUI Navigation API")
private struct NumberView: View {
    @State var number: Int
    let goBackToRoot: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            Text("\(number)").font(.title)
            Stepper(
                label: { Text("\(number)") },
                onIncrement: { number += 1 },
                onDecrement: { number -= 1 }
            ).labelsHidden()
            BackportNavigationLink(
                value: number + 1,
                label: { Text("Show next number") }
            )
            BackportNavigationLink(
                value: EmojiVisualisation(emoji: "🐑", count: number),
                label: { Text("Visualise with sheep") }
            )
            Button("Go back to root", action: goBackToRoot)
        }.navigationTitle("\(number)")
    }
}

private struct EmojiView: View {
    let visualisation: EmojiVisualisation
    
    var body: some View {
        Text(visualisation.text)
            .navigationTitle("Visualise \(visualisation.count)")
    }
}

struct EmojiVisualisation: Hashable, Codable {
    let emoji: String
    let count: Int
    
    var text: String {
        Array(repeating: emoji, count: count).joined()
    }
}

struct NumberList: Hashable, Codable {
    let range: Range<Int>
}

@available(iOS, deprecated: 17.0, message: "Use SwiftUI Navigation API")
struct BackportNavigationPathExampleView_Previews: PreviewProvider {
    static var previews: some View {
        BackportNavigationPathExampleView()
    }
}
#endif

#endif

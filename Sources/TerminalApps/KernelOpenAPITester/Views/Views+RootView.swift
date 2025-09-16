//
//  Views+RootView.swift
//
//
//  Created by Jonathan Forbes on 18/11/2023.
//

import Foundation
import KernelSwiftTerminal
import KernelSwiftCommon

extension KernelOpenAPITester.Views {
    public struct RootView: KTView {
        @State var selectedScreen: RootScreen = .home
        
        enum RootScreen {
            case home
            case settings
        }
        
        public init() {}
        
        public var body: some KTView {
            KTVStack {
                KTHStack(alignment: .center, spacing: 3) {
                    KTButton("Home") {
                        selectedScreen = .home
                    }
                    KTButton("Settings") {
                        selectedScreen = .settings
                    }
                    Spacer()
                }
                switch selectedScreen {
                case .home: HomeView()
                case .settings: SettingsView()
                }
            }.padding()
        }
    }
    
    
    public struct HomeView: KTView {
        @ObservedObject var rootViewModel: RootTestModel = .init()
        @State var progress: Double = 0.0
        @State var firstName: String = ""
        @State var lastName: String = ""
        
        @KernelDI.Injected(\.focusService) var focusService
        
        public init() {}
        
        public var body: some KTView {
            KTVStack(alignment: .leading, spacing: 1) {
                TextLine(idx: 1)
                KTHStack(alignment: .center, spacing: 0) {
                    KTButton("Start Progress 10 sec") {
                        startProgress(seconds: 10)
                    }.background(.green)
                    KTSpacer()
                    KTButton("Start Progress 5 sec") {
                        startProgress(seconds: 5)
                    }.background(.green)
                    KTSpacer()
                    KTButton("Reset Progress") {
                        progress = 0
                        KernelDI.inject(\.logger).log(.id("Buttons"), level: .debug, "Reset Progress")
                    }.background(.red)
                    KTSpacer()
                    
                }
                KTVStack(alignment: .leading) {
                    KTText("Progress", focusable: false)
                    KernelSwiftTerminal.Views.ProgressView(progress: $progress).frame(minWidth: 30).padding(trailing: 5)
                }
                KTVStack(alignment: .leading) {
                    KTText("First Name", focusable: false)
                    KTTextField("What's your first name?") { res in
                        firstName = res
                        KernelDI.inject(\.logger).log(.id("Text Fields"), level: .debug, "First Name: \(res)")
                    }.background(.threesix).frame(minWidth: 30).padding(trailing: 2)
                }.padding(trailing: 3)
                KTVStack(alignment: .leading) {
                    KTText("Last Name", focusable: false)
                    KTTextField("What's your last name?") { res in
                        lastName = res
                        KernelDI.inject(\.logger).log(.id("Text Fields"), level: .debug, "Last Name: \(res)")
                    }.background(.threesix).frame(minWidth: 30).padding(trailing: 5)
                }
                KTHStack {
                    KTHStack(spacing: 1) {
                        KTText("FN:", focusable: false).bold()
                        KTText(firstName, focusable: false)
                        Spacer()
                        KTButton("Delete") {
                            firstName = ""
                            KernelDI.inject(\.logger).log(.id("Buttons"), level: .debug, "Reset First Name")
                        }.background(.red)
                    }
                    KTHStack(spacing: 1) {
                        KTText("LN:", focusable: false).bold()
                        KTText(lastName, focusable: false)
                        Spacer()
                        KTButton("Delete") {
                            lastName = ""
                            KernelDI.inject(\.logger).log(.id("Buttons"), level: .debug, "Reset Last Name")
                        }.background(.red)
                    }
                }
                
            }.padding().border(.green)
        }
        
        func startProgress(seconds: Int) {
            let frameMs = 20
            let ticks = Double(frameMs / seconds) / 1000
            Task {
                progress = 0
                try await Task.sleep(for: .milliseconds(frameMs))
                progress += ticks
                try await Task.sleep(for: .milliseconds(frameMs))
                while progress < 1 && progress > 0 {
                    progress += ticks
                    try await Task.sleep(for: .milliseconds(frameMs))
                }
                if progress >= 1 {
                    KernelDI.inject(\.logger).log(.id("Progress"), level: .debug, "Progress Done")
                }
            }
            KernelDI.inject(\.logger).log(.id("Buttons"), level: .debug, "Start Progress")
        }
    }
    
    public struct SettingsView: KTView {
        public init() {}
        
        public var body: some KTView {
            KTVStack(alignment: .leading, spacing: 1) {
                KTHStack {
                    KTText("Settings", focusable: false).bold()
                    KTSpacer()
                }
                KTSpacer()
                
            }.padding().border(.yellow)
        }
    }
    
    public struct TextLine: KTView {
        public var idx: Int
        
        public var body: some KTView {
            KTVStack(alignment: .leading) {
                KTHStack {
                    KTSpacer()
                    KTText("INPUT TEST - \(idx)").bold().foregroundColor(.red)
                }
                KTText("This is an input test. It contains buttons and text fields. All text items should be focusable apart from the labels for each text field. Buttons should produce a log output when selected, and text fields should produce a log output at reset when submitted.")
            }
        }
    }
}

extension KernelDI.Injector {
    var prime: PrimeService {
        get { self[PrimeService.Token.self] }
        set { self[PrimeService.Token.self] = newValue }
    }
}

final class PrimeService: KernelDI.Injectable {
    private let primeCache: KernelSwiftTerminal.SimpleMemoryCache<UUID, (KernelNumerics.BigInt, KernelNumerics.BigInt)>
    
    init() {
        primeCache = .init()
    }
    
    func replenishCache(count: Int = 0) {
        Task {
            KernelDI.inject(\.logger).log(level: .debug, "Cache Replenishing")
            let pairs = try await KernelNumerics.BigInt.Prime.probablePairs(256, total: count)
            for pair in pairs { primeCache.set(.init(), value: pair) }
            KernelDI.inject(\.logger).log(level: .debug, "Cache Replenished")
        }
    }
    
    func checkCache() {
        KernelDI.inject(\.logger).log(level: .debug, "Cache Count: \(primeCache.count)")
    }
    
    func clearCache() {
        primeCache.reset()
        KernelDI.inject(\.logger).log(level: .debug, "Cache Reset")
    }
}

class RootTestModel: ObservableObject {
    @Published var items: [RootItem] = []
    public init() {
        let fnKeySeq = KernelDI.inject(\.keyboardInputParser).fnKeySequence.debounce(for: .milliseconds(10))
        Task {
            for try await fnKey in fnKeySeq {
                DispatchQueue.main.async {
                    if fnKey == .fn5 { KernelDI.inject(\.prime).replenishCache(count: 10) }
                    if fnKey == .fn6 { KernelDI.inject(\.prime).checkCache() }
                    if fnKey == .fn7 { KernelDI.inject(\.prime).clearCache() }
                }
            }
        }
    }
}

public struct RootItem: Identifiable, Equatable, Hashable {
    public var id: UUID = .init()
    public var name: String = Self.sampleNames.randomElement()!
    
    public static var sampleNames: [String] = [
        "Aaren",
        "Aarika",
        "Abagael",
        "Abagail",
        "Abbe",
        "Abbey",
        "Abbi",
        "Abbie",
        "Abby",
        "Abbye",
        "Abigael",
        "Abigail",
        "Abigale",
        "Abra",
        "Ada",
        "Adah",
        "Adaline",
        "Adan",
        "Adara",
        "Adda",
        "Addi",
        "Addia",
        "Addie",
        "Addy",
        "Adel",
        "Adela",
        "Adelaida",
        "Adelaide",
        "Adele",
        "Adelheid",
        "Adelice",
        "Adelina",
        "Adelind",
        "Adeline",
        "Adella",
        "Adelle",
        "Adena",
        "Adey",
        "Adi"
    ]
}



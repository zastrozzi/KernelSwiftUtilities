//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 16/11/2023.
//

import Foundation
import KernelSwiftCommon
import Logging

#if canImport(Darwin) && os(macOS)
import AppKit
import SwiftUI

extension KernelSwiftTerminal.Accessory {
    final class AppDelegate: NSObject, NSApplicationDelegate {
        var window: NSWindow!
        let rootView: AnyView
        let title: String
        let onFinish: () -> Void
        
        init<V: View>(rootView: V, title: String, onFinish: @escaping () -> Void) {
            self.rootView = .init(rootView)
            self.title = title
            self.onFinish = onFinish
        }
        
        func applicationDidFinishLaunching(_ notification: Notification) {
            let window: NSWindow = .init(contentRect: .zero, styleMask: [.closable, .resizable, .titled], backing: .buffered, defer: true)
            window.contentViewController = NSHostingController(rootView: rootView)
//            window.makeKey()
            window.center()
            window.orderFrontRegardless()
            window.title = title
            self.window = window
            onFinish()
            
        }
    }
    
    struct TestView: View {
        @StateObject private var vm: RootTestModel = .init()
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Spacer()
                            vm.selectedArrowKey.symbol.font(.title).symbolRenderingMode(.hierarchical).bold()
                            vm.selectedFunctionKey.symbol.font(.title).symbolRenderingMode(.hierarchical).bold()
                        }
                    }.padding([.horizontal, .top], 15).padding(.bottom, 10)
                    HStack(alignment: .center) {
                        Text("Logs").fontWeight(.semibold)
                        Spacer()
                        Button("Remove All", systemImage: "trash", role: .destructive) {
                            vm.clearLogs()
                        }.buttonStyle(.borderless).padding(.trailing, 5)
                    }
                    .padding(10).background(.tertiary, in: .rect(cornerRadius: 10)).shadow(color: .black.opacity(0.15), radius: 10).padding(.horizontal, 10)
                    ScrollView {
                        LazyVStack(alignment: .leading) {
                            ForEach(vm.debugLogs.reversed(), id: \.id) { debugLog in
                                VStack(alignment: .leading) {
                                    Text(debugLog.message).font(.callout).bold()
                                    HStack {
                                        Text(debugLog.timestamp.formatted(date: .numeric, time: .standard)).font(.caption2).bold().foregroundStyle(.secondary)
                                        Text(debugLog.channels.map { $0.label }.joined(separator: " | ")).font(.caption2).foregroundStyle(.tertiary)
                                        Spacer()
                                    }.padding(5).background(.quinary, in: .rect(cornerRadius: 10))
                                }.padding(10).background(.quinary, in: .rect(cornerRadius: 10)).frame(minHeight: 10)
                            }
                        }.padding(5).padding(.horizontal, 10)
                    }
//                    Spacer()
                    
//                    if let hexString = Color.blue {
//                        Text("Color!")
//                            .font(.largeTitle)
//                            .fontWeight(.heavy)
//                            .fontDesign(.rounded)
//                    }
            }.background(.blue.opacity(0.4).gradient).frame(minWidth: 400, minHeight: 600)
            
        }
        
        
        class RootTestModel: ObservableObject {
            @Published var selectedFunctionKey: UInt8.StandardIn.FunctionKey = .none
            @Published var selectedArrowKey: UInt8.StandardIn.ArrowKey = .none
            var arrowIsVerticalFg: KTColor = .default
            var arrowIsVerticalBrdr: KTColor = .blue
            var arrowIsVertical: Bool = false
            @KernelDI.Injected(\.keyboardInputParser) var keyboardInputParser: KernelSwiftTerminal.Application.KeyboardInputKeyParser
            @KernelDI.Injected(\.logger) var logger: KernelSwiftTerminal.LoggingService
            
            @Published var debugLogs: [KernelSwiftTerminal.LoggingService.LogMessage] = []
            
            public init() {
                Task {
                    for try await log in logger.logs().debounce(for: .milliseconds(20)) {
                        DispatchQueue.main.async { withAnimation(.interactiveSpring) { self.debugLogs.append(log) } }
                    }
                }
                
                Task { for try await arrow in keyboardInputParser.arrowKeySequence.debounce(for: .milliseconds(10)) { 
                    DispatchQueue.main.async { self.selectedArrowKey = arrow } }
                }
                
                Task { for try await opt in keyboardInputParser.optKeySequence.debounce(for: .milliseconds(50)) {
                    logger.log(.id("Opt Seq"), level: .debug, opt.description) }
                }
//                
//                Task { for try await opt in keyboardInputParser.allSequence.debounce(for: .milliseconds(70)) {
//                    logger.log(.id("All Seq"), level: .debug, opt.debugDescription) }
//                }
                Task { for try await fnKey in keyboardInputParser.fnKeySequence.debounce(for: .milliseconds(10)) {
                    DispatchQueue.main.async { self.selectedFunctionKey = fnKey } }
                }
            }
            
            func clearLogs() { withAnimation(.interactiveSpring) { debugLogs.removeAll() } }
        }
    }
}

extension UInt8.StandardIn.FunctionKey {
    public var symbol: Image {
        switch self {
        case .fn1:  Image(systemName: "1.square")
        case .fn2:  Image(systemName: "2.square")
        case .fn3:  Image(systemName: "3.square")
        case .fn4:  Image(systemName: "4.square")
        case .fn5:  Image(systemName: "5.square")
        case .fn6:  Image(systemName: "6.square")
        case .fn7:  Image(systemName: "7.square")
        case .fn8:  Image(systemName: "8.square")
        case .fn9:  Image(systemName: "9.square")
        case .fn10: Image(systemName: "10.square")
        case .fn11: Image(systemName: "11.square")
        case .fn12: Image(systemName: "12.square")
        case .fn13: Image(systemName: "13.square")
        case .fn14: Image(systemName: "14.square")
        case .fn15: Image(systemName: "15.square")
        case .fn16: Image(systemName: "16.square")
        case .fn17: Image(systemName: "17.square")
        case .fn18: Image(systemName: "18.square")
        case .fn19: Image(systemName: "19.square")
        case .fn20: Image(systemName: "20.square")
        case .none: Image(systemName: "fn")
        }
    }
}

extension UInt8.StandardIn.ArrowKey {
    public var symbol: Image {
        switch self {
        case .up:       Image(systemName: "arrowkeys.up.filled")
        case .down:     Image(systemName: "arrowkeys.down.filled")
        case .right:    Image(systemName: "arrowkeys.right.filled")
        case .left:     Image(systemName: "arrowkeys.left.filled")
        case .none:     Image(systemName: "arrowkeys")
        }
    }
}
#endif


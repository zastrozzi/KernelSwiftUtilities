//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/10/2023.
//

import Foundation
import KernelSwiftCommon

#if canImport(Darwin) && os(macOS)
import AppKit
import SwiftUI
#endif

extension KernelSwiftTerminal {
//    @MainActor
    public class Application {
        private let node: ViewGraph.Node
        private var windows: SimpleMemoryCache<UUID, Window> = .init()
        @KernelDI.Injected(\.renderer) var renderer
        @KernelDI.Injected(\.viewGraph) var viewGraph
        @KernelDI.Injected(\.focusService) var focusService
        
        #if canImport(Darwin) && os(macOS)
        var accessory: Accessory.AppDelegate?
        #endif
        
        var lifecycle: KernelSwiftCommon.Concurrency.LifecycleBox = .init()
        
        var keyWindow: Window {
            get { windows.all().first! }
            set { windows.set(newValue.id, value: newValue) }
        }
        
        public init<I: ViewGraph.View>(rootView: I) {
            node = .init(view: Views.VStack(content: Views.HostingView(content: rootView)).view)
            let rootId = UUID()
            focusService.addRoot(rootId)
            node.build(rootId: rootId)
            
            var window = Window()
            window.addRootControl(node.control!)
            windows.set(window.id, value: window)
            renderer.initialise(window.rootLayer)
            viewGraph.initialise(window)
        }
        
        func startTerminal(withAccessory: Bool = false) {
            setInputMode()
            updateWindowSize()
            keyWindow.rootControl.layout(size: keyWindow.rootLayer.frame.size)
            renderer.draw()
            
//            runApp()
//            if !withAccessory {
            
            if !withAccessory {
                lifecycle.addSignalSource(SIGWINCH, queue: .main, handler: self.handleWindowSizeChange)
                lifecycle.addSignalSource(SIGINT, queue: .main, handler: self.stop)
                dispatchMain()
            }
            lifecycle.start()
        }
        
        public func run(withAccessory: Bool = false) {
            #if canImport(Darwin) && os(macOS)
                if withAccessory, #available(macOS 14.0, *) {
//                    print("with acc")
                    accessory = .init(rootView: Accessory.TestView(), title: "Testing", onFinish: {
                        self.startTerminal(withAccessory: withAccessory)
                    })
                    lifecycle.addSignalSource(SIGWINCH, queue: .main, handler: self.handleWindowSizeChange)
                    lifecycle.addSignalSource(SIGINT, queue: .global(), handler: self.stop)
                    MainActor.assumeIsolated {
                        let app = NSApplication.shared
                        app.delegate = accessory
                        app.run()
//                        dispatchMain()
                    }
                } else {
//                    print("no acc")
                    startTerminal()
                }
            #else
                startTerminal()
            #endif
        }
        
        private func setInputMode() {
            var tattr = termios()
            tcgetattr(STDIN_FILENO, &tattr)
            tattr.c_lflag &= ~tcflag_t(ECHO | ICANON)
            tcsetattr(STDIN_FILENO, TCSAFLUSH, &tattr);
        }
        
        private func update() {
            keyWindow.rootControl.layout(size: keyWindow.rootLayer.frame.size)
            renderer.update()
        }
        
        private func handleWindowSizeChange() {
//            print("CH")
            updateWindowSize()
            keyWindow.rootLayer.invalidate()
            update()
        }
        
        private func updateWindowSize(windowId: UUID? = nil) {
            var size = winsize()
            guard ioctl(STDOUT_FILENO, UInt(TIOCGWINSZ), &size) == 0,
                  size.ws_col > 0, size.ws_row > 0 else {
                assertionFailure("Could not get window size")
                return
            }
            keyWindow.rootLayer.frame.size = .init(width: Int(size.ws_col), height: Int(size.ws_row))
            renderer.setCache()
        }
        
        private func stop() {
            renderer.stop()
            lifecycle.shutdown()
            exit(0)
        }
        
    }
}

extension KernelSwiftTerminal {
    public typealias SimpleMemoryCache<K: Hashable, V: Sendable> = KernelSwiftCommon.SimpleMemoryCache<K, V, KernelSwiftCommon.Concurrency.Core.CriticalLock>
    public typealias TaggedMemoryCache<T: Hashable & CaseIterable & Equatable, K: Hashable & Equatable, V: Sendable> = KernelSwiftCommon.TaggedMemoryCache<T, K, V, KernelSwiftCommon.Concurrency.Core.CriticalLock>
}

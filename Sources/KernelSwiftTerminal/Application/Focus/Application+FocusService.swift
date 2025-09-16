//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 10/11/2023.
//

import Foundation
import KernelSwiftCommon
import AsyncAlgorithms
import Collections

extension KernelDI.Injector {
    public var focusService: KernelSwiftTerminal.Application.FocusService {
        get { self[KernelSwiftTerminal.Application.FocusService.Token.self] }
        set { self[KernelSwiftTerminal.Application.FocusService.Token.self] = newValue }
    }
}

extension KernelSwiftTerminal.Application {
    public final class FocusService: KernelDI.Injectable {
        private var channel = AsyncChannel<UInt8.StandardIn>()
        private var _window: KernelSwiftTerminal.Application.Window? = nil
        private var focusPath: Deque<UUID> = [] {
            didSet {
                let last = focusPath.last
                currentFocus = last
            }
        }
        
        @KernelDI.Injected(\.keyboardInputParser) var keyboardInputParser: KernelSwiftTerminal.Application.KeyboardInputKeyParser
        @KernelDI.Injected(\.logger) var logger: KernelSwiftTerminal.LoggingService

        var _currentFocusStream: AsyncChannel<UUID?> = .init()
        lazy var currentFocusStream: some TypedAsyncSequence<UUID?> = _currentFocusStream.broadcast()
        var controlRootId: UUID? = nil
        private var controlCache: KernelSwiftTerminal.SimpleMemoryCache<UUID, ControlChildrenMetadata> = .init()

        public init() {}

        var currentFocus: UUID? = nil {
            didSet {
                Task { await self._currentFocusStream.send(currentFocus) }
            }
        }
        
        func isCurrentFocus(_ id: UUID) -> Bool { id == currentFocus }
        
        public func addRoot(_ id: UUID) {
            if !controlCache.has(id) { controlCache.set(id, value: .init(id: id, isFocusable: false)) }
            controlRootId = id
            focusPath = [id]
        }
        
        public func add(_ id: UUID, to parentId: UUID, at index: Int, focusable: Bool) {
            if !controlCache.has(id) { controlCache.set(id, value: .init(id: id, isFocusable: focusable)) }
            else { controlCache.update(id) { $0.isFocusable = focusable } }
            if !controlCache.has(parentId) { controlCache.set(parentId, value: .init(id: parentId, isFocusable: focusable)) }
            controlCache.update(parentId) { meta in
                meta.insert(id, at: index)
            }
        }
        
        internal func nextFocusChild(_ id: [UUID]) -> [UUID]? {
            guard let meta = controlCache.get(id.last!) else { return nil }
            if meta.isFocusable { return id }
            return meta.childIds.sorted { $0.key < $1.key }.compactMap { el in
                nextFocusChild(id + [el.value])
            }.first
        }
        
        internal func nextFocusSibling(for ids: [UUID]? = nil, adding: Int = 1, withChild: Bool = false) -> [UUID]? {
            let ids = ids ?? .init(focusPath)
            guard let id = ids.last else { return nil }
            guard
                ids.count > adding,
                let parentMeta = controlCache.get(ids[ids.count - 2]),
                let currentKey = parentMeta.childIds.first(where: { $0.value == id })?.key,
                let nextSiblingId = parentMeta.childIds[currentKey + adding],
                let nextMeta = controlCache.get(nextSiblingId)
            else { return nil }
            if nextMeta.isFocusable {
                return [parentMeta.id, nextSiblingId]
            }
            else {
                if withChild {
                    if let nextChild = nextFocusChild([parentMeta.id, nextSiblingId]) { return nextChild }
                }
                return nextFocusSibling(adding: adding + 1, withChild: withChild)
            }
        }
        
        internal func prevFocusSibling(for ids: [UUID]? = nil, subtracting: Int = 1, withChild: Bool = false) -> [UUID]? {
            let ids = ids ?? .init(focusPath)
            guard let id = ids.last else { return nil }
            guard
                ids.count > subtracting,
                let parentMeta = controlCache.get(ids[ids.count - 2]),
                let currentKey = parentMeta.childIds.first(where: { $0.value == id })?.key,
                let prevSiblingId = parentMeta.childIds[currentKey - subtracting],
                let prevMeta = controlCache.get(prevSiblingId)
            else { return nil }
            if prevMeta.isFocusable {
                return [parentMeta.id, prevSiblingId]
            }
            else {
                if withChild { if let prevChild = nextFocusChild([parentMeta.id, prevSiblingId]) { return prevChild } }
                return prevFocusSibling(subtracting: subtracting + 1, withChild: withChild)
            }
        }
        
        internal func logCurrent(_ arrowDesc: String = "") {
            guard let currentFocus else { return }
            Task { logger.log(level: .debug, "\(arrowDesc) \(currentFocus)") }
        }
        
        public func remove(from parentId: UUID, at index: Int) {
            controlCache.update(parentId) { meta in
                meta.remove(at: index)
            }
        }
        
        func focusChild(_ id: UUID? = nil) {
            if let current = id ?? focusPath.last {
                if let meta = controlCache.get(current), let firstChild = meta.childIds[0] {
                    if let nextFocus = nextFocusChild([firstChild]) { self.focusPath.append(contentsOf: nextFocus.uniqued()) }
                    else if let nextFocusSibling = nextFocusSibling(withChild: true) {
                        self.focusPath.removeLast(self.focusPath.count - (self.focusPath.firstIndex(of: nextFocusSibling.first!) ?? 0))
                        self.focusPath.append(contentsOf: nextFocusSibling.uniqued())
                    }
                    else {
                        focusBack()
                        focusChild()
                    }
                }
            }
        }
        
        func focusBack(_ layerCount: Int = 1) {
            if self.focusPath.count > layerCount {
                self.focusPath.removeLast(layerCount)
            }
        }
        
        func focusPrevious() {
            guard focusPath.count > 1 else { return focusBack() }
            if let prevFocusSibling = prevFocusSibling(withChild: true) {
                self.focusPath.removeLast(self.focusPath.count - (self.focusPath.firstIndex(of: prevFocusSibling.first!) ?? 0))
                self.focusPath.append(contentsOf: prevFocusSibling.filter { !self.focusPath.contains($0) }.uniqued())
            } else {
                focusBack()
                focusPrevious()
            }
        }
        
        func focusNext() {
            guard focusPath.count > 1 else { return focusChild() }
            if let nextFocusSibling = nextFocusSibling(withChild: true) {
                self.focusPath.removeLast(self.focusPath.count - (self.focusPath.firstIndex(of: nextFocusSibling.first!) ?? 0))
                self.focusPath.append(contentsOf: nextFocusSibling.filter { !self.focusPath.contains($0) }.uniqued())
            } else {
                focusBack()
                focusNext()
            }
        }
        
        func noFocus() {}
        

        func start() {
            //        print("starting focuser")
            Task {
                for try await arrow in keyboardInputParser.arrowKeySequence.debounce(for: .milliseconds(30)) {
                    switch arrow {
                    case .up: focusPrevious()
                    case .down: focusNext()
                    case .right: focusNext()
                    case .left: focusPrevious()
                    case .none: noFocus()
                    }
                    if !arrow.description.isEmptyOrBlank { logCurrent(arrow.description) }
                }
            }
            
//            Task {
//                for try await
//            }
        }
    }
}

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
    public var altFocusService: KernelSwiftTerminal.Application.AltFocusService {
        get { self[KernelSwiftTerminal.Application.AltFocusService.Token.self] }
        set { self[KernelSwiftTerminal.Application.AltFocusService.Token.self] = newValue }
    }
}

extension KernelSwiftTerminal.Application {
    public final class AltFocusService: KernelDI.Injectable {
        public struct ControlChildrenMetadata {
            public var id: UUID
            public var isFocusable: Bool
            
            public init(id: UUID, isFocusable: Bool) {
                self.id = id
                self.isFocusable = isFocusable
            }
        }
        
        private var channel = AsyncChannel<UInt8.StandardIn>()
        private var _window: KernelSwiftTerminal.Application.Window? = nil
        private(set) var focusPath: Deque<UUID> = [] {
            didSet {
                let last = focusPath.last
                Task.detached { await self._currentFocusStream.send(last) }
            }
        }
        
        var _currentFocusStream: AsyncChannel<UUID?> = .init()
        lazy var currentFocusStream: some TypedAsyncSequence<UUID?> = _currentFocusStream.broadcast()
        var controlRootId: UUID? = nil
        private var controlCache: KernelSwiftTerminal.TaggedMemoryCache<CacheTag, UUID, ControlChildrenMetadata> = .init()
        
        public enum CacheTag: Hashable, CaseIterable, Equatable {
            public static var allCases: [KernelSwiftTerminal.Application.AltFocusService.CacheTag] = []
            
            case child(Int, UUID)
            case parent(UUID)
            
            func isChildAtIndex(_ idx: Int) -> Bool {
                guard case let .child(childIdx, _) = self else { return false }
                return childIdx == idx
            }
            
            var id: UUID {
                switch self {
                case let .child(_, id): id
                case let .parent(id): id
                }
            }
            
            var index: Int? {
                guard case let .child(childIdx, _) = self else { return nil }
                return childIdx
            }
            
            var isChild: Bool {
                guard case .child = self else { return false }
                return true
            }
            
            var isParent: Bool {
                guard case .parent = self else { return false }
                return true
            }
        }
        
        public init() {}
        
        var currentSiblings: [UUID] {
            if focusPath.count > 1 {
                controlCache.keys(for: .parent(focusPath[focusPath.count - 2]))
            } else { [] }
        }
        
        var currentFocus: UUID? { focusPath.last }
        
        func isCurrentFocus(_ id: UUID) -> Bool { id == currentFocus }
        
//        public func addRoot(_ id: UUID) {
//            if !controlCache.has(id) { controlCache.set(id, value: .init(id: id, isFocusable: false)) }
//            controlRootId = id
//            focusPath = [id]
//        }
//        
//        public func add(_ id: UUID, to parentId: UUID, at index: Int, focusable: Bool) {
//            if !controlCache.has(id) { controlCache.set(id, value: .init(id: id, isFocusable: focusable)) }
//            else { controlCache.update(id) { $0.isFocusable = focusable } }
//            if !controlCache.has(parentId) { controlCache.set(parentId, value: .init(id: parentId, isFocusable: focusable)) }
//            controlCache.setTag(id, tag: .parent(parentId))
//            controlCache.setTag(parentId, tag: .child(index, id))
//        }
//        
        internal func nextFocusChild(_ id: [UUID]) -> [UUID]? {
            guard let meta = controlCache.value(id.last!) else { return nil }
            if meta.isFocusable { return id }
            return controlCache.tags(for: meta.id).first(where: { tag in tag.isChildAtIndex(0)} ).map { nextFocusChild(id + [$0.id]) } ?? nil
//            return meta.childIds.sorted { $0.key < $1.key }.compactMap { el in
//                nextFocusChild(id + [el.value])
//            }.first
        }
//        
        internal func nextFocusSibling(for ids: [UUID]? = nil, adding: Int = 1, withChild: Bool = false) -> [UUID]? {
//            let ids = ids ?? .init(focusPath)
//            guard let id = ids.last else { return nil }
//            guard
//                ids.count > adding,
//                let parentMeta = controlCache.get(ids[ids.count - 2]),
//                let currentKey = parentMeta.childIds.first(where: { $0.value == id })?.key,
//                let nextSiblingId = parentMeta.childIds[currentKey + adding],
//                let nextMeta = controlCache.get(nextSiblingId)
//            else { return nil }
//            if nextMeta.isFocusable {
//                return [parentMeta.id, nextSiblingId]
//            }
//            else {
//                if withChild {
//                    if let nextChild = nextFocusChild([parentMeta.id, nextSiblingId]) { return nextChild }
//                }
//                return nextFocusSibling(adding: adding + 1, withChild: withChild)
//            }
            return nil
        }
//        
//        internal func previousFocusSibling(for id: UUID? = nil) -> UUID? {
//            let id = id ?? currentFocus
//            guard
//                focusPath.count > 1,
//                let id,
//                let parentMeta = controlCache.get(focusPath[focusPath.count - 2]),
//                let currentKey = parentMeta.childIds.first(where: { $0.value == id })?.key,
//                let prevSiblingId = parentMeta.childIds[currentKey - 1],
//                let prevMeta = controlCache.get(prevSiblingId)
//            else { return nil }
//            if prevMeta.isFocusable { return prevSiblingId }
//            else { return previousFocusSibling(for: prevSiblingId) }
//        }
//        
        internal func logCurrent(_ arrowDesc: String = "") {
            guard let currentFocus else { return }
//            let childMeta = controlCache.value(currentFocus)
            let childCount = controlCache.count(for: .parent(currentFocus))
            let siblingCount = currentSiblings.count
            KernelDI.inject(\.logger).log(level: .debug, "\(arrowDesc) \(currentFocus) | C:\(childCount) S:\(siblingCount)")
            //            Task {
            //                try await Task.sleep(for: .milliseconds(20))
            //                KernelDI.inject(\.logger).log(level: .debug, "\(focusPath)")
            //            }
        }
        
        public func remove(from parentId: UUID, at index: Int) {
            controlCache.removeTag(parentId) { tag in
                tag.isChildAtIndex(index)
            }
        }
        
        func focusChild(_ id: UUID? = nil) {
            if let current = id ?? focusPath.last {
                if let ch = controlCache.tags(for: current).first(where: { tag in
                    tag.isChildAtIndex(0)
                }) {
                    if let nextFocus = nextFocusChild([ch.id]) { focusPath.append(contentsOf: nextFocus) }
                    else if let nextFocusSibling = nextFocusSibling(withChild: true) {
                        focusBack(nextFocusSibling.count - 1)
                        focusPath.append(contentsOf: nextFocusSibling)
                    }
                    else {
                        focusBack()
                        focusChild()
                    }
                }
            }
        }
        
        func focusBack(_ layerCount: Int = 1) {
            if focusPath.count > layerCount {
                focusPath.removeLast(layerCount)
            }
        }
        
        func focusPrevious() {
            if
                focusPath.count > 1,
                let currentId = focusPath.last,
                let currentKey = controlCache.tags(where: { $0.id == currentId }).first?.index
            {
                if currentKey > 0, let nextSibling = controlCache.tags(for: focusPath[focusPath.count - 2]).first(where: { tag in tag.isChildAtIndex(currentKey - 1)} ) {
                    focusPath.removeLast()
                    focusPath.append(nextSibling.id)
                }
            }
        }
        
        func focusNext() {
            guard focusPath.count > 1 else { return focusChild() }
            if let nextFocusSibling = nextFocusSibling(withChild: true) {
                focusBack(nextFocusSibling.count - 1)
                focusPath.append(contentsOf: nextFocusSibling)
            } else {
                focusBack()
                focusNext()
            }
        }
        
        func noFocus() {}
        
        
        func start() {
            //        print("starting focuser")
            Task {
                for try await arrow in KernelDI.inject(\.keyboardInputParser).arrowKeySequence.debounce(for: .milliseconds(20)) {
                    switch arrow {
                    case .up: focusPrevious()
                    case .down: focusNext()
                    case .right: focusChild()
                    case .left: focusBack()
                    case .none: noFocus()
                    }
                    if !arrow.description.isEmptyOrBlank { logCurrent(arrow.description) }
                }
            }
        }
    }
}

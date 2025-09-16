//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 18/11/2023.
//

import Foundation

extension KernelSwiftTerminal.Application.FocusService {
    public struct ControlChildrenMetadata {
        public var id: UUID
        public var isFocusable: Bool
        public var childIds: [Int: UUID]
        
        public init(id: UUID, isFocusable: Bool, childIds: [Int: UUID] = [:]) {
            self.id = id
            self.isFocusable = isFocusable
            self.childIds = childIds
        }
        
        public mutating func insert(_ childId: UUID, at index: Int) {
            if childIds.count <= index { childIds[index] = childId }
            else {
                for i in index...childIds.count {
                    childIds[i + 1] = childIds[i]
                }
                childIds[index] = childId
            }
        }
        
        public mutating func remove(at index: Int) {
            guard childIds.count > index else { return }
            childIds[index] = nil
            for i in index..<childIds.count {
                childIds[i - 1] = childIds[i]
            }
        }
    }
    
    public enum ControlFocus: Identifiable {
        case leaf(Int, UUID)
        indirect case branch(Int, UUID, [ControlFocus])
        
        public var id: UUID {
            switch self {
            case let .leaf(_, uuid): uuid
            case let .branch(_, uuid, _): uuid
            }
        }
        
        public var index: Int {
            switch self {
            case let .leaf(idx, _): idx
            case let .branch(idx, _, _): idx
            }
        }
        
        public var children: [ControlFocus] {
            switch self {
            case .leaf: []
            case let .branch(_, _, chldn): chldn
            }
        }
    }
    
    enum FocusServiceError: Error {
        case indexNotFound
    }
}

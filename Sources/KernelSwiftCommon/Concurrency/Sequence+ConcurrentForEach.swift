//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 11/09/2023.
//

import Foundation

extension Sequence {
//    @MainActor
//    @preconcurrency
    public func concurrentForEach(priority: TaskPriority? = nil, _ operation: @escaping @Sendable (Element) async throws -> Void) async throws where Self.Element: Sendable {
            if #available(macOS 14.0, iOS 17.0, *) {
                do {
                    try await withThrowingDiscardingTaskGroup { group in
                        for el in self {
                            let element = el
                            let _ = group.addTaskUnlessCancelled(priority: priority) {
                                try await operation(element)
                            }
                        }
                    }
                } catch {
                    throw error
                }
            } else {
                // Fallback on earlier versions
                do {
                    var groupResult: Bool = true
                    try await withThrowingTaskGroup(of: Bool.self) { group in
                        self.forEach { element in
                            let _ = group.addTaskUnlessCancelled(priority: priority) {
                                do {
                                    try await operation(element)
                                    return true
                                } catch let error {
                                    throw error
                                }
                            }
                        }
                        for try await result in group {
                            if groupResult == true { groupResult = result }
                        }
                    }
                } catch {
                    throw error
                }
            }
        
    }
    
}

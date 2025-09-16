////
////  File.swift
////
////
////  Created by Jonathan Forbes on 29/03/2022.
////
//
//import Foundation
//
//extension Sequence {
//    public func asyncMap<T>(
//        _ transform: (Element) async throws -> T
//    ) async rethrows -> [T] {
//        var values = [T]()
//
//        for element in self {
//            try await values.append(transform(element))
//        }
//
//        return values
//    }
//    
//    public func asyncForEach(
//        _ operation: (Element) async throws -> Void
//    ) async rethrows {
//        for element in self {
//            try await operation(element)
//        }
//    }
//    
//    public func concurrentForEach(priority: TaskPriority? = nil, _ operation: @escaping @Sendable (Element) async throws -> Void) async throws {
//        if #available(macOS 14.0, iOS 17.0, *) {
//            do {
//                try await withThrowingDiscardingTaskGroup { group in
//                    for el in self {
//                        let _ = group.addTaskUnlessCancelled(priority: priority) {
//                            try await operation(el)
//                        }
//                    }
//                }
//            } catch {
//                throw error
//            }
//        } else {
//            // Fallback on earlier versions
//            do {
//                var groupResult: Bool = true
//                try await withThrowingTaskGroup(of: Bool.self) { group in
//                    self.forEach { element in
//                        let _ = group.addTaskUnlessCancelled(priority: priority) {
//                            do {
//                                try await operation(element)
//                                return true
//                            } catch {
////                                debugPrint("CONCURRENCY ERROR: \(error)")
//                                return false
//                            }
//                        }
////                        if !added {
////                            debugPrint("CONCURRENT FOR TASK CANCELLED")
////                        }
//                    }
//                    for try await result in group {
//                        if groupResult == true { groupResult = result }
//                    }
//                }
////                debugPrint("CONCURRENCY FOR EACH RESULT \(groupResult ? "Success" : "Fail")")
//            } catch {
//                throw error
//            }
//        }
//    }
//    
//    public func concurrentMap<T>(_ transform: @escaping (Element) async throws -> T) async rethrows -> [T] {
//        let tasks = map { element in
//            Task { try await transform(element) }
//        }
//        
//        return try await tasks.asyncMap { task in
//            try await task.value
//        }
//    }
//}

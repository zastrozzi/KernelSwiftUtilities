//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 14/02/2025.
//

import Foundation

public struct TaskPath: CustomStringConvertible, Sendable {
    @TaskLocal public static var current: TaskPath = .init()
    
    let path: String
    
    public init(
        path: String = ""
    ) {
        self.path = path
    }
    
    public static func with<T>(name: String, operation: () async throws -> T) async rethrows -> T {
        let path = current.path
        return try await $current.withValue(
            .init(path: path.isEmpty ? name : path + " > " + name),
            operation: operation
        )
    }
    
    public var description: String {
        "{Task \(path)}"
    }
}

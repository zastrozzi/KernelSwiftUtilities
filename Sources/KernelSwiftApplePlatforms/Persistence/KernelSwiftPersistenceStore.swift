//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 28/02/2022.
//

import CoreData
import Combine
import Foundation
import SwiftData
import KernelSwiftCommon

public protocol KernelSwiftPersistenceStore {
    typealias DBOperation<Result> = @Sendable (NSManagedObjectContext) throws -> Result
    
    func count<T>(_ fetchRequest: NSFetchRequest<T>) -> AnyPublisher<Int, Error>
    
    func fetch<T, V>(_ fetchRequest: NSFetchRequest<T>, map: @escaping @Sendable (T) throws -> V?) -> AnyPublisher<LazyList<V>, Error>
    
    func update<Result>(_ operation: @escaping DBOperation<Result>) -> AnyPublisher<Result, Error>
    
    @available(iOS 17, macOS 14.0, *)
    var modelContainer: ModelContainer { get set }
    
    @available(iOS 17, macOS 14.0, *)
    var defaultModelContext: ModelContext { get set }
    
    @available(iOS 17, macOS 14.0, *)
    func modelContext(for configName: String) -> ModelContext
    
}

extension KernelSwiftPersistenceStore {
    public func count<T>(_ fetchRequest: NSFetchRequest<T>) -> AnyPublisher<Int, Error> where T : NSFetchRequestResult {
        preconditionFailure("Not implemented")
    }
    
    public func fetch<T, V>(_ fetchRequest: NSFetchRequest<T>, map: @escaping @Sendable (T) throws -> V?) -> AnyPublisher<LazyList<V>, Error> where T : NSFetchRequestResult {
        preconditionFailure("Not implemented")
    }
    
    public func update<Result>(_ operation: @escaping DBOperation<Result>) -> AnyPublisher<Result, Error> {
        preconditionFailure("Not implemented")
    }
    
    @available(iOS 17, macOS 14.0, *)
    public var modelContainer: ModelContainer {
        get { preconditionFailure("Not implemented") }
        set { preconditionFailure("Not implemented") }
    }
    
    @available(iOS 17, macOS 14.0, *)
    public var defaultModelContext: ModelContext {
        get { preconditionFailure("Not implemented") }
        set { preconditionFailure("Not implemented") }
    }
    
    @available(iOS 17, macOS 14.0, *)
    public func modelContext(for configName: String) -> ModelContext { preconditionFailure("Not implemented") }
}

//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 28/02/2022.
//

import Foundation
@preconcurrency import CoreData
@preconcurrency import Combine
import KernelSwiftCommon

@preconcurrency
public struct BKCoreDataStack: BKPersistentStore {
    private let container: NSPersistentContainer
    private let isStoreLoaded = CurrentValueSubject<Bool, Error>(false)
    private let backgroundQueue = DispatchQueue(label: "bkcoredata")
    
    @preconcurrency
    public init(
        directory: FileManager.SearchPathDirectory = .documentDirectory,
        domainMask: FileManager.SearchPathDomainMask = .userDomainMask,
        version vNumber: UInt
    ) {
        let version = Version(vNumber)
        container = NSPersistentContainer(name: version.modelName)
        if let url = version.dbFileURL(directory, domainMask) {
            let store = NSPersistentStoreDescription(url: url)
            container.persistentStoreDescriptions = [store]
        }
        backgroundQueue.async {[isStoreLoaded, container] in
            container.loadPersistentStores { (storeDescription, error) in
                DispatchQueue.main.async {
                    
                    if let error = error {
                        isStoreLoaded.send(completion: .failure(error))
                    } else {
                        container.viewContext.configureAsReadOnlyContext()
                        isStoreLoaded.value = true
                    }
                }
            }
        }
    }
    
    public init(
        directory: FileManager.SearchPathDirectory = .documentDirectory,
        domainMask: FileManager.SearchPathDomainMask = .userDomainMask,
        versionObj: Version
    ) {
        let version = versionObj
        container = NSPersistentContainer(name: version.modelName)
        if let url = version.dbFileURL(directory, domainMask) {
            let store = NSPersistentStoreDescription(url: url)
            container.persistentStoreDescriptions = [store]
        }
        backgroundQueue.async {[isStoreLoaded, container] in
            container.loadPersistentStores { (storeDescription, error) in
                DispatchQueue.main.async {
                    if let error = error {
                        isStoreLoaded.send(completion: .failure(error))
                    } else {
                        container.viewContext.configureAsReadOnlyContext()
                        isStoreLoaded.value = true
                    }
                }
            }
        }
    }
    
    private var onStoreIsReady: AnyPublisher<Void, Error> {
        return isStoreLoaded
            .filter { $0 }
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
    public func count<T>(_ fetchRequest: NSFetchRequest<T>) -> AnyPublisher<Int, Error> where T : NSFetchRequestResult {
        return onStoreIsReady
            .flatMap { [weak container] in
                Future<Int, Error> { future in
                    do {
                        let count = try container?.viewContext.count(for: fetchRequest) ?? 0
                        future(.success(count))
                    } catch {
                        future(.failure(error))
                    }
                }
            }
            .eraseToAnyPublisher()
    }
    
    @preconcurrency
    public func fetch<T: Sendable, V: Sendable>(_ fetchRequest: NSFetchRequest<T>, map: @escaping @Sendable (T) throws -> V?) -> AnyPublisher<LazyList<V>, Error> where T : NSFetchRequestResult {
        assert(Thread.isMainThread)
        let fetch = Future<LazyList<V>, Error> { [weak container] future in
#if swift(>=6)
            nonisolated(unsafe) let future = future
#endif
            guard let context = container?.viewContext else { return }
            context.performAndWait {
                do {
                    let managedObjects = try context.fetch(fetchRequest)
                    let results = LazyList<V>(count: managedObjects.count, useInMemoryCache: true) { [weak context] in
                        let object = managedObjects[$0]
                        let mapped = try map(object)
                        if let mo = object as? NSManagedObject {
                            context?.refresh(mo, mergeChanges: false)
                        }
                        return mapped
                    }
                    future(.success(results))
                } catch {
                    future(.failure(error))
                }
            }
        }
        return onStoreIsReady
            .flatMap { fetch }
            .eraseToAnyPublisher()
    }
    
    
    public func update<Result: Sendable>(_ operation: @escaping @Sendable DBOperation<Result>) -> AnyPublisher<Result, Error> {
        let update = Future<Result, Error> { [backgroundQueue, container] future in
            #if swift(>=6)
            nonisolated(unsafe) let future = future
            #endif
            backgroundQueue.async {
                let context = container.newBackgroundContext()
                context.configureAsUpdateContext()
                context.performAndWait {
                    do {
                        let result = try operation(context)
                        if context.hasChanges {
                            try context.save()
                        }
                        context.reset()
                        future(.success(result))
                    } catch {
                        context.reset()
                        future(.failure(error))
                    }
                }
            }
        }
        
        return onStoreIsReady
            .flatMap { update }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
}

extension BKCoreDataStack.Version {
    public static var actual: UInt { 1 }
}

extension BKCoreDataStack {
    public struct Version {
        private let number: UInt
        private let prefix: String
        
        public init(_ number: UInt, prefix: String = "db_model") {
            self.number = number
            self.prefix = prefix
        }
        
        public var modelName: String {
            return "\(prefix)_v\(number)"
        }
        
        public func dbFileURL(_ directory: FileManager.SearchPathDirectory, _ domainMask: FileManager.SearchPathDomainMask) -> URL? {
            return FileManager.default.urls(for: directory, in: domainMask).first?.appendingPathComponent(subpathToDB)
        }
        
        private var subpathToDB: String {
            return "db.sql"
        }
    }
}


//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 28/02/2022.
//

import CoreData
import Combine

public protocol ManagedEntity: NSFetchRequestResult {}

extension ManagedEntity where Self: NSManagedObject {
    public static var entityName: String {
        let nameMO = String(describing: Self.self)
//        let suffixIndex = nameMO.index(nameMO.endIndex, offsetBy: -2)
//        return String(nameMO[..<suffixIndex])
        return nameMO
    }
    
    public static func insertNew(in context: NSManagedObjectContext) -> Self? {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as? Self
    }
    
    public static func newFetchRequest() -> NSFetchRequest<Self> {
        return .init(entityName: entityName)
    }
    
    public static func any() -> NSFetchRequest<Self> {
        let request = newFetchRequest()
        request.predicate = NSPredicate(value: true)
        request.fetchLimit = 1
        return request
    }
    
    public static func all() -> NSFetchRequest<Self> {
        let request = newFetchRequest()
        request.predicate = NSPredicate(value: true)
        return request
    }
    
    public static func byId(id entityId: String) -> NSFetchRequest<Self> {
        let request = newFetchRequest()
        request.predicate = NSPredicate(format: "id == %@", entityId as CVarArg)
        request.fetchLimit = 1
        return request
    }
}

extension NSManagedObjectContext {
    public func configureAsReadOnlyContext() {
        automaticallyMergesChangesFromParent = true
        mergePolicy = NSMergePolicy.overwrite
        undoManager = nil
        shouldDeleteInaccessibleFaults = true
    }
    
    public func configureAsUpdateContext() {
        mergePolicy = NSMergePolicy.overwrite
        undoManager = nil
    }
}

extension NSSet {
    public func toArray<T>(of type: T.Type) -> [T] {
        allObjects.compactMap { $0 as? T }
    }
}

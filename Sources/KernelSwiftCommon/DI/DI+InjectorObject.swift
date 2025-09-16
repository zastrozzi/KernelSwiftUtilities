//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/11/2023.
//

import Foundation

extension KernelDI {
    private struct InjectorObject: Sendable {
        nonisolated(unsafe) weak var object: AnyObject?
        let injector: Injector
    }
    
    
    
    internal final class InjectorObjects: Sendable {
        nonisolated(unsafe) private var storage = LockIsolated<[ObjectIdentifier: InjectorObject]>([:])
        
        internal init() {}
        
        func store(_ object: AnyObject) {
            self.storage.withValue { storage in
                storage[ObjectIdentifier(object)] = InjectorObject(object: object, injector: Injector._current)
                Task {
                    self.storage.withValue { storage in
                        for (id, box) in storage where box.object == nil {
                            storage.removeValue(forKey: id)
                        }
                    }
                }
            }
        }
        
        func injector(from object: AnyObject) -> Injector? {
            Mirror(reflecting: object).children.lazy.compactMap {
                $1 as? HasInitialValues
            }.first?.initialValues ?? self.storage.withValue({
                $0[ObjectIdentifier(object)]?.injector
            })
        }
    }

}

//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 09/11/2023.
//

import Foundation

@rethrows
internal protocol _ErrorMechanism {
    associatedtype Output
    func get() throws -> Output
}

extension _ErrorMechanism {
    // rethrow an error only in the cases where it is known to be reachable
    internal func _rethrowError() rethrows -> Never {
        _ = try _rethrowGet()
        fatalError("materialized error without being in a throwing context")
    }
    
    internal func _rethrowGet() rethrows -> Output {
        return try get()
    }
}

extension Result: _ErrorMechanism { }

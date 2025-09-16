//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/11/2023.
//

import Foundation

extension KernelDI {
    public static func inject<Value: Injectable>(
        _ keyPath: KeyPath<Injector, Value>
//        file: StaticString = #file,
//        fileID: StaticString = #fileID,
//        line: UInt = #line
    ) -> Value {
#if DEBUG
//        var current = Injector.currentInjectable
//        current.file = file
//        current.fileID = fileID
//        current.line = line
#endif
        return Injector._current[keyPath: keyPath]
    }
}

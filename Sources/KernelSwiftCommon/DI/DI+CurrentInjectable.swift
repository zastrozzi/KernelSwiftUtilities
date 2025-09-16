//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/11/2023.
//

import Foundation

extension KernelDI {
    public struct CurrentInjectable: Sendable {
        public var name: StaticString?
        public var file: StaticString?
        public var fileID: StaticString?
        public var line: UInt?
        
        public init(
            name: StaticString? = nil,
            file: StaticString? = nil,
            fileID: StaticString? = nil,
            line: UInt? = nil
        ) {
            self.name = name
            self.file = file
            self.fileID = fileID
            self.line = line
        }
    }
}

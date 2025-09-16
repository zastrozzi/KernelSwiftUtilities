//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 29/05/2024.
//

extension KernelNetworking.Model {
    public struct Browser: UserAgentParseable {
        public private(set) var name: String?
        public private(set) var version: String?
        
        public init?(_ data: UserAgentDictionary?) {
            guard let data = data else { return nil }
            if data[.name] == nil && data[.version] == nil { return nil }
            self.name = data[.name]
            self.version = data[.version]
        }
    }
}

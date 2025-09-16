//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 29/05/2024.
//

extension KernelNetworking.Model {
    public struct CPU: UserAgentParseable {
        public private(set) var identifier: String?
        
        public init?(_ data: UserAgentDictionary?) {
            guard let arch = data?[.arch] else { return nil }
            self.identifier = arch
        }
    }
}

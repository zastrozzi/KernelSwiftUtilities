//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 29/05/2024.
//

import Foundation

extension KernelNetworking.Model {
    public enum UserAgentKey {
        case model
        case name
        case vendor
        case type
        case version
        case arch
    }
    
    public typealias UserAgentDictionary = [UserAgentKey: String]
    
    internal struct UserAgentRule {
        public private(set) var regexp: [NSRegularExpression]
        public private(set) var funcs: [UserAgentFuncs]
        public init(_ regexp: [String], _ funcs: [UserAgentFuncs]) {
            self.regexp = regexp.map { (regex) in
                try! NSRegularExpression(pattern: regex, options: [.caseInsensitive])
            }

            self.funcs = funcs
        }
    }

    internal protocol UserAgentMappedKeys {
        var map: [String:[String]] { get }
    }

    internal enum UserAgentFuncs {
        case r(_: UserAgentKey)
        case rf(_: UserAgentKey, _: String)
        case rp(_: UserAgentKey, _: String, _: String)
        case mp(_: UserAgentKey, _: UserAgentMappedKeys)
    }

}

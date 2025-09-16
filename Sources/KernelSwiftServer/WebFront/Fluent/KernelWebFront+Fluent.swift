//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 30/4/24.
//

extension KernelWebFront {
    public enum Fluent: KernelServerPlatform.FluentContainer {}
}

extension KernelWebFront.Fluent {
    public enum SchemaName: String, KernelFluentNamespacedSchemaName {
        public static let namespace: String = "k_webfront"
        
        case flowContainer = "flow_container"
        case flowNode = "flow_node"
        case flowContinuation = "flow_continuation"
        case flowPrompt = "flow_prompt"
        
        case site = "site"
        case siteRevision = "site_revision"
        case page = "page"
        case pageRevision = "page_revision"
        
        case component = "component"
        case element = "element"
    }
}

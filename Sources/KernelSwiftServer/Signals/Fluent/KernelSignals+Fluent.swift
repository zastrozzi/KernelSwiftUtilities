//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 08/02/2025.
//

extension KernelSignals {
    public enum Fluent: KernelServerPlatform.FluentContainer {}
}

extension KernelSignals.Fluent {
    public enum SchemaName: String, KernelFluentNamespacedSchemaName {
        public static let namespace: String = "k_signals"
        
        case eventType = "event_type"
        case event = "event"
    }
}

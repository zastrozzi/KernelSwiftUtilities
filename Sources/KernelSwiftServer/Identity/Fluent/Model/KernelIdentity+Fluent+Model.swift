//
//  File.swift
//
//
//  Created by Jonathan Forbes on 1/5/24.
//

import Vapor

extension KernelIdentity.Fluent {
    public enum Model: KernelServerPlatform.FluentModel {}
}

extension KernelIdentity.Fluent.Model {
    public typealias SchemaName = KernelIdentity.Fluent.SchemaName
    
    public static func registerSchemas(for app: Application) async throws {
        try await app.kernelDI(KernelDynamicQuery.self).registerSchema(Enduser.self, as: "Enduser")
        try await app.kernelDI(KernelDynamicQuery.self).registerSchema(EnduserAction.self, as: "EnduserAction")
        try await app.kernelDI(KernelDynamicQuery.self).registerSchema(EnduserAddress.self, as: "EnduserAddress")
        //        try await app.kernelDI(KernelDynamicQuery.self).services.schema.registerSchema(Fluent.Model.EnduserCredential.self, as: "EnduserCredential")
        try await app.kernelDI(KernelDynamicQuery.self).registerSchema(EnduserDevice.self, as: "EnduserDevice")
        try await app.kernelDI(KernelDynamicQuery.self).registerSchema(EnduserEmail.self, as: "EnduserEmail")
        try await app.kernelDI(KernelDynamicQuery.self).registerSchema(EnduserPhone.self, as: "EnduserPhone")
        try await app.kernelDI(KernelDynamicQuery.self).registerSchema(EnduserSession.self, as: "EnduserSession")
    }
}

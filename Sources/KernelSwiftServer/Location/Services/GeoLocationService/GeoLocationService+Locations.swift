//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/10/2024.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelLocation.Services.GeoLocationService {
    public func createLocation(
        from requestBody: KernelLocation.Core.GeoLocation.CreateGeoLocationRequest,
        on db: DatabaseID? = nil,
        as platformActor: KernelIdentity.Core.Model.PlatformActor
    ) async throws -> KernelLocation.Fluent.Model.GeoLocation {
        let location = try await KernelLocation.Fluent.Model.GeoLocation.create(
            from: requestBody,
            onDB: selectDB(db),
            withAudit: true,
            as: platformActor
        )
        return location
    }
}

//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/10/2024.
//

extension KernelLocation {
    public struct Services: Sendable {
        public var geolocation: GeoLocationService
        
        public init() {
            geolocation = .init()
        }
    }
}

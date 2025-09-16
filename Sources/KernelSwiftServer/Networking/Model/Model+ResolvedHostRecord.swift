//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 19/09/2024.
//

import Foundation

extension KernelNetworking.Model {
    public struct ResolvedHostRecord: Codable, Sendable {
        public var latestObservation: Date
        public var totalObservations: Int
        public var host: String
        
        public init(
            latestObservation: Date,
            totalObservations: Int,
            host: String
        ) {
            self.latestObservation = latestObservation
            self.totalObservations = totalObservations
            self.host = host
        }
    }
}

//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 19/06/2024.
//

import KernelSwiftCommon
import Vapor

extension KernelIdentity.Core.Model {
    public struct EnduserAddressResponse: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public var id: UUID
        
        public var dbCreatedAt: Date
        public var dbUpdatedAt: Date
        public var dbDeletedAt: Date?
        
        public var refinement: String?
        public var number: String?
        public var street: String?
        public var city: String?
        public var region: String?
        public var postalCode: String
        public var country: ISO3166CountryAlpha2Code
        public var enduserId: UUID
        
        public init(
            id: UUID,
            dbCreatedAt: Date,
            dbUpdatedAt: Date,
            dbDeletedAt: Date? = nil,
            refinement: String? = nil,
            number: String? = nil,
            street: String? = nil,
            city: String? = nil,
            region: String? = nil,
            postalCode: String,
            country: ISO3166CountryAlpha2Code,
            enduserId: UUID
        ) {
            self.id = id
            self.dbCreatedAt = dbCreatedAt
            self.dbUpdatedAt = dbUpdatedAt
            self.dbDeletedAt = dbDeletedAt
            self.refinement = refinement
            self.number = number
            self.street = street
            self.city = city
            self.region = region
            self.postalCode = postalCode
            self.country = country
            self.enduserId = enduserId
        }
    }
}


//
//  File.swift
//
//
//  Created by Jonathan Forbes on 4/5/24.
//

import KernelSwiftCommon
import Vapor

extension KernelIdentity.Core.Model {
    public struct CreateEnduserAddressRequest: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public var refinement: String?
        public var number: String?
        public var street: String?
        public var city: String?
        public var region: String?
        public var postalCode: String
        public var country: ISO3166CountryAlpha2Code
        
        public init(
            refinement: String? = nil,
            number: String? = nil,
            street: String? = nil,
            city: String? = nil,
            region: String? = nil,
            postalCode: String,
            country: ISO3166CountryAlpha2Code
        ) {
            self.refinement = refinement
            self.number = number
            self.street = street
            self.city = city
            self.region = region
            self.postalCode = postalCode
            self.country = country
        }
    }
}

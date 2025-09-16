//
//  File.swift
//
//
//  Created by Jonathan Forbes on 4/5/24.
//

import KernelSwiftCommon
import Vapor

extension KernelIdentity.Core.Model {
    public struct UpdateEnduserRequest: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public var firstName: String?
        public var lastName: String?
        public var genderPronoun: GenderPronoun?
        public var dateOfBirth: Date?
        public var onboardingComplete: Bool?
        public var allowInsuranceCall: Bool?
        public var allowTracking: Bool?
        
        public init(
            firstName: String? = nil,
            lastName: String? = nil,
            genderPronoun: GenderPronoun? = nil,
            dateOfBirth: Date? = nil,
            onboardingComplete: Bool? = nil,
            allowInsuranceCall: Bool? = nil,
            allowTracking: Bool? = nil
        ) {
            self.firstName = firstName
            self.lastName = lastName
            self.genderPronoun = genderPronoun
            self.dateOfBirth = dateOfBirth
            self.onboardingComplete = onboardingComplete
            self.allowInsuranceCall = allowInsuranceCall
            self.allowTracking = allowTracking
        }
    }
}

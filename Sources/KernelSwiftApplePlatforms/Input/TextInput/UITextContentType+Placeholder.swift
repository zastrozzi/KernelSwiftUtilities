//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 24/08/2023.
//

import Foundation

#if os(iOS)
import UIKit
extension UITextContentType {
    @available(iOS 17.0, *)
    public var placeholderLabel: String? {
        switch self {
        case .name: "Name"
        case .namePrefix: "Prefix"
        case .givenName: "Given Name"
        case .middleName: "Middle Name"
        case .familyName: "Family Name"
        case .nameSuffix: "Suffix"
        case .nickname: "Nickname"
        case .jobTitle: "Job Title"
        case .organizationName: "Organisation Name"
        case .location: "Location"
        case .fullStreetAddress: "Full Address"
        case .streetAddressLine1: "Address Line 1"
        case .streetAddressLine2: "Address Line 2"
        case .addressCity: "City"
        case .addressState: "State"
        case .addressCityAndState: "City / State"
        case .sublocality: "Region"
        case .countryName: "Country"
        case .postalCode: "Postal Code"
        case .telephoneNumber: "Phone Number"
        case .emailAddress: "Email Address"
        case .URL: "URL"
        case .creditCardNumber: "Card Number"
        case .username: "Username"
        case .password: "Password"
        case .newPassword: "New Password"
        case .oneTimeCode: "OTP"
        case .shipmentTrackingNumber: "Tracking Number"
        case .flightNumber: "Flight Number"
        case .dateTime: "Date"
        case .birthdate: "Birthdate"
        case .birthdateDay: "Day"
        case .birthdateMonth: "Month"
        case .birthdateYear: "Year"
        case .creditCardSecurityCode: "Security Code"
        case .creditCardName: "Cardholder"
        case .creditCardGivenName: "Given Name"
        case .creditCardMiddleName: "Middle Name"
        case .creditCardFamilyName: "Family Name"
        case .creditCardExpiration: "Expiration Date (MM/YY)"
        case .creditCardExpirationMonth: "Expiration Month (MM)"
        case .creditCardExpirationYear: "Expiration Year (YY)"
        case .creditCardType: "Card Type"
        default: nil
        }
    }
}
#endif

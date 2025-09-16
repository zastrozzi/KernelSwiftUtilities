//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/08/2023.
//

import Foundation

//public struct InputCurrency: Identifiable {
//    public var iso4217: ISO4217Currency
//    public var image: String
//    
//    public init(currency: Locale.Currency, image: String) {
//        self.currency = currency
//        self.image = image
//    }
//    
//    public var id: String {
//        currency.identifier
//    }
//}


public enum InputCurrency: Identifiable, CaseIterable, Codable, Hashable, Equatable, Sendable {
    case STERLING
    case DOLLAR
    case EURO
    case YEN
    case FRANC
    case LIRA
    case RUPEE
    
    public static func random() -> InputCurrency {
        return allCases.randomElement()!
    }
    
    public var id: String {
        switch self {
        case .STERLING: "STERLING"
        case .DOLLAR: "DOLLAR"
        case .EURO: "EURO"
        case .YEN: "YEN"
        case .FRANC: "FRANC"
        case .LIRA: "LIRA"
        case .RUPEE: "RUPEE"
        }
    }
    
    public var image: String {
        switch self {
        case .STERLING: "sterlingsign"
        case .DOLLAR: "dollarsign"
        case .EURO: "eurosign"
        case .YEN: "yensign"
        case .FRANC: "francsign"
        case .LIRA: "turkishlirasign"
        case .RUPEE: "indianrupeesign"
        }
    }
}

extension CaseIterable where Self: Identifiable {
    public init?(fromId id: Self.ID?) {
        guard let fromId = Self.allCases.first(where: { $0.id == id }) else { return nil }
        self = fromId
    }
}

//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 29/08/2023.
//

import Foundation

public enum CurrencyFieldAction {
    case ADD_1
    case ADD_10
    case ADD_25
    case ADD_50
    case ADD(_ amount: Decimal)
}

extension CurrencyFieldAction {
    public var addAmount: Decimal {
        switch self {
        case .ADD_1: 1
        case .ADD_10: 10
        case .ADD_25: 25
        case .ADD_50: 50
        case let .ADD(amount): amount
        }
    }
    
    public var identifier: String {
        switch self {
        case .ADD_1: "ADD_1"
        case .ADD_10: "ADD_10"
        case .ADD_25: "ADD_25"
        case .ADD_50: "ADD_50"
        case let .ADD(amount): "ADDOTHER_\(amount)"
        }
    }
}

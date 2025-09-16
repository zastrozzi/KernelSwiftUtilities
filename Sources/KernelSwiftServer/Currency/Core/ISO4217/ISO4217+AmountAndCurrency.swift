//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 04/02/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelCurrency.Core.ISO4217 {
    public struct AmountAndCurrency: OpenAPIContent {
        public var amount: Double?
        public var currency: CurrencyCode?
        
        public init(
            amount: Double? = nil,
            currency: CurrencyCode? = nil
        ) {
            self.amount = amount
            self.currency = currency
        }
        
        public enum CodingKeys: String, CodingKey {
            case amount
            case currency
        }
    }
}


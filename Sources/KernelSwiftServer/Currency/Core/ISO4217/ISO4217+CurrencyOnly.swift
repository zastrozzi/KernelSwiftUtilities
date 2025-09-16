//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 04/02/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelCurrency.Core.ISO4217 {
    public struct CurrencyOnly: OpenAPIContent {
        public var currency: CurrencyCode
        
        public init(
            currency: CurrencyCode
        ) {
            self.currency = currency
        }
        
        public enum CodingKeys: String, CodingKey {
            case currency
        }
    }
}


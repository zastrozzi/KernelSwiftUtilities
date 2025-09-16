//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 04/02/2025.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelCurrency.Fluent.Model.ISO4217 {
    public final class AmountAndCurrency: KernelFluentCRUDFields, @unchecked Sendable {
        @OptionalField(key: "amount") public var amount: Double?
        @OptionalKernelEnum(key: "currency") public var currency: KernelCurrency.Core.ISO4217.CurrencyCode?
        
        public init() {}
        
        public static func createFields(
            from dto: KernelCurrency.Core.ISO4217.AmountAndCurrency
        ) throws -> Self {
            let model = self.init()
            model.amount = dto.amount
            model.currency = dto.currency
            return model
        }
        
        public static func updateFields(
            for model: AmountAndCurrency,
            from dto: KernelCurrency.Core.ISO4217.AmountAndCurrency
        ) throws {
            try model.updateIfChanged(\.amount, from: dto.amount)
            try model.updateIfChanged(\.currency, from: dto.currency)
        }
        
        public func response() throws -> KernelCurrency.Core.ISO4217.AmountAndCurrency {
            .init(
                amount: amount,
                currency: currency
            )
        }
    }
}

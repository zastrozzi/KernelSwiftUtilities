//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 05/09/2023.
//

import Foundation

public struct InteractionFlowOutputData<Identifier: InteractionFlowElementIdentifiable> {
    public var identifier: Identifier
    
    public var binaryInput: (any BinaryInputRepresentable)?
    public var iconChipInput: (any IconChipRepresentable)?
    public var date: Date?
    public var isEditing: Bool?
    public var amount: Decimal?
    public var currency: InputCurrency?
    public var text: String?
    
    fileprivate init(
        identifier: Identifier,
        binaryInput: (any BinaryInputRepresentable)? = nil,
        iconChipInput: (any IconChipRepresentable)? = nil,
        date: Date? = nil,
        isEditing: Bool? = nil,
        amount: Decimal? = nil,
        currency: InputCurrency? = nil,
        text: String? = nil
    ) {
        self.identifier = identifier
        self.binaryInput = binaryInput
        self.iconChipInput = iconChipInput
        self.date = date
        self.isEditing = isEditing
        self.amount = amount
        self.currency = currency
        self.text = text
    }
    
    public init(
        identifier: Identifier,
        _ binaryInput: (any BinaryInputRepresentable)?
    ) {
        self = .init(identifier: identifier, binaryInput: binaryInput)
    }
    
    public init(
        identifier: Identifier,
        _ iconChipInput: (any IconChipRepresentable)?
    ) {
        self = .init(identifier: identifier, iconChipInput: iconChipInput)
    }
    
    public init(
        identifier: Identifier,
        _ date: Date?
    ) {
        self = .init(identifier: identifier, date: date)
    }
    
    public init(
        identifier: Identifier,
        _ isEditing: Bool?
    ) {
        self = .init(identifier: identifier, isEditing: isEditing)
    }
    
    public init(
        identifier: Identifier,
        _ amount: Decimal?
    ) {
        self = .init(identifier: identifier, amount: amount)
    }
    
    public init(
        identifier: Identifier,
        _ currency: InputCurrency?
    ) {
        self = .init(identifier: identifier, currency: currency)
    }
    
    public init(
        identifier: Identifier,
        _ text: String?
    ) {
        self = .init(identifier: identifier, text: text)
    }
    
    
}

//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/08/2023.
//

import Foundation
import SwiftUI

public enum InteractionFlowInput {
    case currencyInput(currency: InputCurrency, amount: Decimal?, isEditing: Bool)
    case dateInput(selectedDate: Date?, before: Date?, after: Date?, isEditing: Bool)
    case iconChipInput(chip: (any IconChipRepresentable)?)
    case binaryChoiceInput(choice: (any BinaryInputRepresentable)?)
    case customInput
    case textFieldInput(
        value: String? = nil,
        isEditing: Bool
    )
}

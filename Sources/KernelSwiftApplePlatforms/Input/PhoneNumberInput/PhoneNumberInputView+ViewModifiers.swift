//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 05/03/2025.
//

import SwiftUI
import PhoneNumberKit

extension PhoneNumberInputView {
    public func font(_ font: UIFont?) -> Self {
        var view = self
        view.font = font
        return view
    }
    
    @available(iOS 14, *)
    public func foregroundColor(_ color: Color?) -> Self {
        if let color = color {
            return foregroundColor(UIColor(color))
        } else {
            return nilForegroundColor()
        }
    }
    
    public func foregroundColor(_ color: CGColor?) -> Self {
        if let color = color {
            return foregroundColor(UIColor(cgColor: color))
        } else {
            return nilForegroundColor()
        }
    }
    
    public func foregroundColor(_ color: UIColor?) -> Self {
        var view = self
        view.textColor = color
        return view
    }
    
    private func nilForegroundColor() -> Self {
        var view = self
        view.textColor = nil
        return view
    }
    
    @available(iOS 14, *)
    public func placeholderColor(_ color: Color?) -> Self {
        self
            .numberPlaceholderColor(color)
            .countryCodePlaceholderColor(color)
    }
    
    public func placeholderColor(_ color: UIColor?) -> Self {
        self
            .numberPlaceholderColor(color)
            .countryCodePlaceholderColor(color)
    }
    
    public func placeholderColor(_ color: CGColor?) -> Self {
        self
            .numberPlaceholderColor(color)
            .countryCodePlaceholderColor(color)
    }
    
    @available(iOS 14, *)
    public func numberPlaceholderColor(_ color: Color?) -> Self {
        if let color = color {
            return numberPlaceholderColor(UIColor(color))
        } else {
            return nilNumberPlaceholderColor()
        }
    }
    
    public func numberPlaceholderColor(_ color: UIColor?) -> Self {
        var view = self
        view.numberPlaceholderColor = color
        return view
    }
    
    public func numberPlaceholderColor(_ color: CGColor?) -> Self {
        if let color = color {
            return numberPlaceholderColor(UIColor(cgColor: color))
        } else {
            return nilNumberPlaceholderColor()
        }
    }
    
    @available(iOS 14, *)
    public func countryCodePlaceholderColor(_ color: Color?) -> Self {
        if let color = color {
            return countryCodePlaceholderColor(UIColor(color))
        } else {
            return nilCountryPlaceholderColor()
        }
    }
    
    public func countryCodePlaceholderColor(_ color: UIColor?) -> Self {
        var view = self
        view.countryCodePlaceholderColor = color
        return view
    }
    
    public func countryCodePlaceholderColor(_ color: CGColor?) -> Self {
        if let color = color {
            return countryCodePlaceholderColor(UIColor(cgColor: color))
        } else {
            return nilCountryPlaceholderColor()
        }
    }
    
    private func nilPlaceholderColor() -> Self {
        self
            .nilNumberPlaceholderColor()
            .nilCountryPlaceholderColor()
    }
    
    private func nilNumberPlaceholderColor() -> Self {
        var view = self
        view.numberPlaceholderColor = nil
        return view
    }
    
    private func nilCountryPlaceholderColor() -> Self {
        var view = self
        view.countryCodePlaceholderColor = nil
        return self
    }
    
    public func multilineTextAlignment(_ alignment: TextAlignment) -> Self {
        var view = self
        switch alignment {
        case .leading:
            view.textAlignment = layoutDirection ~= .leftToRight ? .left : .right
        case .trailing:
            view.textAlignment = layoutDirection ~= .leftToRight ? .right : .left
        case .center:
            view.textAlignment = .center
        }
        return view
    }
    
    public func clearsOnEditingBegan(_ shouldClear: Bool) -> Self {
        var view = self
        view.clearsOnBeginEditing = shouldClear
        return view
    }
    
    public func clearsOnInsert(_ shouldClear: Bool) -> Self {
        var view = self
        view.clearsOnInsertion = shouldClear
        return view
    }
    
    public func clearButtonMode(_ mode: UITextField.ViewMode) -> Self {
        var view = self
        view.clearButtonMode = mode
        return view
    }
    
    public func textFieldStyle(_ style: UITextField.BorderStyle) -> Self {
        var view = self
        view.borderStyle = style
        return view
    }
    
    public func maximumDigits(_ max: Int?) -> Self {
        var view = self
        view.maxDigits = max
        return view
    }
    
    public func flagHidden(_ hidden: Bool) -> Self {
        var view = self
        view.showFlag = !hidden
        return view
    }
    
    public func flagSelectable(_ selectable: Bool) -> Self {
        var view = self
        view.selectableFlag = selectable
        return view
    }
    
    public func prefixHidden(_ hidden: Bool) -> Self {
        var view = self
        view.previewPrefix = !hidden
        return view
    }
    
    public func autofillPrefix(_ autofill: Bool) -> Self {
        var view = self
        view.autofillPrefix = autofill
        return view
    }
    
    public func defaultRegion(_ region: String?) -> Self {
        var view = self
        view.defaultRegion = region
        return view
    }
    
    public func onEditingBegan(perform action: ((UIViewType) -> ())? = nil) -> Self {
        var view = self
        if let action = action {
            view.onBeginEditingHandler = action
        }
        return view
    }
    
    public func onNumberChange(perform action: ((PhoneNumber?) -> ())? = nil) -> Self {
        var view = self
        if let action = action {
            view.onPhoneNumberChangeHandler = action
        }
        return view
    }
    
    public func onEdit(perform action: ((UIViewType) -> ())? = nil) -> Self {
        var view = self
        if let action = action {
            view.onEditingChangeHandler = action
        }
        return view
    }
    
    public func onEditingEnded(perform action: ((UIViewType) -> ())? = nil) -> Self {
        var view = self
        if let action = action {
            view.onEndEditingHandler = action
        }
        return view
    }
    
    public func onClear(perform action: ((PhoneNumberTextField) -> Void)? = nil) -> Self {
        var view = self
        if let action = action {
            view.onClearHandler = action
        }
        return view
    }
    
    public func onReturn(perform action: ((PhoneNumberTextField) -> Void)? = nil) -> Self {
        var view = self
        if let action = action {
            view.onReturnHandler = action
        }
        return view
    }
    
    public func formatted(_ formatted: Bool = true) -> Self {
        var view = self
        view.formatted = formatted
        return view
    }
}

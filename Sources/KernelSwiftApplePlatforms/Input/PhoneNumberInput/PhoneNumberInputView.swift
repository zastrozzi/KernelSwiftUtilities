//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 05/03/2025.
//

import SwiftUI
import PhoneNumberKit

#if canImport(UIKit)
public struct PhoneNumberInputView: UIViewRepresentable {
    @Binding public var text: String
    @State private var displayedText: String
    
    @State private var internalIsFirstResponder: Bool = false
    
    private let placeholder: String?
    private var externalIsFirstResponder: Binding<Bool>?
    
    private var isFirstResponder: Bool {
        get { externalIsFirstResponder?.wrappedValue ?? internalIsFirstResponder }
        set {
            if externalIsFirstResponder != nil {
                externalIsFirstResponder!.wrappedValue = newValue
            } else {
                internalIsFirstResponder = newValue
            }
        }
    }
    
    internal var maxDigits: Int?
    internal var font: UIFont?
    internal var clearButtonMode: UITextField.ViewMode = .never
    
    internal var showFlag: Bool = false
    internal var selectableFlag: Bool = false
    internal var autofillPrefix: Bool = false
    internal var previewPrefix: Bool = false
    internal var defaultRegion: String?
    internal var textColor: UIColor?
    internal var accentColor: UIColor?
    internal var numberPlaceholderColor: UIColor?
    internal var countryCodePlaceholderColor: UIColor?
    internal var borderStyle: UITextField.BorderStyle = .none
    internal var formatted: Bool = true
    
    internal var onBeginEditingHandler = { (view: PhoneNumberTextField) in }
    internal var onEditingChangeHandler = { (view: PhoneNumberTextField) in }
    internal var onPhoneNumberChangeHandler = { (phoneNumber: PhoneNumber?) in }
    internal var onEndEditingHandler = { (view: PhoneNumberTextField) in }
    internal var onClearHandler = { (view: PhoneNumberTextField) in }
    internal var onReturnHandler = { (view: PhoneNumberTextField) in }
    
    public var configuration = { (view: PhoneNumberTextField) in }
    
    @Environment(\.layoutDirection) internal var layoutDirection: LayoutDirection
    internal var textAlignment: NSTextAlignment?
    internal var clearsOnBeginEditing = false
    internal var clearsOnInsertion = false
    internal var isUserInteractionEnabled = true
    
    public init(
        _ title: String? = nil,
        text: Binding<String>,
        isEditing: Binding<Bool>? = nil,
        formatted: Bool = true,
        configuration: @escaping (UIViewType) -> () = { _ in }
    ) {
        self.placeholder = title
        self.externalIsFirstResponder = isEditing
        self.formatted = formatted
        self._text = text
        self._displayedText = State(initialValue: text.wrappedValue)
        self.configuration = configuration
    }
    
    public func makeUIView(
        context: UIViewRepresentableContext<Self>
    ) -> PhoneNumberTextField {
        let uiView = UIViewType()
        
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.addTarget(
            context.coordinator,
            action: #selector(Coordinator.textViewDidChange),
            for: .editingChanged
        )
        uiView.delegate = context.coordinator
        uiView.withExamplePlaceholder = placeholder == nil
        if let defaultRegion = defaultRegion {
            uiView.partialFormatter.defaultRegion = defaultRegion
        }
        
        configuration(uiView)
        return uiView
    }
    
    public func updateUIView(
        _ uiView: PhoneNumberTextField,
        context: UIViewRepresentableContext<Self>
    ) {
        DispatchQueue.main.async {
            uiView.textContentType = .telephoneNumber
            uiView.text = text
            uiView.font = font
            uiView.maxDigits = maxDigits
            uiView.clearButtonMode = clearButtonMode
            uiView.placeholder = placeholder
            uiView.borderStyle = borderStyle
            uiView.textColor = textColor
            uiView.withFlag = showFlag
            uiView.withDefaultPickerUI = selectableFlag
            uiView.withPrefix = previewPrefix
            uiView.partialFormatter.defaultRegion = defaultRegion ?? PhoneNumberKit.defaultRegionCode()
            if placeholder != nil {
                uiView.placeholder = placeholder
            } else {
                uiView.withExamplePlaceholder = autofillPrefix
            }
            
            uiView.tintColor = accentColor
            
            if let numberPlaceholderColor = numberPlaceholderColor {
                uiView.numberPlaceholderColor = numberPlaceholderColor
            }
            if let countryCodePlaceholderColor = countryCodePlaceholderColor {
                uiView.countryCodePlaceholderColor = countryCodePlaceholderColor
            }
            if let textAlignment = textAlignment {
                uiView.textAlignment = textAlignment
            }
            
            if isFirstResponder {
                uiView.becomeFirstResponder()
            } else {
                uiView.resignFirstResponder()
            }
            
            configuration(uiView)
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        .init(
            text: $text,
            displayedText: $displayedText,
            isFirstResponder: externalIsFirstResponder ?? $internalIsFirstResponder,
            formatted: formatted,
            onBeginEditing: onBeginEditingHandler,
            onEditingChange: onEditingChangeHandler,
            onPhoneNumberChange: onPhoneNumberChangeHandler,
            onEndEditing: onEndEditingHandler,
            onClear: onClearHandler,
            onReturn: onReturnHandler
        )
    }
    
    public class Coordinator: NSObject, UITextFieldDelegate {
        internal init(
            text: Binding<String>,
            displayedText: Binding<String>,
            isFirstResponder: Binding<Bool>,
            formatted: Bool,
            onBeginEditing: @escaping (PhoneNumberTextField) -> () = { (view: PhoneNumberTextField) in },
            onEditingChange: @escaping (PhoneNumberTextField) -> () = { (view: PhoneNumberTextField) in },
            onPhoneNumberChange: @escaping (PhoneNumber?) -> () = { (view: PhoneNumber?) in },
            onEndEditing: @escaping (PhoneNumberTextField) -> () = { (view: PhoneNumberTextField) in },
            onClear: @escaping (PhoneNumberTextField) -> () = { (view: PhoneNumberTextField) in },
            onReturn: @escaping (PhoneNumberTextField) -> () = { (view: PhoneNumberTextField) in } )
        {
            self.text = text
            self.displayedText = displayedText
            self.isFirstResponder = isFirstResponder
            self.formatted = formatted
            self.onBeginEditing = onBeginEditing
            self.onEditingChange = onEditingChange
            self.onPhoneNumberChange = onPhoneNumberChange
            self.onEndEditing = onEndEditing
            self.onClear = onClear
            self.onReturn = onReturn
        }
        
        var text: Binding<String>
        var displayedText: Binding<String>
        var isFirstResponder: Binding<Bool>
        var formatted: Bool
        
        var onBeginEditing = { (view: PhoneNumberTextField) in }
        var onEditingChange = { (view: PhoneNumberTextField) in }
        var onPhoneNumberChange = { (phoneNumber: PhoneNumber?) in }
        var onEndEditing = { (view: PhoneNumberTextField) in }
        var onClear = { (view: PhoneNumberTextField) in }
        var onReturn = { (view: PhoneNumberTextField) in }
        
        @objc public func textViewDidChange(_ textField: UITextField) {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                
                guard let textField = textField as? PhoneNumberTextField else {
                    return assertionFailure("Undefined state")
                }
                
                if formatted {
                    text.wrappedValue = textField.text ?? ""
                } else {
                    if let number = textField.phoneNumber {
                        let country = String(number.countryCode)
                        let nationalNumber = String(number.nationalNumber)
                        text.wrappedValue = "+" + country + nationalNumber
                    } else {
                        text.wrappedValue = ""
                    }
                }
                
                displayedText.wrappedValue = textField.text ?? ""
                onEditingChange(textField)
                onPhoneNumberChange(textField.phoneNumber)
            }
        }
        
        public func textFieldDidBeginEditing(_ textField: UITextField) {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                isFirstResponder.wrappedValue = true
                onBeginEditing(textField as! PhoneNumberTextField)
            }
        }
        
        public func textFieldDidEndEditing(_ textField: UITextField) {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                isFirstResponder.wrappedValue = false
                onEndEditing(textField as! PhoneNumberTextField)
            }
        }
        
        public func textFieldShouldClear(_ textField: UITextField) -> Bool {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                displayedText.wrappedValue = ""
                onClear(textField as! PhoneNumberTextField)
            }
            return true
        }
        
        public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                onReturn(textField as! PhoneNumberTextField)
            }
            return true
        }
    }
}
#else
public struct PhoneNumberInputView: View {
    public var body: some View {
        Text("Platform not supported")
    }
}
#endif

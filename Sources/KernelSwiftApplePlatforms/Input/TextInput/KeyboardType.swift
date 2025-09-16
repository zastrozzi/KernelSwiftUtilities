//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 24/08/2023.
//

import Foundation

#if os(iOS)
import UIKit
public typealias BKKeyboardType = UIKeyboardType
#endif

#if os(macOS)
public enum BKKeyboardType: Int, @unchecked Sendable {
    case `default` = 0 // Default type for the current input method.
    case asciiCapable = 1 // Displays a keyboard which can enter ASCII characters
    case numbersAndPunctuation = 2 // Numbers and assorted punctuation.
    case URL = 3 // A type optimized for URL entry (shows . / .com prominently).
    case numberPad = 4 // A number pad with locale-appropriate digits (0-9, ۰-۹, ०-९, etc.). Suitable for PIN entry.
    case phonePad = 5 // A phone pad (1-9, *, 0, #, with letters under the numbers).
    case namePhonePad = 6 // A type optimized for entering a person's name or phone number.
    case emailAddress = 7 // A type optimized for multiple email address entry (shows space @ . prominently).
    case decimalPad = 8 // A number pad with a decimal point.
    case twitter = 9 // A type optimized for twitter text entry (easy access to @ #)
    case webSearch = 10 // A default keyboard type with URL-oriented addition (shows space . prominently).
    case asciiCapableNumberPad = 11 // A number pad (0-9) that will always be ASCII digits.
    public static var alphabet: BKKeyboardType { .default }
}
#endif

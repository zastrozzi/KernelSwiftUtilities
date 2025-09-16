//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 21/02/2022.
//

import Foundation

public extension Locale {
    static func preferred() -> Locale {
        guard let preferredLanguageIdentifier = Bundle.main.preferredLocalizations.first else {
            return Locale.current
        }
        return Locale(identifier: preferredLanguageIdentifier)
    }

    static func locale(from currencyCode: String) -> Locale? {
        

        if #available(iOS 16.0, *) {
            if !commonISOCurrencyCodes.contains(currencyCode) {
                return nil
            }
            
            #if os(iOS)
            if Locale.current.currency?.identifier == currencyCode {
                return Locale.current
            }
            #endif
            
            let localeComponents = [NSLocale.Key.currencyCode.rawValue: currencyCode]
            let localeIdentifier = Locale.identifier(fromComponents: localeComponents)
            return Locale(identifier: localeIdentifier)
        } else {
            
            if Locale.current.currencyCode == currencyCode {
                return Locale.current
            }
            
            let localeComponents = [NSLocale.Key.currencyCode.rawValue: currencyCode]
            let localeIdentifier = Locale.identifier(fromComponents: localeComponents)
            return Locale(identifier: localeIdentifier)
        }
        

        
    }
}

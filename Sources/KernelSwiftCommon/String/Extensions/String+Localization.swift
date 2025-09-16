//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 21/02/2022.
//

import Foundation

public extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(params: CVarArg...) -> String {
        return String(format: NSLocalizedString(self, comment: ""), arguments: params)
    }
}

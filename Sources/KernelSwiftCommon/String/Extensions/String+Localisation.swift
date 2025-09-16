//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 16/04/2023.
//

import Foundation

public extension String {
    var localised: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localised(params: CVarArg...) -> String {
        return String(format: localised, arguments: params)
    }
}

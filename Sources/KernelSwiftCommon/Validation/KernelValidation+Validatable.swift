//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 26/03/2025.
//

import Foundation

@_documentation(visibility: private)
public protocol _KernelValidation_Validatable {
    static func validations(_ validations: inout KernelValidation.Validations)
}

extension KernelValidation {
    public typealias Validatable = _KernelValidation_Validatable
}

extension KernelValidation.Validatable {
    public static func validate(json: String) throws {
        try self.validations().validate(json: json).assert()
    }
    
    public static func validate(_ decoder: Decoder) throws {
        try self.validations().validate(decoder).assert()
    }
    
    public static func validations() -> KernelValidation.Validations {
        var validations = KernelValidation.Validations()
        self.validations(&validations)
        return validations
    }
}

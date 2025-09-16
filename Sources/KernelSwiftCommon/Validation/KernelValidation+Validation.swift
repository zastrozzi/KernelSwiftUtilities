//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 26/03/2025.
//

import Foundation

extension KernelValidation {
    public struct Validation: Sendable {
        let key: ValidationKey
        let valuelessKeyBehavior: ValuelessKeyBehavior
        let customFailureDescription: String?
        let run: @Sendable (Decoder) -> ValidatorResult
        
        init<T>(
            key: ValidationKey,
            required: Bool,
            validator: Validator<T>,
            customFailureDescription: String?
        ) {
            self.init(
                key: key,
                valuelessKeyBehavior: required ? .missing : .skipAlways,
                customFailureDescription: customFailureDescription
            ) { decoder -> ValidatorResult in
                do {
                    let container = try decoder.singleValueContainer()
                    return try validator.validate(container.decode(T.self))
                } catch DecodingError.valueNotFound {
                    return ValidatorResults.NotFound()
                } catch DecodingError.typeMismatch(let type, _) {
                    return ValidatorResults.TypeMismatch(type: type)
                } catch DecodingError.dataCorrupted(let context) {
                    return ValidatorResults.Invalid(reason: context.debugDescription)
                } catch {
                    return ValidatorResults.Codable(error: error)
                }
            }
        }
        
        init(
            nested key: ValidationKey,
            required: Bool,
            keyed validations: Validations,
            customFailureDescription: String?
        ) {
            self.init(
                key: key,
                valuelessKeyBehavior: required ? .missing : .skipAlways,
                customFailureDescription: customFailureDescription
            ) { decoder in
                do {
                    return try ValidatorResults.Nested(
                        results: validations.validate(decoder).results
                    )
                } catch {
                    return ValidatorResults.Codable(error: error)
                }
            }
        }
        
        init(
            nested key: ValidationKey,
            required: Bool,
            unkeyed factory: @Sendable @escaping (Int, inout Validations) -> (),
            customFailureDescription: String?
        ) {
            self.init(
                key: key,
                valuelessKeyBehavior: required ? .missing : .skipAlways,
                customFailureDescription: customFailureDescription
            ) { decoder in
                do {
                    var container = try decoder.unkeyedContainer()
                    var results: [[ValidatorResult]] = []
                    
                    while !container.isAtEnd {
                        var validations = Validations()
                        factory(container.currentIndex, &validations)
                        try results.append(validations.validate(container.superDecoder()).results)
                    }
                    return ValidatorResults.NestedEach(results: results)
                } catch {
                    return ValidatorResults.Codable(error: error)
                }
            }
        }
        
        init(
            key: ValidationKey,
            result: ValidatorResult,
            customFailureDescription: String?
        ) {
            self.init(
                key: key,
                valuelessKeyBehavior: .ignore,
                customFailureDescription: customFailureDescription
            ) { _ in result }
        }
        
        init(
            key: ValidationKey,
            valuelessKeyBehavior: ValuelessKeyBehavior,
            customFailureDescription: String?,
            run: @escaping @Sendable (Decoder) -> ValidatorResult
        ) {
            self.key = key
            self.valuelessKeyBehavior = valuelessKeyBehavior
            self.customFailureDescription = customFailureDescription
            self.run = run
        }
    }
}

//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 26/03/2025.
//

import Foundation

extension KernelValidation.Validator where T == String {
    public static var url: KernelValidation.Validator<T> {
        .init {
            guard
                let url = Foundation.URL(string: $0),
                url.isFileURL || (url.host != nil && url.scheme != nil)
            else {
                return KernelValidation.ValidatorResults.URL(isValidURL: false)
            }
            return KernelValidation.ValidatorResults.URL(isValidURL: true)
        }
    }
}

extension KernelValidation.ValidatorResults {
    public struct URL {
        public let isValidURL: Bool
    }
}

extension KernelValidation.ValidatorResults.URL: KernelValidation.ValidatorResult {
    public var isFailure: Bool {
        !self.isValidURL
    }
    
    public var successDescription: String? {
        "is a valid URL"
    }
    
    public var failureDescription: String? {
        "is an invalid URL"
    }
}

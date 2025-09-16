//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 28/09/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCSV: ErrorTypeable {
    public enum ErrorTypes: String, KernelSwiftCommon.ErrorTypes {
        case decodingFailed
        case encodingFailed
        case parsingFailed
    }
}

extension KernelCSV {
    public struct CSVCodingError: Error {
        public var errorList: [Error] = []
    }
}

//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/09/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelAppUtils.Application: ErrorTypeable {
    public enum ErrorTypes: String, KernelSwiftCommon.ErrorTypes {
        case unexpectedError
    }
}

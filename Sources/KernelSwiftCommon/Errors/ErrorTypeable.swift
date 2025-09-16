//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 21/09/2023.
//

import Foundation

public protocol ErrorTypeable {
    associatedtype ErrorTypes: KernelSwiftCommon.ErrorTypes
}

extension ErrorTypeable {
    public typealias TypedError = KernelSwiftCommon.TypedError<ErrorTypes>
}

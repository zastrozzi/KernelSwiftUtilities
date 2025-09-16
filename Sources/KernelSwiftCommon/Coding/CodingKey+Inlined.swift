//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 18/06/2025.
//

import Foundation

extension CodingKey {
    public var isInlined: Bool { stringValue == "" }
}

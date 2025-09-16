//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 17/06/2025.
//

import Foundation

extension KernelXML {
    public struct DataBox: Equatable {
        public typealias Value = Data
        
        public let value: Value
        public let format: Format
        
        public init(_ value: Value, format: Format) {
            self.value = value
            self.format = format
        }
        
        public init?(base64 string: String) {
            guard let data = Data(base64Encoded: string) else { return nil }
            self.init(data, format: .base64)
        }
        
        public func xmlString(format: Format) -> String {
            switch format {
            case .base64:
                return value.base64EncodedString()
            }
        }
    }
}

extension KernelXML.DataBox {
    public enum Format: Equatable {
        case base64
    }
}

extension KernelXML.DataBox: KernelXML.Boxable {
    public var isNull: Bool { false }
    public var xmlString: String? { xmlString(format: format) }
}

extension KernelXML.DataBox: KernelXML.SimpleBoxable {}

extension KernelXML.DataBox: CustomStringConvertible {
    public var description: String { value.description }
}

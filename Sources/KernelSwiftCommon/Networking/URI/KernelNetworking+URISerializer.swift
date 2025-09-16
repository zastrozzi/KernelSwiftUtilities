//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 27/03/2025.
//

import Foundation

extension KernelNetworking {
    public struct URISerializer: Sendable {
        private let configuration: Configuration.URICoderConfiguration
        private var data: String
        
        public init(configuration: Configuration.URICoderConfiguration) {
            self.configuration = configuration
            self.data = ""
        }
        
        mutating func serializeNode(_ value: URIEncodedNode, forKey key: String) throws -> String {
            defer { data.removeAll(keepingCapacity: true) }
            try serializeTopLevelNode(value, forKey: key)
            return data
        }
    }
}

extension CharacterSet {
    fileprivate static let unreservedSymbols: CharacterSet = .init(charactersIn: "-._~")
    fileprivate static let unreserved: CharacterSet = .alphanumerics.union(unreservedSymbols)
    fileprivate static let space: CharacterSet = .init(charactersIn: " ")
    fileprivate static let unreservedAndSpace: CharacterSet = .unreserved.union(space)
}

extension KernelNetworking.URISerializer {
    enum SerializationError: Swift.Error, Hashable, CustomStringConvertible, LocalizedError {
        case nestedContainersNotSupported
        case deepObjectsArrayNotSupported
        case deepObjectsWithPrimitiveValuesNotSupported
        case invalidConfiguration(String)
        
        var description: String {
            switch self {
            case .nestedContainersNotSupported: "URISerializer: Nested containers are not supported"
            case .deepObjectsArrayNotSupported: "URISerializer: Deep object arrays are not supported"
            case .deepObjectsWithPrimitiveValuesNotSupported:
                "URISerializer: Deep object with primitive values are not supported"
            case .invalidConfiguration(let string): "URISerializer: Invalid configuration: \(string)"
            }
        }
        
        var errorDescription: String? { description }
    }
    
    private func computeSafeString(_ unsafeString: String) -> String {
        let partiallyEncoded = unsafeString.addingPercentEncoding(withAllowedCharacters: .unreservedAndSpace) ?? ""
        let fullyEncoded = partiallyEncoded.replacingOccurrences(
            of: " ",
            with: configuration.spaceEscapingCharacter.rawValue
        )
        return fullyEncoded
    }
    
    private func stringifiedKey(_ key: String) throws -> String {
        guard !key.isEmpty else { return "" }
        let safeTopLevelKey = computeSafeString(key)
        return safeTopLevelKey
    }
    
    private mutating func serializeTopLevelNode(_ value: KernelNetworking.URIEncodedNode, forKey key: String) throws {
        func unwrapPrimitiveValue(_ node: KernelNetworking.URIEncodedNode) throws -> KernelNetworking.URIEncodedNode.Primitive {
            guard case let .primitive(primitive) = node else { throw SerializationError.nestedContainersNotSupported }
            return primitive
        }
        func unwrapPrimitiveOrArrayOfPrimitives(_ node: KernelNetworking.URIEncodedNode) throws
        -> KernelNetworking.URIEncodedNode.PrimitiveOrArrayOfPrimitivesOrDictionaryOfPrimitives
        {
            if case let .primitive(primitive) = node { return .primitive(primitive) }
            if case let .array(array) = node {
                let primitives = try array.map(unwrapPrimitiveValue)
                return .arrayOfPrimitives(primitives)
            }
            if case let .dictionary(dictionary) = node {
                let unwrappedDictionary: [String: KernelNetworking.URIEncodedNode.PrimitiveOrArrayOfPrimitivesOrDictionaryOfPrimitives] = try dictionary.mapValues {
                    try unwrapPrimitiveOrArrayOfPrimitives($0)
                }
                return .dictionary(unwrappedDictionary)
            }
            throw SerializationError.nestedContainersNotSupported
        }
        switch value {
        case .unset:
            break
        case .primitive(let primitive):
            let keyAndValueSeparator: String?
            switch configuration.style {
            case .form: keyAndValueSeparator = "="
            case .simple: keyAndValueSeparator = nil
            case .deepObject: throw SerializationError.deepObjectsWithPrimitiveValuesNotSupported
            }
            try serializePrimitiveKeyValuePair(primitive, forKey: key, separator: keyAndValueSeparator)
        case .array(let array): try serializeArray(array.map(unwrapPrimitiveValue), forKey: key)
        case .dictionary(let dictionary):
            try serializeDictionary(dictionary.mapValues(unwrapPrimitiveOrArrayOfPrimitives), forKey: key)
        }
    }
    
    private mutating func serializePrimitiveValue(_ value: KernelNetworking.URIEncodedNode.Primitive) throws {
        let stringValue: String
        switch value {
        case .bool(let bool): stringValue = bool.description
        case .string(let string): stringValue = computeSafeString(string)
        case .integer(let int): stringValue = int.description
        case .double(let double): stringValue = double.description
        case .date(let date): stringValue = try computeSafeString(configuration.dateTranscoder.encode(date))
        }
        data.append(stringValue)
    }
    
    private mutating func serializePrimitiveKeyValuePair(
        _ value: KernelNetworking.URIEncodedNode.Primitive,
        forKey key: String,
        separator: String?
    ) throws {
        if let separator {
            data.append(try stringifiedKey(key))
            data.append(separator)
        }
        try serializePrimitiveValue(value)
    }
    
    private mutating func serializeArray(_ array: [KernelNetworking.URIEncodedNode.Primitive], forKey key: String) throws {
        let keyAndValueSeparator: String?
        let pairSeparator: String
        switch (configuration.style, configuration.explode) {
        case (.form, true):
            keyAndValueSeparator = "="
            pairSeparator = "&"
        case (.form, false):
            keyAndValueSeparator = nil
            pairSeparator = ","
        case (.simple, _):
            keyAndValueSeparator = nil
            pairSeparator = ","
        case (.deepObject, _): throw SerializationError.deepObjectsArrayNotSupported
        }
        guard !array.isEmpty else { return }
        func serializeNext(_ element: KernelNetworking.URIEncodedNode.Primitive) throws {
            if let keyAndValueSeparator {
                try serializePrimitiveKeyValuePair(element, forKey: key, separator: keyAndValueSeparator)
            } else {
                try serializePrimitiveValue(element)
            }
        }
        if let containerKeyAndValue = configuration.containerKeyAndValueSeparator {
            data.append(try stringifiedKey(key))
            data.append(containerKeyAndValue)
        }
        for element in array.dropLast() {
            try serializeNext(element)
            data.append(pairSeparator)
        }
        if let element = array.last { try serializeNext(element) }
    }
    
    private mutating func serializeDictionary(
        _ dictionary: [String: KernelNetworking.URIEncodedNode.PrimitiveOrArrayOfPrimitivesOrDictionaryOfPrimitives],
        forKey key: String
    ) throws {
        guard !dictionary.isEmpty else { return }
        let sortedDictionary = dictionary.sorted { a, b in
            a.key.localizedCaseInsensitiveCompare(b.key) == .orderedAscending
        }
        
        let keyAndValueSeparator: String
        let pairSeparator: String
        switch (configuration.style, configuration.explode) {
        case (.form, true):
            keyAndValueSeparator = "="
            pairSeparator = "&"
        case (.form, false):
            keyAndValueSeparator = ","
            pairSeparator = ","
        case (.simple, true):
            keyAndValueSeparator = "="
            pairSeparator = ","
        case (.simple, false):
            keyAndValueSeparator = ","
            pairSeparator = ","
        case (.deepObject, true):
            keyAndValueSeparator = "="
            pairSeparator = "&"
        case (.deepObject, false):
            let reason = "Deep object style is only valid with explode set to true"
            throw SerializationError.invalidConfiguration(reason)
        }
        
        func serializeNestedKey(_ elementKey: String, forKey rootKey: String) -> String {
            guard case .deepObject = configuration.style else { return elementKey }
            if rootKey.isEmpty { return elementKey }
            return rootKey + "[" + elementKey + "]"
        }
        func serializeNext(
            _ element: KernelNetworking.URIEncodedNode.PrimitiveOrArrayOfPrimitivesOrDictionaryOfPrimitives,
            forKey elementKey: String
        ) throws {
            switch element {
            case .primitive(let primitive):
                try serializePrimitiveKeyValuePair(primitive, forKey: elementKey, separator: keyAndValueSeparator)
            case .arrayOfPrimitives(let array):
                guard !array.isEmpty else { return }
                for item in array.dropLast() {
                    try serializePrimitiveKeyValuePair(item, forKey: elementKey, separator: keyAndValueSeparator)
                    data.append(pairSeparator)
                }
                try serializePrimitiveKeyValuePair(array.last!, forKey: elementKey, separator: keyAndValueSeparator)
            case .dictionary(let dictionary):
                guard !dictionary.isEmpty else { return }
                try serializeDictionary(dictionary, forKey: elementKey)
//                for (index, (subElementKey, subElement)) in dictionary.indexed() {
//                    try serializeNext(subElement, forKey: serializeNestedKey(subElementKey, forKey: elementKey))
//                    if index != dictionary.index(dictionary.startIndex, offsetBy: dictionary.count - 1) {
//                        data.append(pairSeparator)
//                    }
////                    data.append(pairSeparator)
//                }
            }
        }
        if let containerKeyAndValue = configuration.containerKeyAndValueSeparator {
            data.append(try stringifiedKey(key))
            data.append(containerKeyAndValue)
        }
        for (elementKey, element) in sortedDictionary.dropLast() {
            try serializeNext(element, forKey: serializeNestedKey(elementKey, forKey: key))
            data.append(pairSeparator)
        }
        if let (elementKey, element) = sortedDictionary.last {
            try serializeNext(element, forKey: serializeNestedKey(elementKey, forKey: key))
        }
    }
}

extension KernelNetworking.Configuration.URICoderConfiguration {
    fileprivate var containerKeyAndValueSeparator: String? {
        switch (style, explode) {
        case (.form, false): return "="
        default: return nil
        }
    }
}

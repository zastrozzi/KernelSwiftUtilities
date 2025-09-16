//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 27/03/2025.
//

import Foundation

extension KernelNetworking {
    enum URIEncodedNode: Equatable {
        case unset
        
        case primitive(Primitive)
        
        case array([Self])
        
        case dictionary([String: Self])
        
        enum Primitive: Equatable {
            
            case bool(Bool)
            
            case string(String)
            
            case integer(Int)
            
            case double(Double)
            
            case date(Date)
        }
        
        enum PrimitiveOrArrayOfPrimitivesOrDictionaryOfPrimitives: Equatable {
            
            case primitive(Primitive)
            
            case arrayOfPrimitives([Primitive])
            indirect case dictionary([String: PrimitiveOrArrayOfPrimitivesOrDictionaryOfPrimitives])
        }
    }
}

extension KernelNetworking.URIEncodedNode {
    enum InsertionError: Swift.Error {
        case settingPrimitiveValueAgain
        case settingValueOnAContainer
        case appendingToNonArrayContainer
        case markingExistingNonArrayContainerAsArray
        case insertingChildValueIntoNonContainer
        case insertingChildValueIntoArrayUsingNonIntValueKey
    }
    
    mutating func set(_ value: Primitive) throws {
        switch self {
        case .unset: self = .primitive(value)
        case .primitive: throw InsertionError.settingPrimitiveValueAgain
        case .array, .dictionary: throw InsertionError.settingValueOnAContainer
        }
    }
    
    mutating func insert<Key: CodingKey>(_ childValue: Self, atKey key: Key) throws {
        switch self {
        case .dictionary(var dictionary):
            self = .unset
            dictionary[key.stringValue] = childValue
            self = .dictionary(dictionary)
        case .array(var array):
            guard let intValue = key.intValue else {
                throw InsertionError.insertingChildValueIntoArrayUsingNonIntValueKey
            }
            precondition(intValue == array.count, "Unkeyed container inserting at an incorrect index")
            self = .unset
            array.append(childValue)
            self = .array(array)
        case .unset:
            if let intValue = key.intValue {
                precondition(intValue == 0, "Unkeyed container inserting at an incorrect index")
                self = .array([childValue])
            } else {
                self = .dictionary([key.stringValue: childValue])
            }
        default: throw InsertionError.insertingChildValueIntoNonContainer
        }
    }
    
    mutating func markAsArray() throws {
        switch self {
        case .array:
            
            break
        case .unset: self = .array([])
        default: throw InsertionError.markingExistingNonArrayContainerAsArray
        }
    }
    
    mutating func append(_ childValue: Self) throws {
        switch self {
        case .array(var items):
            self = .unset
            items.append(childValue)
            self = .array(items)
        case .unset: self = .array([childValue])
        default: throw InsertionError.appendingToNonArrayContainer
        }
    }
}

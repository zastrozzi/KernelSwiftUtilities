//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 16/06/2024.
//

import FluentKit
import KernelSwiftCommon

public protocol KernelFluentFields: Fields, Sendable {}
public protocol KernelFluentCRUDFields: KernelFluentFields {
    associatedtype CreateDTO: Sendable = KernelSwiftCommon.Networking.HTTP.EmptyRequest
    associatedtype UpdateDTO: Sendable = KernelSwiftCommon.Networking.HTTP.EmptyRequest
    associatedtype ResponseDTO: Sendable = KernelSwiftCommon.Networking.HTTP.EmptyResponse
    
    static func createFields(from dto: FieldsCreateDTO) throws -> Self
    static func updateFields(for model: FieldsModel, from dto: FieldsUpdateDTO) throws -> Void
    func response() throws -> ResponseDTO
}

extension KernelFluentFields {
    public func updateIfChanged<Field: Equatable>(
        _ modelKeyPath: ReferenceWritableKeyPath<Self, Field>,
        from dtoValue: Field?
    ) throws {
        if let dtoValue, self[keyPath: modelKeyPath] != dtoValue {
            self[keyPath: modelKeyPath] = dtoValue
        }
    }
}

extension KernelFluentCRUDFields {
    public typealias FieldsModel = Self
    public typealias FieldsCreateDTO = CreateDTO
    public typealias FieldsUpdateDTO = UpdateDTO
    public typealias FieldsResponseDTO = ResponseDTO
    
    public static func createFields(from dto: FieldsCreateDTO?) throws -> Self {
        if let dto {
            try Self.createFields(from: dto)
        } else {
            Self.init()
        }
    }
    
    fileprivate func updateFields(from dto: UpdateDTO) throws {
        try Self.updateFields(for: self, from: dto)
    }
    
    fileprivate func updateFields(from dto: UpdateDTO?) throws {
        if let dto {
            try updateFields(from: dto)
        }
    }
}

extension Fields {
    public func updateIfChanged<
        WrappedFields: KernelFluentCRUDFields
    >(
        _ groupKeyPath: KeyPath<Self, OptionalGroupProperty<Self, WrappedFields>>,
        from dtoValue: WrappedFields.UpdateDTO?
    ) throws
    where WrappedFields.CreateDTO == WrappedFields.UpdateDTO
    {
        let groupValue = self[keyPath: groupKeyPath]
        if groupValue.requiresCreate {
            let newGroup = try WrappedFields.createFields(from: dtoValue)
            groupValue.value = newGroup
        } else {
            try groupValue.value??.updateFields(from: dtoValue)
        }
    }
    
    public func updateIfChanged<
        WrappedFields: KernelFluentCRUDFields
    >(
        _ groupKeyPath: KeyPath<Self, GroupProperty<Self, WrappedFields>>,
        from dtoValue: WrappedFields.UpdateDTO?
    ) throws
    where WrappedFields.CreateDTO == WrappedFields.UpdateDTO
    {
        let groupValue = self[keyPath: groupKeyPath]
        if groupValue.requiresCreate {
            let newGroup = try WrappedFields.createFields(from: dtoValue)
            groupValue.value = newGroup
        } else {
            try groupValue.value?.updateFields(from: dtoValue)
        }
    }
}

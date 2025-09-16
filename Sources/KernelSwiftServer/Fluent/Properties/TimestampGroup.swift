//
//  File.swift
//
//
//  Created by Jonathan Forbes on 14/06/2024.
//

// MARK: WORK IN PROGRESS

import FluentKit
import Foundation

extension Model {
    public typealias TimestampGroup<Format> = TimestampGroupProperty<Self, Format> where Format: TimestampFormat
}


@propertyWrapper
public final class TimestampGroupProperty<Model, Format>
    where Model: FluentKit.Model, Format: TimestampFormat
{
    @TimestampProperty<Model, Format>
    public var createTimestamp: Date?
    
    @TimestampProperty<Model, Format>
    public var updateTimestamp: Date?
    
    @TimestampProperty<Model, Format>
    public var deleteTimestamp: Date?
    
    let format: Format
    
    public var projectedValue: TimestampGroupProperty<Model, Format> {
        self
    }
    
    public var wrappedValue: Timestamps? {
        get {
            switch self.value {
                case .none, .some(.none): return nil
                case .some(.some(let value)): return value
            }
        }
        set {
            self.value = .some(newValue)
        }
    }
    
    public convenience init(
        createKey: FieldKey,
        updateKey: FieldKey,
        deleteKey: FieldKey,
        format: TimestampFormatFactory<Format>
    ) {
        self.init(
            createKey: createKey,
            updateKey: updateKey,
            deleteKey: deleteKey,
            format: format.makeFormat()
        )
    }

    public init(
        createKey: FieldKey,
        updateKey: FieldKey,
        deleteKey: FieldKey,
        format: Format
    ) {
        self._createTimestamp = .init(key: createKey, on: .create, format: format)
        self._updateTimestamp = .init(key: updateKey, on: .update, format: format)
        self._deleteTimestamp = .init(key: deleteKey, on: .delete, format: format)
        self.format = format
    }

    public func touchCreated(date: Date?) {
        self.wrappedValue?.createdAt = date
    }
    
    public func touchUpdated(date: Date?) {
        self.wrappedValue?.updatedAt = date
    }
    
    public func touchDeleted(date: Date?) {
        self.wrappedValue?.deletedAt = date
    }
}

public struct Timestamps: Codable, Equatable, Sendable {
    public var createdAt: Date?
    public var updatedAt: Date?
    public var deletedAt: Date?
    
    public init(
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        deletedAt: Date? = nil
    ) {
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.deletedAt = deletedAt
    }
}
extension TimestampGroupProperty where Format == DefaultTimestampFormat {
    public convenience init(
        createKey: FieldKey = "db_created_at",
        updateKey: FieldKey = "db_updated_at",
        deleteKey: FieldKey = "db_deleted_at"
    ) {
        self.init(createKey: createKey, updateKey: updateKey, deleteKey: deleteKey, format: .default)
    }
}

extension TimestampGroupProperty: CustomStringConvertible {
    public var description: String {
        "@\(Model.self).TimestampGroup(createKey: \(self.createKey), updateKey: \(self.updateKey), deleteKey: \(self.deleteKey))"
    }
    
    public var createKey: FieldKey {
        self.$createTimestamp.$timestamp.key
    }
    
    public var updateKey: FieldKey {
        self.$updateTimestamp.$timestamp.key
    }
    
    public var deleteKey: FieldKey {
        self.$deleteTimestamp.$timestamp.key
    }
}

extension TimestampGroupProperty: AnyProperty {}

extension TimestampGroupProperty: Property {
    public typealias Model = Model
    
    public var value: Timestamps?? {
        get {
            Timestamps(
                createdAt: self.createValue ?? nil,
                updatedAt: self.updateValue ?? nil,
                deletedAt: self.deleteValue ?? nil
            )
        }
        set {
            self.createValue = newValue??.createdAt
            self.updateValue = newValue??.updatedAt
            self.deleteValue = newValue??.deletedAt
        }
    }
    
    public var createValue: Date?? {
        get {
            switch self.$createTimestamp.$timestamp.value {
                case .some(.some(let timestamp)):
                    return .some(self.format.parse(timestamp))
                case .some(.none):
                    return .some(.none)
                case .none:
                    return .none
            }
        }
        set {
            switch newValue {
                case .some(.some(let newValue)):
                self.$createTimestamp.$timestamp.value = .some(self.format.serialize(newValue))
                case .some(.none):
                self.$createTimestamp.$timestamp.value = .some(.none)
                case .none:
                self.$createTimestamp.$timestamp.value = .none
            }
        }
    }
    
    public var updateValue: Date?? {
        get {
            switch self.$updateTimestamp.$timestamp.value {
                case .some(.some(let timestamp)):
                    return .some(self.format.parse(timestamp))
                case .some(.none):
                    return .some(.none)
                case .none:
                    return .none
            }
        }
        set {
            switch newValue {
                case .some(.some(let newValue)):
                self.$updateTimestamp.$timestamp.value = .some(self.format.serialize(newValue))
                case .some(.none):
                self.$updateTimestamp.$timestamp.value = .some(.none)
                case .none:
                self.$updateTimestamp.$timestamp.value = .none
            }
        }
    }
    
    public var deleteValue: Date?? {
        get {
            switch self.$deleteTimestamp.$timestamp.value {
                case .some(.some(let timestamp)):
                    return .some(self.format.parse(timestamp))
                case .some(.none):
                    return .some(.none)
                case .none:
                    return .none
            }
        }
        set {
            switch newValue {
                case .some(.some(let newValue)):
                self.$deleteTimestamp.$timestamp.value = .some(self.format.serialize(newValue))
                case .some(.none):
                self.$deleteTimestamp.$timestamp.value = .some(.none)
                case .none:
                self.$deleteTimestamp.$timestamp.value = .none
            }
        }
    }
}

extension TimestampGroupProperty: AnyDatabaseProperty {
    public var keys: [FieldKey] {
        [
            self.createKey,
            self.updateKey,
            self.deleteKey
        ]
    }
    
    public func input(to input: any DatabaseInput) {
        self.$createTimestamp.input(to: input)
        self.$updateTimestamp.input(to: input)
        self.$deleteTimestamp.input(to: input)
    }
    
    public func output(from output: DatabaseOutput) throws {
        try self.$createTimestamp.output(from: output)
        try self.$updateTimestamp.output(from: output)
        try self.$deleteTimestamp.output(from: output)
    }
}

//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 30/04/2023.
//

import Foundation
import Vapor
import Fluent
//
//public protocol _AuditableModelEvent<AuditedModel>: Model, UnsafeSendable {
//    associatedtype AuditedModel: AuditableModel
//    var affectedSchemaName: String { get set }
//    var actionType: Difference<AuditedModel>.ActionType { get set }
//    var difference: Difference<AuditedModel> { get set }
//    func setRecordId<IDType: Codable>(affectedRecordId: IDType)
//}
//
//extension KernelFluentModel {
//    public final class AuditableModelEvent<AuditedModel: AuditableModel>: _AuditableModelEvent {
//        public typealias AuditedModel = AuditedModel
//        
//        
//        public static var schema: String { "kernel_auditable_model_event" }
//        
//        @ID public var id: UUID?
//        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
//        
//        @Field(key: "affected_schema_name") public var affectedSchemaName: String
//        @KernelEnum(key: "action_type") public var actionType: Difference<AuditedModel>.ActionType
//        @OptionalField(key: "record_id_string") public var recordIdString: String?
//        @OptionalField(key: "record_id_int") public var recordIdInt: Int?
//        @OptionalField(key: "record_id_int16") public var recordIdInt16: Int16?
//        @OptionalField(key: "record_id_int32") public var recordIdInt32: Int32?
//        @OptionalField(key: "record_id_int64") public var recordIdInt64: Int64?
//        @OptionalField(key: "record_id_uuid") public var recordIdUUID: UUID?
//        @KernelEnum(key: "record_id_type") public var recordIdType: RecordIDType
//        @Field(key: "difference") public var difference: Difference<AuditedModel>
//        
//        public enum RecordIDType: String, FluentStringEnum {
//            public static let fluentEnumName: String { "kernel_auditable_model_event__record_id_type" }
//            
//            case string = "string"
//            case int = "int"
//            //        case int8 = "int8"
//            case int16 = "int16"
//            case int32 = "int32"
//            case int64 = "int64"
//            case uuid = "uuid"
//            case unknown = "unknown"
//        }
//        
//        public init() {}
//        
//        public func setRecordId<IDType: Codable>(affectedRecordId: IDType) {
//            let affectedRecordIdType: RecordIDType = Self.determineRecordIdType(type: AuditedModel.IDValue.self)
//            self.recordIdType = affectedRecordIdType
//            switch affectedRecordIdType {
//            case .string: self.recordIdString = affectedRecordId as? String
//            case .int: self.recordIdInt = affectedRecordId as? Int
//            case .int16: self.recordIdInt16 = affectedRecordId as? Int16
//            case .int32: self.recordIdInt32 = affectedRecordId as? Int32
//            case .int64: self.recordIdInt64 = affectedRecordId as? Int64
//            case .uuid: self.recordIdUUID = affectedRecordId as? UUID
//            case .unknown: break
//            }
//        }
//        
//        static func determineRecordIdType<T>(type: T.Type) -> RecordIDType {
//            switch type {
//            case is String.Type: return .string
//            case is Int.Type: return .int
//            case is Int16.Type: return .int16
//            case is Int32.Type: return .int32
//            case is Int64.Type: return .int64
//            case is UUID.Type: return .uuid
//            default: return .unknown
//            }
//        }
//        
//        public static func create(affectedRecordId: AuditedModel.IDValue?, difference: Difference<AuditedModel>, onDB db: @escaping DBAccessor) async throws -> Self {
//            let event = Self.init()
//            event.affectedSchemaName = AuditedModel.schema
//            event.actionType = difference.actionType
//            event.setRecordId(affectedRecordId: affectedRecordId)
//            event.difference = difference
//            try await event.create(on: db())
//            return event
//        }
//    }
//    
//    internal final class EmptyAuditableModel: AuditableModel {
//        public static var schema: String { "EMPTY" }
//        public var auditDate: Date? = nil
//        public var auditCreatedAt: Date? { self.dbCreatedAt }
//        
//        @ID(custom: "id", generatedBy: .user) public var id: UUID?
//        @Timestamp(key: "db_created_at", on: .create) public var dbCreatedAt: Date?
//        @Timestamp(key: "db_updated_at", on: .update) public var dbUpdatedAt: Date?
//        @Timestamp(key: "db_deleted_at", on: .delete) public var dbDeletedAt: Date?
//        
//        public init() {}
//        
//        public enum CodingKeys: CodingKey, CaseIterable, Hashable {
//            case id
//            case dbCreatedAt
//            case dbUpdatedAt
//            case dbDeletedAt
//        }
//        
//        @CodingKeyCollection.Builder
//        public static var keyPathCodingKeyCollection: CodingKeyCollection {
//            (\EmptyAuditableModel.id, CodingKeys.id)
//            (\EmptyAuditableModel.dbCreatedAt, CodingKeys.dbCreatedAt)
//            (\EmptyAuditableModel.dbUpdatedAt, CodingKeys.dbUpdatedAt)
//            (\EmptyAuditableModel.dbDeletedAt, CodingKeys.dbDeletedAt)
//        }
//    }
//}
//
//extension Array where Element: _AuditableModelEvent {
//    public static func create(pairs: [(affectedRecordId: Element.AuditedModel.IDValue, difference: Difference<Element.AuditedModel>)], on database: Database) async throws -> Self {
//        let events = pairs.map { pair in
//            let event = Element.init()
//            event.affectedSchemaName = Element.AuditedModel.schema
//            event.actionType = pair.difference.actionType
//            event.setRecordId(affectedRecordId: pair.affectedRecordId)
//            event.difference = pair.difference
//            return event
//        }
//        try await events.create(on: database)
//        return events
//    }
//}

//
//  File.swift
//  UnionCDP
//
//  Created by Jonathan Forbes on 07/02/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelSignals.Core.APIModel {
    public struct EventTypeResponse: OpenAPIContent {
        public var id: UUID
        
        public var dbCreatedAt: Date
        public var dbUpdatedAt: Date
        public var dbDeletedAt: Date?
        
        public var eventIdentifier: String
        public var payloadSchema: EventPayloadSchema
        
        public init(
            id: UUID,
            dbCreatedAt: Date,
            dbUpdatedAt: Date,
            dbDeletedAt: Date? = nil,
            eventIdentifier: String,
            payloadSchema: EventPayloadSchema
        ) {
            self.id = id
            self.dbCreatedAt = dbCreatedAt
            self.dbUpdatedAt = dbUpdatedAt
            self.dbDeletedAt = dbDeletedAt
            self.eventIdentifier = eventIdentifier
            self.payloadSchema = payloadSchema
        }
        
//        public static var sample: Ether.Core.APIModel.Event.EventTypeResponse {
//            .init(
//                id: .sample,
//                dbCreatedAt: .sample,
//                dbUpdatedAt: .sample,
//                eventIdentifier: "SampleEvent",
//                payloadSchema: [
//                    "userId": .uuid,
//                    "timestamps": .dictionary([
//                        "sessionStart": .date,
//                        "sessionEnd": .date
//                    ]),
//                    "referrerUrl": .string,
//                    "sessionActions": .array(
//                        .dictionary([
//                            "actionName": .string,
//                            "wasSuccessful": .boolean
//                        ])
//                    )
//                ]
//            )
//        }
    }
}

//
//  File.swift
//  UnionCDP
//
//  Created by Jonathan Forbes on 07/02/2025.
//

import KernelSwiftCommon
import Vapor

extension KernelSignals.Core.APIModel {
    public struct UpdateEventTypeRequest: OpenAPIContent {
        public var eventIdentifier: String?
        public var payloadSchema: EventPayloadSchema?
        
        public init(
            eventIdentifier: String? = nil,
            payloadSchema: EventPayloadSchema? = nil
        ) {
            self.eventIdentifier = eventIdentifier
            self.payloadSchema = payloadSchema
        }
        
//        public static var sample: Ether.Core.APIModel.Event.UpdateEventTypeRequest {
//            .init(
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

//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 28/10/2022.
//

import Foundation
import Vapor
import Fluent

public enum KPPaginationOrder: String, Codable, CaseIterable, OpenAPIStringEnumSampleable, Sendable {
    case descending = "desc"
    case ascending = "asc"
    
    public var asSortDirection: DatabaseQuery.Sort.Direction {
        switch self {
        case .ascending: return .ascending
        case .descending: return .descending
        }
    }
    
    public var asSortOrder: SortOrder {
        switch self {
        case .ascending: .forward
        case .descending: .reverse
        }
    }
}

public struct KPPaginatedResponse<ResultType: Codable & Equatable & Content & OpenAPIEncodableSampleable>: Codable, Equatable, Content, OpenAPIEncodableSampleable {
    public static func == (lhs: KPPaginatedResponse<ResultType>, rhs: KPPaginatedResponse<ResultType>) -> Bool {
        lhs.total == rhs.total
    }
    
    public var results: [ResultType]
    public var total: Int
    
    public init(results: [ResultType], total: Int) {
        self.results = results
        self.total = total
    }
    
    public static var sample: KPPaginatedResponse<ResultType> {
        return .init(results: [.sample, .sample, .sample], total: 3)
    }
}


//extension KPPaginatedResponse: OpenAPIEncodableSampleable where ResultType: OpenAPIEncodableSampleable {
//    public static var sample: KPPaginatedResponse<ResultType> {
//        return .init(results: [ResultType.sample], total: 1)
//    }
//    
//    public static func openAPISchema(using encoder: JSONEncoder) throws -> JSONSchema {
//        try nestedGenericOpenAPISchemaGuess(for: Self.self, using: encoder)
//    }
//}

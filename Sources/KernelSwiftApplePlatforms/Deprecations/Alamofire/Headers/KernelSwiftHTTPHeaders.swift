//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/04/2022.
//

import Foundation
import KernelSwiftCommon

@available(*, deprecated)
public struct KernelSwiftHttpHeaders {
    fileprivate typealias HeaderTable = [String: KernelSwiftHttpHeader]
    
    private var table: HeaderTable = [:]
    
    init() {}
    
    init(_ raw: [AnyHashable: Any]?) {
        guard let rawHeaders = raw else { return }
        
        for rawHeader in rawHeaders {
            if let key = rawHeader.key as? String {
                let value = rawHeader.value as? String
                
                if let knownHeader = HeaderType(rawValue: key) {
                    switch knownHeader {
                    case .accept:
                        table[key] = AcceptHeader(value ?? "")
                    case .acceptEncoding:
                        table[key] = AcceptEncodingHeader(value ?? "")
                    case .acceptLanguage:
                        table[key] = AcceptLanguageHeader(value ?? "")
                    case .authorization:
                        table[key] = AuthorizationHeader(value ?? "")
                    case .contentLength:
                        table[key] = ContentLengthHeader(value ?? "")
                    case .contentType:
                        table[key] = ContentTypeHeader(value ?? "")
                    case .connection:
                        table[key] = ConnectionHeader(value ?? "")
//                    @unknown default:
//                        table[key] = CustomHeader(key: key, value: value)
                    }
                } else {
                    table[key] = CustomHeader(key: key, value: value)
                }
                
            }
        }
    }
}

@available(*, deprecated)
extension KernelSwiftHttpHeaders {
    public subscript (key: String) -> String? {
        return table[key]?.value
    }

    public mutating func insert(_ newHeader: KernelSwiftHttpHeader) {
        table[newHeader.key] = newHeader
    }

    @discardableResult
    public mutating func remove(for key: String) -> KernelSwiftHttpHeader? {
        return table.removeValue(forKey: key)
    }
}

@available(*, deprecated)
extension KernelSwiftHttpHeaders {
    public static func >> (lhs: KernelSwiftHttpHeaders, rhs: KernelSwiftHttpHeaders) -> KernelSwiftHttpHeaders {
        var newHeaders = KernelSwiftHttpHeaders()
        newHeaders.table = lhs.table.merging(rhs.table) { lhsValue, _ in return lhsValue }
        return newHeaders
    }

    public static func << (lhs: KernelSwiftHttpHeaders, rhs: KernelSwiftHttpHeaders) -> KernelSwiftHttpHeaders {
        var newHeaders = KernelSwiftHttpHeaders()
        newHeaders.table = lhs.table.merging(rhs.table) { _, rhsValue in return rhsValue }
        return newHeaders
    }
}

@available(*, deprecated)
extension KernelSwiftHttpHeaders: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: KernelSwiftHttpHeader...) {
        table = HeaderTable(elements.map { ($0.key, $0) }) { $1 }
    }
}

@available(*, deprecated)
extension KernelSwiftHttpHeaders: Collection {
    public struct Index: Comparable {
        fileprivate let wrapped: HeaderTable.Index
        
        public static func == (lhs: KernelSwiftHttpHeaders.Index, rhs: KernelSwiftHttpHeaders.Index) -> Bool {
            return lhs.wrapped == rhs.wrapped
        }

        public static func < (lhs: KernelSwiftHttpHeaders.Index, rhs: KernelSwiftHttpHeaders.Index) -> Bool {
            return  lhs.wrapped < rhs.wrapped
        }
    }
    
    public typealias Element = KernelSwiftHttpHeader
    
    public var startIndex: KernelSwiftHttpHeaders.Index {
        return Index(wrapped: table.startIndex)
    }
    public var endIndex: KernelSwiftHttpHeaders.Index {
        return Index(wrapped: table.endIndex)
    }
    
    public subscript (index: KernelSwiftHttpHeaders.Index) -> Element {
        return table[index.wrapped].value
    }
    
    public func index(after i: KernelSwiftHttpHeaders.Index) -> KernelSwiftHttpHeaders.Index {
        return Index(wrapped: table.index(after: i.wrapped))
    }
}

@available(*, deprecated)
extension KernelSwiftHttpHeaders: Printable {
    public var debugDescription: String {
        return """
        {
          \(table.map({ $0.value.debugDescription }).joined(separator: ",\n  "))
        }
        """
    }
}

//extension KernelSwiftHttpHeaders {
//    public func forAlamofire() -> HTTPHeaders {
//        return .init(self.map { HTTPHeader(name: $0.key, value: $0.value ?? "") })
//    }
//}

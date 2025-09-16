//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 09/01/2022.
//

import Foundation
import SwiftUI
import Combine

public typealias LoadableSubject<Value> = Binding<Loadable<Value>>

public enum Loadable<T: Sendable>: Sendable {
    case notRequested
    case isLoading(last: T?, cancelBag: CancelBag)
    case loaded(T)
    case failed(Error)
    
    public var value: T? {
        switch self {
        case .loaded(let value):
            return value
        case .isLoading(let last, _):
            return last
        default:
            return nil
        }
    }
    
    public var error: Error? {
        switch self {
        case .failed(let error):
            return error
        default:
            return nil
        }
    }
}

public extension Loadable {
    mutating func setIsLoading(cancelBag: CancelBag) {
        self = .isLoading(last: value, cancelBag: cancelBag)
    }
    
    mutating func cancelLoading() {
        switch self {
        case .isLoading(let last, _):
//            cancelBag.cancel()
            if let hasLast = last {
                self = .loaded(hasLast)
            } else {
                let error = NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Cancelled by user", comment: "")])
                self = .failed(error)
//                cancelBag.cancel()
            }
        default: break
        }
    }
    
    func map<V>(_ transform: (T) throws -> V) -> Loadable<V> {
        do {
            switch self {
            case .notRequested:
                return .notRequested
            case .isLoading(let last, let cancelBag):
                return .isLoading(last: try last.map { try transform($0) }, cancelBag: cancelBag)
            case .loaded(let value):
                return .loaded(try transform(value))
            case .failed(let error):
                return .failed(error)
            }
        } catch {
            return .failed(error)
        }
    }
}

public protocol SomeOptional {
    associatedtype Wrapped
    func unwrap() throws -> Wrapped
}

public struct ValueIsMissingError: Error {
    public var localizedDescription: String {
        NSLocalizedString("Data is missing", comment: "")
    }
}
//
//extension Optional: SomeOptional {
//    public func unwrap() throws -> Wrapped {
//        switch self {
//        case .some(let value): return value
//        case .none: throw ValueIsMissingError()
//        }
//    }
//}
//
//extension Loadable where T: SomeOptional {
//    public func unwrap() -> Loadable<T.Wrapped> {
//        map { try $0.unwrap() }
//    }
//}

extension Loadable: Equatable where T: Equatable {
    public static func == (lhs: Loadable<T>, rhs: Loadable<T>) -> Bool {
        switch (lhs, rhs) {
        case (.notRequested, .notRequested): return true
        case (.isLoading(let lhsLast, _), .isLoading(let rhsLast, _)): return lhsLast == rhsLast
        case (.loaded(let lhsValue), .loaded(let rhsValue)): return lhsValue == rhsValue
        case (.failed(let lhsError), .failed(let rhsError)): return lhsError.localizedDescription == rhsError.localizedDescription
        default: return false
        }
    }
}


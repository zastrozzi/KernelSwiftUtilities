//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 28/04/2023.
//

import Foundation

public struct DiffableJSON {
    static let encoder = JSONEncoder()
    public static let decoder = JSONDecoder()
}



extension Equatable {
    func isEqual(_ other: any Equatable) -> Bool {
        guard let other = other as? Self else {
            return other.isExactlyEqual(self)
        }
        if let selfAsDate = self as? Date, let otherAsDate = other as? Date {
            return abs(selfAsDate.distance(to: otherAsDate)) < 0.1
        }
        return self == other
    }
    
    private func isExactlyEqual(_ other: any Equatable) -> Bool {
        guard let other = other as? Self else {
            return false
        }
        if let selfAsDate = self as? Date, let otherAsDate = other as? Date {
            return abs(selfAsDate.distance(to: otherAsDate)) < 0.1
        }
        return self == other
    }
}

public struct DiffableDifference<M: Codable> {
    public var previous: Partial<M>?
    public var new: Partial<M>?
}

extension Equatable where Self: Codable {
//    subscript(key: String) -> Any? {
//        return dictionary[key]
//    }
//    
//    var dictionary: [String: Any] {
//        return (try? JSONSerialization.jsonObject(with: DiffableJSON.encoder.encode(self))) as! [String : Any]
//    }
    
//    public func getDifference(with other: Self) -> DiffableDifference<Self> {
////        let keys = Self.diffableKeys
//        let dict1 = self.dictionary
//        let dict2 = other.dictionary
//        var diff1 = Partial<Self>()
//        var diff2 = Partial<Self>()
//        for key in dict1.keys {
//            guard let v1 = dict1[key] as? any Equatable, let v2 = dict2[key] as? any Equatable else {
//                fatalError("")
//            }
//            if !v1.isEqual(v2) {
//                diff1[key] = v2
//                diff2[key] = v1
//            }
//        }
//        return .init(previous: diff1, new: diff2)
//    }
}

public struct Difference<W: PartialCodable>: Codable {
//    typealias V
    
//    public var keyString: String
    public var previous: Partial<W>
    public var next: Partial<W>
    public var actionType: ActionType
    public var hasDifference: Bool
    
    public enum Action {
        case create(next: W?)
        case save(previous: W?, next: W?)
        case update(previous: W?, next: W?)
        case delete(previous: W?)
        case restore(previous: W?, next: W?)
    }
    
    public enum ActionType: String, Codable, Equatable, CaseIterable, FluentStringEnum {
        nonisolated(unsafe) public static var fluentEnumName: String { "kernel_difference__action_type" }
        case create
        case save
        case update
        case delete
        case restore
    }
}

extension Difference.Action {
    public var actionType: Difference.ActionType {
        switch self {
        case .create: return .create
        case .save: return .save
        case .update: return .update
        case .delete: return .delete
        case .restore: return .restore
        }
    }
}

public protocol CodableDiffable: Codable, PartialCodable {
//    func keyString(for key: AnyKeyPath) -> String?
//    static func key<V>(from string: String, type: V.Type) -> KeyPath<Self, V>?
//    static func partialKey(from string: String) -> PartialKeyPath<Self>?
}

public struct EmptyPartialCodable: PartialCodable {
    @CodingKeyCollection.Builder
    public static var keyPathCodingKeyCollection: CodingKeyCollection {
        (\Self.emptyString, CodingKeys.emptyString)
    }
    
    public enum CodingKeys: CodingKey, Hashable, CaseIterable {
        case emptyString
    }
    
    public var emptyString: String
    
    
}

extension PartialCodable {
//    public func value<C: Codable>(from string: String) -> C? {
//        guard let key = self.key(from: string) else { return nil }
//        return self[keyPath: key] as? C
//      }
//    
//
    public static func calculateDifference(for action: Difference<Self>.Action) -> Difference<Self> {
        var prevPartial = Partial<Self>()
        var nextPartial = Partial<Self>()
        var hasDifference: Bool = false
        
        Self.keyPathCodingKeyCollection.keyPaths.forEach { keyPath in
            switch action {
            case .create(let next):
                guard let nv = next?[keyPath: keyPath] as? any Equatable else { return }
                nextPartial.setValue(nv, for: keyPath)
                hasDifference = true
                break
            case .save(let previous, let next):
                guard let pv = previous?[keyPath: keyPath] as? any Equatable, let nv = next?[keyPath: keyPath] as? any Equatable else { return }
                guard !pv.isEqual(nv) else { break }
                nextPartial.setValue(nv, for: keyPath)
                prevPartial.setValue(pv, for: keyPath)
                hasDifference = true
                break
            case .update(let previous, let next):
                guard let pv = previous?[keyPath: keyPath] as? any Equatable, let nv = next?[keyPath: keyPath] as? any Equatable else { return }
                guard !pv.isEqual(nv) else { break }
                nextPartial.setValue(nv, for: keyPath)
                prevPartial.setValue(pv, for: keyPath)
                hasDifference = true
                break
            case .delete(let previous):
                guard let pv = previous?[keyPath: keyPath] as? any Equatable else { return }
                prevPartial.setValue(pv, for: keyPath)
                hasDifference = true
                break
            case .restore(let previous, let next):
                guard let pv = previous?[keyPath: keyPath] as? any Equatable, let nv = next?[keyPath: keyPath] as? any Equatable else { return }
                guard !pv.isEqual(nv) else { break }
                nextPartial.setValue(nv, for: keyPath)
                prevPartial.setValue(pv, for: keyPath)
                hasDifference = true
                break
            }
        }
        
        return .init(previous: prevPartial, next: nextPartial, actionType: action.actionType, hasDifference: hasDifference)
    }
}
//

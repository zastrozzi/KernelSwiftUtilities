//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 21/04/2023.
//

import Foundation

public protocol JSONWebKeyRepresentable: Codable, Equatable {
    associatedtype SignatureAlgorithm: RawRepresentable where SignatureAlgorithm.RawValue == JSONWebSignatureAlgorithm
    associatedtype EncryptionAlgorithm: RawRepresentable where EncryptionAlgorithm.RawValue == JSONWebEncryptionAlgorithm
    
    var kty: JSONWebKeyType? { get set }
    var use: JSONWebKeyUse? { get set }
    var keyOps: [JSONWebKeyOperation]? { get set }
    var alg: JSONWebAlgorithm? { get set }
    var kid: String? { get set }

    var x5u: String? { get set }
    var x5c: [String]? { get set }
    var x5t: String? { get set }
    var x5tS256: String? { get set }

//    var _stored: (any JSONWebKey)? { get set }
//    func concrete<K: JSONWebKey>(type: K.Type) throws -> K
    func thumbprint() throws -> String
//    func concrete<K: JSONWebKey>() throws -> K


}

@dynamicMemberLookup
public enum JSONWebKey {
    case rsa(RSAJSONWebKey)
    case ec(EllipticCurveJSONWebKey)
    case okp(OctetKeyPairJSONWebKey)
    case oct(OctetSequenceJSONWebKey)
}



extension JSONWebKey: Codable {
    public enum CodingKeys: String, CodingKey {
        case kty = "kty"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let singleContainer = try decoder.singleValueContainer()
        let kty = try container.decode(JSONWebKeyType.self, forKey: .kty)
        switch kty {
        case .ec: self = .ec(try singleContainer.decode(EllipticCurveJSONWebKey.self))
        case .oct: self = .oct(try singleContainer.decode(OctetSequenceJSONWebKey.self))
        case .okp: self = .okp(try singleContainer.decode(OctetKeyPairJSONWebKey.self))
        case .rsa: self = .rsa(try singleContainer.decode(RSAJSONWebKey.self))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var singleContainer = encoder.singleValueContainer()
        switch self {
        case .rsa(let key): try singleContainer.encode(key)
        case .ec(let key): try singleContainer.encode(key)
        case .okp(let key): try singleContainer.encode(key)
        case .oct(let key): try singleContainer.encode(key)
        }
    }
    
    public func concrete<K: JSONWebKeyRepresentable>() throws -> K {
        switch self {
        case .rsa(let key):
            guard K.self is RSAJSONWebKey.Type else { throw JOSEError.jwkConcreteConversionFailed }
            return key as! K
        case .ec(let key):
            guard K.self is EllipticCurveJSONWebKey.Type else { throw JOSEError.jwkConcreteConversionFailed }
            return key as! K
        case .okp(let key):
            guard K.self is OctetKeyPairJSONWebKey.Type else { throw JOSEError.jwkConcreteConversionFailed }
            return key as! K
        case .oct(let key):
            guard K.self is OctetSequenceJSONWebKey.Type else { throw JOSEError.jwkConcreteConversionFailed }
            return key as! K
        }
    }
}

public enum JOSEError: Error, CustomStringConvertible, LocalizedError {
    case jwkThumbprintFailed
    case jwkConcreteConversionFailed
    case jwkNoStoredValue
    case jwkNoKeyType
    case jwkKeyTypeMismatch
    
    public var reason: String {
        switch self {
        case .jwkThumbprintFailed: return "JWK Thumbprint computation error"
        case .jwkConcreteConversionFailed: return "JWK Concrete Conversion Failed"
        case .jwkNoStoredValue: return "JWK has no stored value"
        case .jwkNoKeyType: return "JWK has no key type"
        case .jwkKeyTypeMismatch: return "JWK key type does not match"
        }
    }
    
    public var description: String {
        return "JOSEError: \(self.reason)"
    }
    
    public var errorDescription: String? {
        return description
    }
}



public enum JSONWebKeyCommonCodingKeys: String, CodingKey {
    case kty
}

extension JSONWebKeyRepresentable {
//    public init<K: JSONWebKeyRepresentable>(from opaque: K) throws {
//        self = opaque as! Self
//        _stored = opaque
//    }
    
//    public init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: JSONWebKeyCommonCodingKeys.self)
//        guard let keyType = try values.decodeIfPresent(JSONWebKeyType.self, forKey: .kty) else { throw JOSEError.jwkNoKeyType }
//        do {
//            switch keyType {
//            case .ec: try self.init(from: try EllipticCurveJSONWebKey(from: decoder))
//            case .rsa: try self.init(from: try RSAJSONWebKey(from: decoder))
//            case .oct: try self.init(from: try OctetSequenceJSONWebKey(from: decoder))
//            case .okp: try self.init(from: try OctetKeyPairJSONWebKey(from: decoder))
//            }
//        } catch {
//            throw DecodingError.typeMismatch((any JSONWebKey).self, .init(codingPath: [JSONWebKeyCommonCodingKeys.kty], debugDescription: "Failed EC JSONWebKey Generic Decode"))
//        }
//    }
    
//    public func concrete<K: JSONWebKey>(type: K.Type) throws -> K {
//        guard let kty, let stored = _stored else { throw JOSEError.jwkNoStoredValue }
//        guard self._stored is K else { throw JOSEError.jwkKeyTypeMismatch }
//        switch kty {
//        case .rsa: guard K.self is RSAJSONWebKey.Type else { throw JOSEError.jwkKeyTypeMismatch }
//        case .ec: guard K.self is EllipticCurveJSONWebKey.Type else { throw JOSEError.jwkKeyTypeMismatch }
//        case .oct: guard K.self is OctetSequenceJSONWebKey.Type else { throw JOSEError.jwkKeyTypeMismatch }
//        case .okp: guard K.self is OctetKeyPairJSONWebKey.Type else { throw JOSEError.jwkKeyTypeMismatch }
//        }
//        return stored as! K
//    }
//
//    public func toAny() throws -> AnyJSONWebKey {
//        guard let kty else { throw JOSEError.jwkConcreteConversionFailed }
//        return .init(_stored: _stored, kty: kty, use: use, keyOps: keyOps, alg: alg, kid: kid, x5u: x5u, x5t: x5t, x5tS256: x5tS256, x5c: x5c)
//    }
//
//    public func concrete() throws -> any JSONWebKey {
//        guard let kty else { throw JOSEError.jwkNoKeyType }
//        guard let stored = _stored else {
//            throw JOSEError.jwkNoStoredValue
//        }
//
//        switch kty {
//        case .rsa: return stored as! RSAJSONWebKey
//        case .ec: return stored as! EllipticCurveJSONWebKey
//        case .oct: return stored as! OctetSequenceJSONWebKey
//        case .okp: return stored as! OctetKeyPairJSONWebKey
//        }
//    }
    
//    public static func == (lhs: Self, rhs: Self) -> Bool {
//        guard lhs.kty == rhs.kty else { return false }
//        guard lhs.use == rhs.use else { return false }
//        guard lhs.alg == rhs.alg else { return false }
//        guard lhs.kid == rhs.kid else { return false }
//        guard (lhs.keyOps ?? []).elementsEqual((rhs.keyOps ?? [])) else { return false }
//        guard lhs.x5u == rhs.x5u else { return false }
//        guard lhs.x5t == rhs.x5t else { return false }
//        guard lhs.x5tS256 == rhs.x5tS256 else { return false }
//        guard lhs.x5c == rhs.x5c else { return false }
//        return true
//    }
    
//    public static func equals(lhs: any JSONWebKey, rhs: any JSONWebKey) -> Bool {
//        guard lhs.kty == rhs.kty else { return false }
//        guard lhs.use == rhs.use else { return false }
//        guard lhs.alg == rhs.alg else { return false }
//        guard lhs.kid == rhs.kid else { return false }
//        guard (lhs.keyOps ?? []).elementsEqual((rhs.keyOps ?? [])) else { return false }
//        guard lhs.x5u == rhs.x5u else { return false }
//        guard lhs.x5t == rhs.x5t else { return false }
//        guard lhs.x5tS256 == rhs.x5tS256 else { return false }
//        guard lhs.x5c == rhs.x5c else { return false }
//        return true
//    }
    
//    public mutating func setValue<V>(for keyPath: WritableKeyPath<Self, V>, value: V) {
//        self[keyPath: keyPath] = value
//    }
//
//    public mutating func removeValue<V>(for keyPath: WritableKeyPath<Self, Optional<V>>) {
//        self[keyPath: keyPath] = nil
//    }
}

extension JSONWebKey {
    public var kty: JSONWebKeyType? {
        get { self[keyPath: \.kty] }
        set { self[keyPath: \.kty] = newValue }
    }

    public var use: JSONWebKeyUse? {
        get { self[keyPath: \.use] }
        set { self[keyPath: \.use] = newValue }
    }

    public var keyOps: [JSONWebKeyOperation]? {
        get { self[keyPath: \.keyOps] }
        set { self[keyPath: \.keyOps] = newValue }
    }

    public var alg: JSONWebAlgorithm? {
        get { self[keyPath: \.alg] }
        set { self[keyPath: \.alg] = newValue }
    }

    public var kid: String? {
        get { self[keyPath: \.kid] }
        set { self[keyPath: \.kid] = newValue }
    }

    public var x5u: String? {
        get { self[keyPath: \.x5u] }
        set { self[keyPath: \.x5u] = newValue }
    }

    public var x5c: [String]? {
        get { self[keyPath: \.x5c] }
        set { self[keyPath: \.x5c] = newValue }
    }

    public var x5t: String? {
        get { self[keyPath: \.x5t] }
        set { self[keyPath: \.x5t] = newValue }
    }

    public var x5tS256: String? {
        get { self[keyPath: \.x5tS256] }
        set { self[keyPath: \.x5tS256] = newValue }
    }
    
    public subscript<K: JSONWebKeyRepresentable, V>(dynamicMember keyPath: WritableKeyPath<K, V>) -> V {
        get {
            switch self {
            case .ec(let key): return key[keyPath: keyPath as! WritableKeyPath<EllipticCurveJSONWebKey, V>]
            case .oct(let key): return key[keyPath: keyPath as! WritableKeyPath<OctetSequenceJSONWebKey, V>]
            case .okp(let key): return key[keyPath: keyPath as! WritableKeyPath<OctetKeyPairJSONWebKey, V>]
            case .rsa(let key): return key[keyPath: keyPath as! WritableKeyPath<RSAJSONWebKey, V>]
            }
        }
        set {
            switch self {
            case .ec(var key): key[keyPath: keyPath as! WritableKeyPath<EllipticCurveJSONWebKey, V>] = newValue
            case .oct(var key): key[keyPath: keyPath as! WritableKeyPath<OctetSequenceJSONWebKey, V>] = newValue
            case .okp(var key): key[keyPath: keyPath as! WritableKeyPath<OctetKeyPairJSONWebKey, V>] = newValue
            case .rsa(var key): key[keyPath: keyPath as! WritableKeyPath<RSAJSONWebKey, V>] = newValue
            }
        }
    }
    
    public subscript<V>(dynamicMember keyPath: WritableKeyPath<EllipticCurveJSONWebKey, Optional<V>>) -> V? {
        get {
            switch self {
            case .ec(let key): return key[keyPath: keyPath]
            default: return nil
            }
        }
        set {
            switch self {
            case .ec(var key):
                key[keyPath: keyPath] = newValue
                self = .ec(key)
            default: return
            }
        }
    }
    
    public subscript<V>(dynamicMember keyPath: WritableKeyPath<OctetSequenceJSONWebKey, Optional<V>>) -> V? {
        get {
            switch self {
            case .oct(let key): return key[keyPath: keyPath]
            default: return nil
            }
        }
        set {
            switch self {
            case .oct(var key):
                key[keyPath: keyPath] = newValue
                self = .oct(key)
            default: return
            }
        }
    }
    
    public subscript<V>(dynamicMember keyPath: WritableKeyPath<OctetKeyPairJSONWebKey, Optional<V>>) -> V? {
        get {
            switch self {
            case .okp(let key): return key[keyPath: keyPath]
            default: return nil
            }
        }
        set {
            switch self {
            case .okp(var key):
                key[keyPath: keyPath] = newValue
                self = .okp(key)
            default: return
            }
        }
    }
    
    public subscript<V>(dynamicMember keyPath: WritableKeyPath<RSAJSONWebKey, Optional<V>>) -> V? {
        get {
            switch self {
            case .rsa(let key): return key[keyPath: keyPath]
            default: return nil
            }
        }
        set {
            switch self {
            case .rsa(var key):
                key[keyPath: keyPath] = newValue
                self = .rsa(key)
            default: return
            }
        }
    }
}

extension JSONWebKey {
    public func thumbprint() throws -> String {
        switch self {
        case .ec(let key): return try key.thumbprint()
        case .oct(let key): return try key.thumbprint()
        case .okp(let key): return try key.thumbprint()
        case .rsa(let key): return try key.thumbprint()
        }
    }
    
    public func algorithms(for algUse: JSONWebKeyUse) -> [JSONWebAlgorithm] {
        let available: [JSONWebAlgorithm]
        let alg: JSONWebAlgorithm?
        switch self {
        case .ec(let key):
            available = algUse == .encryption ? key.encryptionAlgorithms.map { .encryption($0) } : key.signatureAlgorithms.map { .signature($0) }
            alg = key.alg
        case .oct(let key):
            available = []
            alg = key.alg
        case .okp(let key):
            available = algUse == .encryption ? key.encryptionAlgorithms.map { .encryption($0) } : key.signatureAlgorithms.map { .signature($0) }
            alg = key.alg
        case .rsa(let key):
            available = algUse == .encryption ? key.encryptionAlgorithms.map { .encryption($0) } : key.signatureAlgorithms.map { .signature($0) }
            alg = key.alg
        }
        guard let alg else { return available }
        return available.contains(alg) ? [alg] : []
        
    }
    
//    public mutating func setValue<K: JSONWebKeyRepresentable, V>(for keyPath: WritableKeyPath<K, V>, value: V) {
//        switch self {
//        case .ec: return setValue(for: keyPath as! WritableKeyPath<EllipticCurveJSONWebKey, V>, value: value)
//        case .okp: return setValue(for: keyPath as! WritableKeyPath<OctetKeyPairJSONWebKey, V>, value: value)
//        case .oct: return setValue(for: keyPath as! WritableKeyPath<OctetSequenceJSONWebKey, V>, value: value)
//        case .rsa: return setValue(for: keyPath as! WritableKeyPath<RSAJSONWebKey, V>, value: value)
//        }
//    }
//
//    fileprivate mutating func setValue<V>(for keyPath: WritableKeyPath<EllipticCurveJSONWebKey, V>, value: V) {
//        switch self {
//        case .ec(var key):
//            key.setValue(for: keyPath, value: value)
//            self = .ec(key)
//        default: return
//        }
//    }
//
//    fileprivate mutating func setValue<V>(for keyPath: WritableKeyPath<OctetKeyPairJSONWebKey, V>, value: V) {
//        switch self {
//        case .okp(var key):
//            key.setValue(for: keyPath, value: value)
//            self = .okp(key)
//        default: return
//        }
//    }
//
//    fileprivate mutating func setValue<V>(for keyPath: WritableKeyPath<OctetSequenceJSONWebKey, V>, value: V) {
//        switch self {
//        case .oct(var key):
//            key.setValue(for: keyPath, value: value)
//            self = .oct(key)
//        default: return
//        }
//    }
//
//    fileprivate mutating func setValue<V>(for keyPath: WritableKeyPath<RSAJSONWebKey, V>, value: V) {
//        switch self {
//        case .rsa(var key):
//            key.setValue(for: keyPath, value: value)
//            self = .rsa(key)
//        default: return
//        }
//    }
//
//    public mutating func removeValue<K: JSONWebKeyRepresentable, V>(for keyPath: WritableKeyPath<K, Optional<V>>) {
//        switch self {
//        case .ec: return removeValue(for: keyPath as! WritableKeyPath<EllipticCurveJSONWebKey, Optional<V>>)
//        case .okp: return removeValue(for: keyPath as! WritableKeyPath<OctetKeyPairJSONWebKey, Optional<V>>)
//        case .oct: return removeValue(for: keyPath as! WritableKeyPath<OctetSequenceJSONWebKey, Optional<V>>)
//        case .rsa: return removeValue(for: keyPath as! WritableKeyPath<RSAJSONWebKey, Optional<V>>)
//        }
//    }
//
//    fileprivate mutating func removeValue<V>(for keyPath: WritableKeyPath<EllipticCurveJSONWebKey, Optional<V>>) {
//        switch self {
//        case .ec(var key):
//            key.removeValue(for: keyPath)
//            self = .ec(key)
//        default: return
//        }
//    }
//
//    fileprivate mutating func removeValue<V>(for keyPath: WritableKeyPath<OctetKeyPairJSONWebKey, Optional<V>>) {
//        switch self {
//        case .okp(var key):
//            key.removeValue(for: keyPath)
//            self = .okp(key)
//        default: return
//        }
//    }
//
//    fileprivate mutating func removeValue<V>(for keyPath: WritableKeyPath<OctetSequenceJSONWebKey, Optional<V>>) {
//        switch self {
//        case .oct(var key):
//            key.removeValue(for: keyPath)
//            self = .oct(key)
//        default: return
//        }
//    }
//
//    fileprivate mutating func removeValue<V>(for keyPath: WritableKeyPath<RSAJSONWebKey, Optional<V>>) {
//        switch self {
//        case .rsa(var key):
//            key.removeValue(for: keyPath)
//            self = .rsa(key)
//        default: return
//        }
//    }
//    public mutating func removeValue<V>(for keyPath: WritableKeyPath<Self, Optional<V>>) {
//        self[keyPath: keyPath] = nil
//    }
}

extension JSONWebKeyRepresentable {
//    public func thumbprint() throws -> String {
//        let concreteKey = try concrete()
//        return try concreteKey.thumbprint()
////        throw JOSEError.jwkThumbprintFailed
//    }
    
//    public func algorithms(for algUse: JSONWebKeyUse) -> [JSONWebAlgorithm] {
//        guard let kty else { return [] }
//        guard use == nil || use == algUse else { return [] }
//        let available: [JSONWebAlgorithm]
//        switch kty {
//        case .oct: return []
//        case .rsa:
//            guard let concreteKey = try? concrete(type: RSAJSONWebKey.self) else { return [] }
//            switch algUse {
//            case .encryption: available = concreteKey.encryptionAlgorithms.map { .encryption($0) }
//            case .signature: available = concreteKey.signatureAlgorithms.map { .signature($0) }
//            }
//        case .ec:
//            guard let concreteKey = try? concrete(type: EllipticCurveJSONWebKey.self) else { return [] }
//            switch algUse {
//            case .encryption: available = concreteKey.encryptionAlgorithms.map { .encryption($0) }
//            case .signature: available = concreteKey.signatureAlgorithms.map { .signature($0) }
//            }
//        case .okp:
//            guard let concreteKey = try? concrete(type: OctetKeyPairJSONWebKey.self) else { return [] }
//            switch algUse {
//            case .encryption: available = concreteKey.encryptionAlgorithms.map { .encryption($0) }
//            case .signature: available = concreteKey.signatureAlgorithms.map { .signature($0) }
//            }
//        }
//        guard let alg else { return available }
//        return available.contains(alg) ? [alg] : []
//    }
}
//
//extension JSONWebKey {
//    public static func rsa(
//        use: JSONWebKeyUse? = nil,
//        keyOps: [JSONWebKeyOperation]? = nil,
//        alg: JSONWebAlgorithm? = nil,
//        kid: String? = nil,
//        n: String? = nil,
//        e: String? = nil,
//        d: String? = nil,
//        p: String? = nil,
//        q: String? = nil,
//        dp: String? = nil,
//        dq: String? = nil,
//        qi: String? = nil,
//        oth: [JSONWebKeyOtherPrimeInfo]? = nil,
//        x5u: String? = nil,
//        x5t: String? = nil,
//        x5tS256: String? = nil,
//        x5c: [String]? = nil
//    ) -> RSAJSONWebKey {
//        .init(
//            use: use,
//            keyOps: keyOps,
//            alg: alg,
//            kid: kid,
//            n: n,
//            e: e,
//            d: d,
//            p: p,
//            q: q,
//            dp: dp,
//            dq: dq,
//            qi: qi,
//            oth: oth,
//            x5u: x5u,
//            x5t: x5t,
//            x5tS256: x5tS256,
//            x5c: x5c
//        )
//    }
//
//    public static func ec(
//        crv: JSONWebEllipticCurve? = nil,
//        x: String? = nil,
//        y: String? = nil,
//        d: String? = nil,
//        use: JSONWebKeyUse? = nil,
//        alg: JSONWebAlgorithm? = nil,
//        kid: String? = nil,
//        keyOps: [JSONWebKeyOperation]? = nil,
//        x5u: String? = nil,
//        x5t: String? = nil,
//        x5tS256: String? = nil,
//        x5c: [String]? = nil
//    ) -> EllipticCurveJSONWebKey {
//        .init(
//            crv: crv,
//            x: x,
//            y: y,
//            d: d,
//            use: use,
//            alg: alg,
//            kid: kid,
//            keyOps: keyOps,
//            x5u: x5u,
//            x5t: x5t,
//            x5tS256: x5tS256,
//            x5c: x5c
//        )
//    }
//}
//

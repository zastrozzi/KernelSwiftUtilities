//
//  File.swift
//
//
//  Created by Jonathan Forbes on 18/09/2023.
//

import Foundation

extension KernelCBOR {
    public struct CBORCodingOptions {
        let keyCodingStrategy: KeyCodingStrategy
        let dateCodingStrategy: DateCodingStrategy
        let mapCodingStrategy: MapCodingStrategy
        let lengthCodingStrategy: LengthCodingStrategy
        let integerCodingStrategy: IntegerCodingStrategy
        
        public init(
            keyCodingStrategy: KeyCodingStrategy = .flexible,
            dateCodingStrategy: DateCodingStrategy = .taggedEpochDateTime,
            mapCodingStrategy: MapCodingStrategy = .flexible,
            lengthCodingStrategy: LengthCodingStrategy = .definite(truncatingIfPossible: true),
            integerCodingStrategy: IntegerCodingStrategy = .minimum(truncatingIfPossible: true)
        ) {
            self.keyCodingStrategy = keyCodingStrategy
            self.dateCodingStrategy = dateCodingStrategy
            self.mapCodingStrategy = mapCodingStrategy
            self.lengthCodingStrategy = lengthCodingStrategy
            self.integerCodingStrategy = integerCodingStrategy
        }
    }
}

extension KernelCBOR.CBORCodingOptions {
    public enum KeyCodingStrategy {
        case stringKeys
        case flexible
    }
    
    public enum DateCodingStrategy {
        case taggedEpochDateTime
        case annotatedMap
    }
    
    public enum MapCodingStrategy {
        case requireStringKeys
        case flexible
    }
    
    public enum LengthCodingStrategy {
        case definite(truncatingIfPossible: Bool)
        case indefinite
    }
    
    public enum IntegerCodingStrategy {
        case minimum(truncatingIfPossible: Bool)
        case maximum
        case fixed(integerType: any UnsignedInteger.Type, truncatingIfPossible: Bool)
    }
}

extension KernelCBOR.CBORCodingOptions.DateCodingStrategy {
    public enum AnnotatedMap {
        static let type = "__type"
        static let value = "__value"
        static let typeValue = "date_epoch_timestamp"
    }
}

extension KernelCBOR.CBORCodingOptions.LengthCodingStrategy {
    public var truncatingIfPossible: Bool {
        switch self {
        case let .definite(truncatingIfPossible): truncatingIfPossible
        case .indefinite: false
        }
    }
}

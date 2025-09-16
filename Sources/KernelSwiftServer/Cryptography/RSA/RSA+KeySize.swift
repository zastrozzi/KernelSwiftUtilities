//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/10/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelCryptography.RSA {
    public enum KeySize: String, Codable, Equatable, CaseIterable, RawRepresentableAsString, FluentStringEnum, OpenAPIStringEnumSampleable, Sendable, LosslessStringConvertible {
        public init?(_ description: String) {
            self.init(rawValue: description)
        }
        
        public var description: String {
            self.rawValue
        }
        
        public static let fluentEnumName: String = "k_crypto-rsa_key_size"
        case b256   = "b256"
        case b512   = "b512"
        case b768   = "b768"
        case b1024  = "b1024"
        case b1280  = "b1280"
        case b1536  = "b1536"
        case b2048  = "b2048"
        case b3072  = "b3072"
        case b4096  = "b4096"
        case b7680  = "b7680"
        case b8192  = "b8192"
        case b15360 = "b15360"
        case b16384 = "b16384"
        
        public var intValue: Int {
            switch self {
            case .b256  : 256
            case .b512  : 512
            case .b768  : 768
            case .b1024 : 1024
            case .b1280 : 1280
            case .b1536 : 1536
            case .b2048 : 2048
            case .b3072 : 3072
            case .b4096 : 4096
            case .b7680 : 7680
            case .b8192 : 8192
            case .b15360: 15360
            case .b16384: 16384
            }
        }
        
        public var byteWidth: Int { intValue / 8 }
        
        public init(_ intValue: Int, withTolerance t: Int = .zero) throws {
            if t != .zero {
                switch intValue {
                case (256   - t)...(256   + t)  : self = .b256
                case (512   - t)...(512   + t)  : self = .b512
                case (768   - t)...(768   + t)  : self = .b768
                case (1024  - t)...(1024  + t)  : self = .b1024
                case (1280  - t)...(1280  + t)  : self = .b1280
                case (1536  - t)...(1536  + t)  : self = .b1536
                case (2048  - t)...(2048  + t)  : self = .b2048
                case (3072  - t)...(3072  + t)  : self = .b3072
                case (4096  - t)...(4096  + t)  : self = .b4096
                case (7680  - t)...(7680  + t)  : self = .b7680
                case (8192  - t)...(8192  + t)  : self = .b8192
                case (15360 - t)...(15360 + t)  : self = .b15360
                case (16384 - t)...(16384 + t)  : self = .b16384
                default: throw KernelCryptography.TypedError(.invalidKeyLength)
                }
            }
            else {
                switch intValue {
                case 256    ... 256    : self = .b256
                case 512    ... 512    : self = .b512
                case 768    ... 768    : self = .b768
                case 1024   ... 1024   : self = .b1024
                case 1280   ... 1280   : self = .b1280
                case 1536   ... 1536   : self = .b1536
                case 2048   ... 2048   : self = .b2048
                case 3072   ... 3072   : self = .b3072
                case 4096   ... 4096   : self = .b4096
                case 7680   ... 7680   : self = .b7680
                case 8192   ... 8192   : self = .b8192
                case 15360  ... 15360  : self = .b15360
                case 16384  ... 16384  : self = .b16384
                default: throw KernelCryptography.TypedError(.invalidKeyLength)
                }
            }
        }
    }
}

extension KernelCryptography.RSA.KeySize {
    public static var sample: KernelCryptography.RSA.KeySize {
        let smallSamples: [Self] = [.b256, .b512, .b768, .b1024, .b1280, .b1536, .b2048, .b3072, .b4096]
        return smallSamples.randomElement()!
    }
}

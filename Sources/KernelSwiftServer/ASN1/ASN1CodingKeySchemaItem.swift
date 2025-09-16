//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 09/07/2023.
//

//public struct ASN1CodingKeySchemaItem<R: ASN1TypedDecodable> {
//    public var keyPath: AnyKeyPath
//    public var dataType: KernelASN1.ASN1Type.RawType
//    public var rootType: R.Type
//    public var decodedType: ASN1Decodable.Type
//    
//    public init?(stringValue: String) {
//        return nil
//    }
//    
//    public init<T: ASN1Decodable>(from keyPath: WritableKeyPath<R, T>, dataType: KernelASN1.ASN1Type.RawType, rootType: R.Type = R.self, decodedType: T.Type) {
//        self.keyPath = keyPath
//        //        self.stringValue = codingKey.stringValue
//        self.dataType = dataType
//        self.rootType = rootType
//        self.decodedType = decodedType
//    }
//    
//    public init?(intValue: Int) {
//        return nil
//    }
//    
//    public static func == (lhs: Self, rhs: Self) -> Bool {
//        lhs.decodedType == rhs.decodedType &&
//        lhs.rootType == rhs.rootType &&
//        lhs.dataType == rhs.dataType
//    }
//    
//    public func hash(into hasher: inout Hasher) {
//        dataType.hash(into: &hasher)
//    }
//}

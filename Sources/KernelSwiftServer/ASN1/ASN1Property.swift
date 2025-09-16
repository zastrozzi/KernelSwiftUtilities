//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 06/07/2023.
//

public typealias ASN1<Value> = KernelASN1.ASN1Property<Value> where Value: ASN1Decodable
//public typealias ASN1 = KernelASN1.ASN1Property<Self> where Self: ASN1Codable

extension KernelASN1 {
    @propertyWrapper
    public final class ASN1Property<Value: ASN1Decodable> {
        public var underlyingData: [UInt8]
        public var type: KernelASN1.ASN1Type.RawType
        public var innerValue: Value? = nil
        
        public init(type: KernelASN1.ASN1Type.RawType) {
            self.type = type
            self.underlyingData = []
        }
        
        public var projectedValue: KernelASN1.ASN1Type.RawType {
            return type
        }
        
        public var wrappedValue: Value {
            get {
                guard let value = self.innerValue else {
                    fatalError("Cannot access enum array field before it is initialized or fetched")
                }
                return value
            }
            set {
                self.innerValue = newValue
            }
        }
    }
}

extension AnyKeyPath {
    public var stringValue: String {
        let desc = String(describing: self)
        print(desc, "desc", self)
        let refl = String(reflecting: self)
        print(refl, "refl", self)
        if #available(macOS 13.3, iOS 16.4, *) {
            let debug = debugDescription
            print(debug, "debug", self)
        } else {
            // Fallback on earlier versions
        }
        let inter = "\(self)"
        print(inter, "inter", self)
        return "nothing for now"
    }
}

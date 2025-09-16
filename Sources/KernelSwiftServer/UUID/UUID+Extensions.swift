//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/05/2023.
//

import Foundation
import UniqueID
import KernelSwiftCommon

extension UUID {
    public static let zero: UUID = .init(UniqueID(bytes: UniqueID.zeroBytes))
    
    public var uuidV1Timestamp: Date? {
//        let gregorianOffset = 122192928000000000
//        let timeStrPrefix = self.uuidString[self.uuidString.index(self.uuidString.startIndex, offsetBy: 16)...self.uuidString.index(self.uuidString.startIndex, offsetBy: 18)]
        return nil
    }
}

//extension UUID: @retroactive _KernelSampleable {}
//extension UUID: @retroactive _KernelAbstractSampleable {}
extension UUID: _KernelSampleable {}
extension UUID: _KernelAbstractSampleable {}
extension UUID: OpenAPIEncodableSampleable {
    public static let sample: UUID = .zero
}

extension UUID {
    public static func timeOrderedUUIDV4() -> UUID { UniqueID.timeOrdered().asVersion4UUID() }
}

extension UniqueID {
    public static let zeroBytes: Bytes = (
        .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero,
        .zero, .zero, .zero, .zero, .zero, .zero, .zero, .zero
    )
    
    public func bytesArray() -> Array<UInt8> {
        var arr: Array<UInt8> = []
        arr.append(contentsOf: [
            UInt8(bytes.0), UInt8(bytes.1), UInt8(bytes.2), UInt8(bytes.3),
            UInt8(bytes.4), UInt8(bytes.5), UInt8(bytes.6), UInt8(bytes.7),
            UInt8(bytes.8), UInt8(bytes.9), UInt8(bytes.10), UInt8(bytes.11),
            UInt8(bytes.12), UInt8(bytes.13), UInt8(bytes.14), UInt8(bytes.15)
        ])
        return arr
    }
    
    public func timestampBytes() -> Array<UInt8> {
        return Array(bytesArray().prefix(upTo: 8))
    }
    
    public func sequenceBytes() -> Array<UInt8> {
        return Array(bytesArray().dropFirst(8).prefix(upTo: 2))
    }
    
    public func nodeBytes() -> Array<UInt8> {
        return Array(bytesArray().dropFirst(10))
    }
    
    public func sequenceAndNodeBytes() -> Array<UInt8> {
        return Array(bytesArray().dropFirst(8))
    }
    
    public func asVersion4UUID() -> UUID {
        var newArr = self.bytesArray()
        newArr[6] = .ascii.A
        return .init(uuidByteArray: newArr)
        
    }
    
    public init?<ByteCollection: Collection<UInt8>>(_ tsBytes: ByteCollection, _ seqBytes: ByteCollection, _ nodeBytes: ByteCollection) {
        guard tsBytes.count + seqBytes.count + nodeBytes.count == 16 else { fatalError("needed 16 bytes") }
        self.init(bytes: [tsBytes, seqBytes, nodeBytes].joined())
    }
    
    public init?<ByteCollection: Collection<UInt8>>(from source: UniqueID, withTsBytes tsBytes: ByteCollection? = nil, withSeqBytes seqBytes: ByteCollection? = nil, withNodeBytes nodeBytes: ByteCollection? = nil) {
        guard let tsBytes = tsBytes ?? (source.timestampBytes() as? ByteCollection), let seqBytes = seqBytes ?? (source.sequenceBytes() as? ByteCollection), let nodeBytes = nodeBytes ?? (source.nodeBytes() as? ByteCollection) else { fatalError("Failed to convert byte collections") }
        guard tsBytes.count + seqBytes.count + nodeBytes.count == 16 else { fatalError("needed 16 bytes") }
        self.init(bytes: [tsBytes, seqBytes, nodeBytes].joined())
    }
}

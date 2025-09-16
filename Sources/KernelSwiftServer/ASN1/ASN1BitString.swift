//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 15/06/2023.
//

extension KernelASN1 {
    public struct ASN1BitString: ASN1Codable {
        public var underlyingData: [UInt8]?
        public var unusedBits: Int
        public var value: [UInt8]
        
        public var bitValue: [UInt] {
            let size = MemoryLayout<UInt>.size
            var values: [UInt] = []
            let unusedBits: UInt = UInt(unusedBits)
            let lowerBitsMask: UInt = (1 << unusedBits) - 1
            let numValues = value.count
            var v: UInt = 0
            let lengthOfMostSignificant = value.count % size
            
            for i in 0..<numValues {
                let b = UInt(value[i])
                v += b >> unusedBits
                
                if (i + 1) % size == lengthOfMostSignificant {
                    values.append(v)
                    v = 0
                }
                v = v << 8
                v += (b & lowerBitsMask) << (8 - unusedBits)
            }
            
            if numValues % size != lengthOfMostSignificant {
                values.append(v)
            }
            return values
        }
        
        public var writableBytes: [UInt8] {
            var writableData: [UInt8] = [.init(unusedBits)]
            if unusedBits == 0 { writableData += value }
            else {
                let mask: UInt8 = 0xff - (UInt8(1 << unusedBits) - 1)
                writableData += value[0..<(value.count - 1)]
                writableData += [value[value.count - 1] & mask]
            }
            return writableData
        }
        
        public init(unusedBits: Int, data: [UInt8]) {
            self.unusedBits = unusedBits
            if unusedBits == 0 {
                self.value = data
            } else {
                let mask: UInt8 = .asn1.max - (UInt8(1 << unusedBits) - 1)
                self.value = data[0..<(data.count - 1)] + [data[data.count - 1] & mask]
            }
        }
        
        public func printString(fullLength: Bool = true, depth: Int = 0) -> String {
            var str: String = ""
            for (index, byte) in value.enumerated() {
                var byteStr = String(repeating: "0", count: min(byte.leadingZeroBitCount, 7))
                byteStr += String(byte, radix: 2)
                if index == value.index(before: value.endIndex) {
                    if unusedBits == .zero || byteStr.suffix(unusedBits).contains("1") { str += byteStr }
                    else {
                        let trimmed = byteStr.dropLast(unusedBits)
                        str += trimmed
                    }
                }
                else { str += byteStr }
//                wordStr += String(repeating: "0", count: word.trailingZeroBitCount / 8)
//                str += .tabbedNewLine(tabCount: depth)
            }
            let strLines = (value.count / 8)
            var printStr: String = ""
//            printStr += .tabbedNewLine(tabCount: depth)
            printStr += "Total: \(str.count)"
            let skipped = max(0, str.count - (64 * 4))
            if !fullLength && skipped > 0 { printStr += ", Hidden: \(skipped)" }
            printStr += ") ["
            for line in 0...(fullLength ? strLines : min(strLines, 3)) {
                let lineStr = str.dropFirst(line * 64).prefix(64)
                if !lineStr.isEmpty {
                    printStr += .tabbedNewLine(tabCount: depth)
                    printStr += lineStr
                }
            }
            if !fullLength && skipped > 0 {
                printStr += .tabbedNewLine(tabCount: depth)
                printStr += "..."
            }
            return printStr
        }
        
        
        public func isEqualTo<O>(_ other: O) -> Bool where O : ASN1Codable {
            guard let other = other as? Self else { return false }
            return self.value == other.value && self.unusedBits == other.unusedBits
        }
    }
}

extension KernelASN1.ASN1BitString: ASN1Decodable, ASN1Buildable {
    public init(from asn1Type: KernelASN1.ASN1Type) throws {
        guard case let .bitString(bitStr) = asn1Type else { throw KernelASN1.TypedError(.decodingFailed) }
        self = bitStr
    }
    
    public func buildASN1Type() -> KernelASN1.ASN1Type { .bitString(self) }
}

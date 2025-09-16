//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 16/06/2023.
//

import KernelSwiftCommon

extension KernelASN1 {
    public struct ASN1Printer {
        
        public static func printObjectVerbose(_ object: ASN1Type.VerboseTypeWithMetadata, depth: Int = 0, fullLength: Bool = false, tagged: Bool = false, decodedOctets: Bool = false, decodedBits: Bool = false, printMetadata: Bool = false) {
            let parsingMetadataPrintString = object.parsingMetadata?.printerString(printMetadata) ?? ""
            let writingMetadataPrintString = object.writingMetadata?.printerString(printMetadata) ?? ""
            let combinedMetadataPrintString = parsingMetadataPrintString + writingMetadataPrintString
            if !tagged {
                for _ in 0..<depth { print(String.tab(), terminator: "") }
            }
            
            switch object.type {
            case .boolean(let asn1Boolean):
                print("BOOLEAN \(combinedMetadataPrintString)" + (asn1Boolean.value ? "true" : "false"))
            case .integer(let asn1Integer):
                let intStr = asn1Integer.int.toString(radix: 10, uppercase: true)
                if !fullLength && intStr.count > 64 {
                    print("INTEGER \(combinedMetadataPrintString)(\(asn1Integer.int.bitWidth) bit) (\(intStr.prefix(64))...)")
                } else {
                    print("INTEGER \(combinedMetadataPrintString)(\(intStr))")
                }
                
            case .bitString(let asn1BitString):
                if !decodedBits {
                    print("BIT_STRING \(combinedMetadataPrintString)(Unused: \(asn1BitString.unusedBits), \(asn1BitString.printString(fullLength: fullLength, depth: depth + 1))\(String.tabbedNewLine(tabCount: depth))]")
                } else {
                    do {
                        let decodedObject = try KernelASN1.ASN1Parser4.objectFromBytes(asn1BitString.value)
                        print("BIT_STRING \(combinedMetadataPrintString)(Unused: \(asn1BitString.unusedBits), Total: \((asn1BitString.value.count * 8) - asn1BitString.unusedBits)) [")
                        printObjectVerbose(decodedObject, depth: depth + 1, fullLength: fullLength, decodedOctets: decodedOctets, decodedBits: decodedBits)
                        print(String.tabs(tabCount: depth) + "]")
                    } catch {
                        print("BIT_STRING \(combinedMetadataPrintString)(Unused: \(asn1BitString.unusedBits), \(asn1BitString.printString(fullLength: fullLength, depth: depth + 1))\(String.tabbedNewLine(tabCount: depth))]")
                    }
                }
            case .octetString(let asn1OctetString):
                if !decodedOctets {
                    let remaining = max(0, asn1OctetString.value.count - 64)
                    let skippingText = remaining > 0 && !fullLength ? ", Hidden: \(remaining))" : ")"
                    let bytes = (fullLength || remaining <= 0) ? asn1OctetString.value : (.init(asn1OctetString.value.prefix(32)) + .init(asn1OctetString.value.suffix(32)))
                    print("OCTET_STRING \(combinedMetadataPrintString)(Total: \(asn1OctetString.value.count)\(skippingText) [\(printableHexString(bytes, depth: depth, fullLength: fullLength))\(String.tabbedNewLine(tabCount: depth))]")
                } else {
                    do {
                        let decodedObject = try KernelASN1.ASN1Parser4.objectFromBytes(asn1OctetString.value)
                        print("OCTET_STRING \(combinedMetadataPrintString)(Total: \(asn1OctetString.value.count)) [")
                        printObjectVerbose(decodedObject, depth: depth + 1, fullLength: fullLength, decodedOctets: decodedOctets, decodedBits: decodedBits)
                        print(String.init(repeating: .tab(), count: depth) + "]")
                    } catch {
                        let remaining = max(0, asn1OctetString.value.count - 64)
                        let skippingText = remaining > 0 && !fullLength ? ", Hidden: \(remaining))" : ")"
                        let bytes = (fullLength || remaining <= 0) ? asn1OctetString.value : (.init(asn1OctetString.value.prefix(32)) + .init(asn1OctetString.value.suffix(32)))
                        print("OCTET_STRING \(combinedMetadataPrintString)(Total: \(asn1OctetString.value.count)\(skippingText) [\(printableHexString(bytes, depth: depth, fullLength: fullLength))\(String.tabbedNewLine(tabCount: depth))]")
                    }
                }
            case .null:
                print("NULL \(combinedMetadataPrintString)")
            case .objectIdentifier(let asn1ObjectIdentifier):
                print("OBJECT_IDENTIFIER \(combinedMetadataPrintString)", terminator: "")
                if let oid = asn1ObjectIdentifier.oid {
                    print("\(oid) ", terminator: "")
                }
                for i in 0 ..< asn1ObjectIdentifier.identifier.count {
                    if i != asn1ObjectIdentifier.identifier.count - 1 {
                        print("\(asn1ObjectIdentifier.identifier[i]).", terminator: "")
                    }
                    else {
                        print("\(asn1ObjectIdentifier.identifier[i])", terminator: "")
                    }
                }
                print("")
            case .printableString(let asn1PrintableString):
                print(asn1PrintableString.descriptionWithMeta(combinedMetadataPrintString))
            case .utf8String(let asn1UTF8String):
                print(asn1UTF8String.descriptionWithMeta(combinedMetadataPrintString))
            case .t61String(let asn1T61String):
                print(asn1T61String.descriptionWithMeta(combinedMetadataPrintString))
            case .ia5String(let asn1IA5String):
                print(asn1IA5String.descriptionWithMeta(combinedMetadataPrintString))
            case .graphicString(let asn1GraphicString):
                print(asn1GraphicString.descriptionWithMeta(combinedMetadataPrintString))
            case .generalString(let asn1GeneralString):
                print(asn1GeneralString.descriptionWithMeta(combinedMetadataPrintString))
            case .bmpString(let asn1String):
                print(asn1String.descriptionWithMeta(combinedMetadataPrintString))
            case .visibleString(let asn1String):
                print(asn1String.descriptionWithMeta(combinedMetadataPrintString))
            case .utcTime(let asn1UTCTime):
                print(asn1UTCTime.descriptionWithMeta(combinedMetadataPrintString))
            case .generalisedTime(let asn1GeneralisedTime):
                print(asn1GeneralisedTime.descriptionWithMeta(combinedMetadataPrintString))
            case .sequence(let array):
                print("SEQUENCE \(combinedMetadataPrintString)(\(array.count) elem\(array.count == 1 ? "" : "s"))")
                for o in array {
                    printObjectVerbose(o, depth: depth + 1, fullLength: fullLength, decodedOctets: decodedOctets, decodedBits: decodedBits, printMetadata: printMetadata)
                }
                
            case .set(let array):
                print("SET \(combinedMetadataPrintString)(\(array.count) elem\(array.count == 1 ? "" : "s"))")
                for o in array {
                    printObjectVerbose(o, depth: depth + 1, fullLength: fullLength, decodedOctets: decodedOctets, decodedBits: decodedBits, printMetadata: printMetadata)
                }
            case .tag(let tag, let constructed, let item, let items):
                if !constructed {
                    guard let item else { print("Unsupported Tag"); break }
                    print("[\(tag)] ")
                    printObjectVerbose(item, depth: depth + 1, fullLength: fullLength, decodedOctets: decodedOctets, decodedBits: decodedBits, printMetadata: printMetadata)
                } else {
                    let items = items ?? (item == nil ? [] : [item!])
                    print("[\(tag)] \(combinedMetadataPrintString)(\(items.count) elem\(items.count == 1 ? "" : "s"))")
                    for o in items {
                        printObjectVerbose(o, depth: depth + 1, fullLength: fullLength, decodedOctets: decodedOctets, decodedBits: decodedBits, printMetadata: printMetadata)
                    }
                }
                
                
//            case .nonConstructedTag(let tag, let item):
//                print("[\(tag)] ")
//                printObjectVerbose(item, depth: depth + 1, fullLength: fullLength, decodedOctets: decodedOctets, decodedBits: decodedBits, printMetadata: printMetadata)
//            case .any(let asn1Object):
            case .any(let asn1Object):
                if let asString = String(bytes: asn1Object.anyData, encoding: .utf8) {
//                    print("ANY \(asString)")
                    print("ANY \(combinedMetadataPrintString)\(asString)")
                } else {
                    print("ANY \(combinedMetadataPrintString)\(printableHexString(asn1Object.anyData, depth: depth))")
                }
//                print("ANY \(combinedMetadataPrintString)\(printableHexString(asn1Object.anyData, depth: depth))")
            case .unknown:
                print("Unhandled Type")
            case .berTerminator: print("BER TERMINATOR")
            }
        }
        
        public static func printObject(_ object: ASN1Type, depth: Int = 0, fullLength: Bool = false, tagged: Bool = false, decodedOctets: Bool = false) {
            if !tagged {
                for _ in 0..<depth { print(String.tab(), terminator: "") }
            }
            
            switch object {
            case .boolean(let asn1Boolean):
                print("BOOLEAN " + (asn1Boolean.value ? "true" : "false"))
            case .integer(let asn1Integer):
                print("INTEGER (\(asn1Integer.int)) (\(asn1Integer.int.toString(radix: 16, uppercase: true))))")
            case .bitString(let asn1BitString):
                print("BIT_STRING (Unused: \(asn1BitString.unusedBits), \(asn1BitString.printString(fullLength: fullLength, depth: depth + 1))\(String.tabbedNewLine(tabCount: depth))]")
            case .octetString(let asn1OctetString):
                if !decodedOctets {
                    let remaining = max(0, asn1OctetString.value.count - 64)
                    let skippingText = remaining > 0 && !fullLength ? ", Hidden: \(remaining))" : ")"
                    let bytes = (fullLength || remaining <= 0) ? asn1OctetString.value : (.init(asn1OctetString.value.prefix(32)) + .init(asn1OctetString.value.suffix(32)))
                    print("OCTET_STRING (Total: \(asn1OctetString.value.count)\(skippingText) [\(printableHexString(bytes, depth: depth, fullLength: fullLength))\(String.tabbedNewLine(tabCount: depth))]")
                } else {
                    do {
                        let decodedObject = try KernelASN1.ASN1Parser2.objectFromBytes(asn1OctetString.value)
                        print("OCTET_STRING (Total: \(asn1OctetString.value.count)) [")
                        printObject(decodedObject, depth: depth + 1, fullLength: fullLength, decodedOctets: decodedOctets)
                        print(String.init(repeating: .tab(), count: depth) + "]")
                    } catch {
                        let remaining = max(0, asn1OctetString.value.count - 64)
                        let skippingText = remaining > 0 && !fullLength ? ", Hidden: \(remaining))" : ")"
                        let bytes = (fullLength || remaining <= 0) ? asn1OctetString.value : (.init(asn1OctetString.value.prefix(32)) + .init(asn1OctetString.value.suffix(32)))
                        print("OCTET_STRING (Total: \(asn1OctetString.value.count)\(skippingText) [\(printableHexString(bytes, depth: depth, fullLength: fullLength))\(String.tabbedNewLine(tabCount: depth))]")
                    }
                }
            case .null:
                print("NULL")
            case .objectIdentifier(let asn1ObjectIdentifier):
                print("OBJECT_IDENTIFIER ", terminator: "")
                if let oid = asn1ObjectIdentifier.oid {
                    print("\(oid) ", terminator: "")
                }
                for i in 0 ..< asn1ObjectIdentifier.identifier.count {
                    if i != asn1ObjectIdentifier.identifier.count - 1 {
                        print("\(asn1ObjectIdentifier.identifier[i]).", terminator: "")
                    }
                    else {
                        print("\(asn1ObjectIdentifier.identifier[i])", terminator: "")
                    }
                }
                print("")
            case .printableString(let asn1PrintableString):
                print(asn1PrintableString.description)
            case .utf8String(let asn1UTF8String):
                print(asn1UTF8String.description)
            case .t61String(let asn1T61String):
                print(asn1T61String.description)
            case .ia5String(let asn1IA5String):
                print(asn1IA5String.description)
            case .graphicString(let asn1GraphicString):
                print(asn1GraphicString.description)
            case .generalString(let asn1GeneralString):
                print(asn1GeneralString.description)
            case .bmpString(let asn1String):
                print(asn1String.description)
            case .visibleString(let asn1String):
                print(asn1String.description)
            case .utcTime(let asn1UTCTime):
                print(asn1UTCTime.description)
            case .generalisedTime(let asn1GeneralisedTime):
                print(asn1GeneralisedTime.description)
            case .sequence(let array):
                print("SEQUENCE (\(array.count) object\(array.count == 1 ? "" : "s"))")
                for o in array {
                    printObject(o, depth: depth + 1, fullLength: fullLength, decodedOctets: decodedOctets)
                }
                
            case .set(let array):
                print("SET (\(array.count) object\(array.count == 1 ? "" : "s"))")
                for o in array {
                    printObject(o, depth: depth + 1, fullLength: fullLength, decodedOctets: decodedOctets)
                }
            case .tagged(let tag, let wrappedType):
                print("[\(tag)] ", terminator: "")
                printObject(wrappedType.unwrapped, depth: depth, fullLength: fullLength, tagged: true, decodedOctets: decodedOctets)
            case .any(let asn1Object):
                if let asString = String(bytes: asn1Object.anyData, encoding: .utf8) {
                    print("ANY \(asString)")
                } else {
                    print("ANY \(printableHexString(asn1Object.anyData, depth: depth))")
                }
            case .unknown:
                print("Unhandled Type")
            case .berTerminator: print("BER TERMINATOR")
            }
        }
        
        public static func printableHexString(_ value: [UInt8], depth: Int = 0, fullLength: Bool = false) -> String {
            let depth = depth + 1
            var s: String = .tabbedNewLine(tabCount: depth)
            for i in 0 ..< value.count {
                let c = value[i]
                if (i % 16 == 0 && i != 0) {
                    if i == 32 && !fullLength {
                        s += (.tabbedNewLine(tabCount: depth) + "...")
                    }
                    s += .tabbedNewLine(tabCount: depth)
                }
                
                s += "\(c < 0x10 ? "0" : "")\(String(c, radix: 16, uppercase: true)) "
            }
            return s
        }
        
        public static func makePrintString(_ object: ASN1Type, depth: Int = 0, string: String = "") -> String {
            var string = string
            for _ in 0..<depth { string += String.tab() }
            
            switch object {
            case .any(let asn1Object):
                string += ("ANY \(asn1Object.underlyingData?.toHexString() ?? "")")
            case .boolean(let asn1Boolean):
                string += ("BOOLEAN " + (asn1Boolean.value ? "true" : "false"))
            case .integer(let asn1Integer):
                string += ("INTEGER (\(asn1Integer.int)) (\(asn1Integer.int.toString(radix: 16, uppercase: true))))")
            case .bitString(let asn1BitString):
                string += ("BIT_STRING (\(printableHexString(asn1BitString.value, depth: depth))\(String.tabbedNewLine(tabCount: depth))) (Unused: \(asn1BitString.unusedBits))")
            case .octetString(let asn1OctetString):
                string += ("OCTET_STRING (\(printableHexString(asn1OctetString.value, depth: depth))\(String.tabbedNewLine(tabCount: depth)))")
            case .null:
                string += ("NULL")
            case .objectIdentifier(let asn1ObjectIdentifier):
                string += ("OBJECT IDENTIFIER ")
                if let oid = asn1ObjectIdentifier.oid {
                    string += ("\(oid) ")
                }
                for i in 0 ..< asn1ObjectIdentifier.identifier.count {
                    if i != asn1ObjectIdentifier.identifier.count - 1 {
                        string += ("\(asn1ObjectIdentifier.identifier[i]).")
                    }
                    else {
                        string += ("\(asn1ObjectIdentifier.identifier[i])")
                    }
                }
                string += ("")
            case .printableString(let asn1PrintableString):
                string += (asn1PrintableString.description)
            case .utf8String(let asn1UTF8String):
                string += (asn1UTF8String.description)
            case .t61String(let asn1T61String):
                string += (asn1T61String.description)
            case .ia5String(let asn1IA5String):
                string += (asn1IA5String.description)
            case .graphicString(let asn1GraphicString):
                string += (asn1GraphicString.description)
            case .generalString(let asn1GeneralString):
                string += (asn1GeneralString.description)
            case .bmpString(let asn1String):
                string += (asn1String.description)
            case .visibleString(let asn1String):
                string += (asn1String.description)
            case .utcTime(let asn1UTCTime):
                string += (asn1UTCTime.description)
            case .generalisedTime(let asn1GeneralisedTime):
                string += (asn1GeneralisedTime.description)
            case .sequence(let array):
                string += ("SEQUENCE (\(array.count) object\(array.count == 1 ? "" : "s"))")
                for o in array {
//                    let strCopy = string
                    string += makePrintString(o, depth: depth + 1)
                }
            case .set(let array):
                string += ("SET (\(array.count) object\(array.count == 1 ? "" : "s"))")
                for o in array {
//                    let strCopy = string
                    string += makePrintString(o, depth: depth + 1)
                }
            case .tagged(let tag, let wrappedType):
                string += ("[\(tag)]")
//                let strCopy = string
                string += makePrintString(wrappedType.unwrapped, depth: depth + 1)
            case .unknown:
                string += ("Unhandled Type")
            case .berTerminator:
                string += "BER TERMINATOR"
            }
            return string
        }
    }
}
//extension String {
//    public static var fourSpaceTab: String = "    "
//    public static func tab(_ spaces: Int = 4) -> String { return String(repeating: " ", count: spaces)}
//    public static func tabbedNewLine(tabCount: Int = 1, tabSpaces: Int = 4) -> String {
//        return "\n" + String(repeating: .tab(tabSpaces), count: tabCount)
//    }
//    public static func tabs(tabCount: Int = 1, tabSpaces: Int = 4) -> String {
//        return String(repeating: .tab(tabSpaces), count: tabCount)
//    }
//    public static func debugPropertyTabbedNewLine(tabCount: Int = 1, tabSpaces: Int = 4, property: String) -> String {
//        tabbedNewLine(tabCount: tabCount, tabSpaces: tabSpaces) + "- \(property): "
//    }
////    public static var newLine: String = "\n"
//}

extension KernelASN1.ASN1Type {
    public func print(
        fullLength: Bool = false,
        tagged: Bool = false,
        decodedOctets: Bool = false
    ) {
        KernelASN1.ASN1Printer.printObject(self, fullLength: fullLength, tagged: tagged, decodedOctets: decodedOctets)
    }
}

extension KernelASN1.ASN1Type.VerboseTypeWithMetadata {
    public func printVerbose(
        fullLength: Bool = false,
        tagged: Bool = false,
        decodedOctets: Bool = false,
        decodedBits: Bool = false,
        printMetadata: Bool = false
    ) {
        KernelASN1.ASN1Printer.printObjectVerbose(
            self,
            fullLength: fullLength,
            tagged: tagged,
            decodedOctets: decodedOctets,
            decodedBits: decodedBits,
            printMetadata: printMetadata
        )
    }
}

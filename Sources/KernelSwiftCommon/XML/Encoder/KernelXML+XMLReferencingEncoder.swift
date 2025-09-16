//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 18/06/2025.
//

import Foundation

extension KernelXML {
    class XMLReferencingEncoder: SynchronousXMLEncoder {
        private enum Reference {
            case unkeyed(SharedBox<UnkeyedBox>, Int)
            case keyed(SharedBox<KeyedBox>, String)
            case choice(SharedBox<ChoiceBox>, String)
        }
        
        let encoder: SynchronousXMLEncoder
        private let reference: Reference
        
        init(
            referencing encoder: SynchronousXMLEncoder,
            at index: Int,
            wrapping sharedUnkeyed: SharedBox<UnkeyedBox>
        ) {
            self.encoder = encoder
            reference = .unkeyed(sharedUnkeyed, index)
            super.init(
                options: encoder.options,
                nodeEncodings: encoder.nodeEncodings,
                codingPath: encoder.codingPath
            )
            
            codingPath.append(XMLKey(index: index))
        }
        
        init(
            referencing encoder: SynchronousXMLEncoder,
            key: CodingKey,
            convertedKey: CodingKey,
            wrapping sharedKeyed: SharedBox<KeyedBox>
        ) {
            self.encoder = encoder
            reference = .keyed(sharedKeyed, convertedKey.stringValue)
            super.init(
                options: encoder.options,
                nodeEncodings: encoder.nodeEncodings,
                codingPath: encoder.codingPath
            )
            
            codingPath.append(key)
        }
        
        init(
            referencing encoder: SynchronousXMLEncoder,
            key: CodingKey,
            convertedKey: CodingKey,
            wrapping sharedKeyed: SharedBox<ChoiceBox>
        ) {
            self.encoder = encoder
            reference = .choice(sharedKeyed, convertedKey.stringValue)
            super.init(
                options: encoder.options,
                nodeEncodings: encoder.nodeEncodings,
                codingPath: encoder.codingPath
            )
            
            codingPath.append(key)
        }
        
        override var canEncodeNewValue: Bool {
            return storage.count == codingPath.count - encoder.codingPath.count - 1
        }
        
        deinit {
            let box: Boxable
            switch self.storage.count {
            case 0: box = KeyedBox()
            case 1: box = self.storage.popContainer()
            default: fatalError("Referencing encoder deallocated with multiple containers on stack.")
            }
            
            switch self.reference {
            case let .unkeyed(sharedUnkeyedBox, index):
                sharedUnkeyedBox.withShared { unkeyedBox in
                    unkeyedBox.insert(box, at: index)
                }
            case let .keyed(sharedKeyedBox, key):
                sharedKeyedBox.withShared { keyedBox in
                    keyedBox.elements.append(box, at: key)
                }
            case let .choice(sharedChoiceBox, key):
                sharedChoiceBox.withShared { choiceBox in
                    choiceBox.value = box
                    choiceBox.key = key
                }
            }
        }
    }
}

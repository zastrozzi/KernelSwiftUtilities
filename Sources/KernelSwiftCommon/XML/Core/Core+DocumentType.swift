//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 18/06/2025.
//

import Foundation

extension KernelXML {
    public struct DocumentType {
        public let rootElement: String
        public let external: External
        public let dtdName: String?
        public let dtdLocation: String
        
        internal init(
            rootElement: String,
            external: External,
            dtdName: String?,
            dtdLocation: String
        ) {
            self.rootElement = rootElement
            self.external = external
            self.dtdName = dtdName
            self.dtdLocation = dtdLocation
        }
        
        public static func `public`(rootElement: String, dtdName: String, dtdLocation: String) -> DocumentType {
            .init(
                rootElement: rootElement,
                external: .public,
                dtdName: dtdName,
                dtdLocation: dtdLocation
            )
        }
        
        public static func system(rootElement: String, dtdLocation: String) -> DocumentType {
            .init(
                rootElement: rootElement,
                external: .system,
                dtdName: nil,
                dtdLocation: dtdLocation
            )
        }
        
        public func toXML() -> String {
            var string = "<!DOCTYPE \(rootElement) \(external.rawValue)"
            
            if let dtdName = dtdName { string += " \"\(dtdName)\"" }
            string += " \"\(dtdLocation)\""
            string += ">\n"
            return string
        }
    }
}

extension KernelXML.DocumentType {
    public enum External: String {
        case `public` = "PUBLIC"
        case system = "SYSTEM"
    }
}

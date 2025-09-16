//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 27/03/2025.
//

import Foundation

extension KernelNetworking.Configuration {
    public struct URICoderConfiguration: Sendable {
        public enum Style: Sendable {
            case simple
            case form
            case deepObject
        }
        
        public enum SpaceEscapingCharacter: String, Sendable {
            case percentEncoded = "%20"
            case plus = "+"
        }
        
        var style: Style
        var explode: Bool
        var spaceEscapingCharacter: SpaceEscapingCharacter
        var dateTranscoder: any DateTranscoder
        
        public init(
            style: Style,
            explode: Bool,
            spaceEscapingCharacter: SpaceEscapingCharacter,
            dateTranscoder: any DateTranscoder = .iso8601
        ) {
            self.style = style
            self.explode = explode
            self.spaceEscapingCharacter = spaceEscapingCharacter
            self.dateTranscoder = dateTranscoder
        }
    }
}

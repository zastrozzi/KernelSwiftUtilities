//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 10/09/2023.
//

import Foundation
import SwiftUI
import KernelSwiftCommon

extension KernelAppUtils.OIDC {
    public struct OIDCClientUIDesign: Codable, Equatable, Sendable {
        public var logo: OIDCClientLogo
        public var signInText: String
        
        public var lightModeBackgroundColor: Color
        public var lightModeForegroundColor: Color
        public var darkModeBackgroundColor: Color
        public var darkModeForegroundColor: Color
        
        public init(
            logo: OIDCClientLogo,
            signInText: String,
            lightModeBackgroundColorHex: String,
            lightModeForegroundColorHex: String,
            darkModeBackgroundColorHex: String,
            darkModeForegroundColorHex: String
        ) {
            self.logo = logo
            self.signInText = signInText
            self.lightModeBackgroundColor = .init(fromHex: lightModeBackgroundColorHex)
            self.lightModeForegroundColor = .init(fromHex: lightModeForegroundColorHex)
            self.darkModeBackgroundColor = .init(fromHex: darkModeBackgroundColorHex)
            self.darkModeForegroundColor = .init(fromHex: darkModeForegroundColorHex)
        }
        
        public init(
            logo: OIDCClientLogo,
            signInText: String,
            backgroundColorHex: String,
            foregroundColorHex: String
        ) {
            self.logo = logo
            self.signInText = signInText
            self.lightModeBackgroundColor = .init(fromHex: backgroundColorHex)
            self.lightModeForegroundColor = .init(fromHex: foregroundColorHex)
            self.darkModeBackgroundColor = .init(fromHex: backgroundColorHex)
            self.darkModeForegroundColor = .init(fromHex: foregroundColorHex)
        }
        
        public enum CodingKeys: String, CodingKey {
            case logo
            case signInText
            case lightModeBackgroundColorHex
            case lightModeForegroundColorHex
            case darkModeBackgroundColorHex
            case darkModeForegroundColorHex
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.logo = try container.decode(OIDCClientLogo.self, forKey: .logo)
            self.signInText = try container.decode(String.self, forKey: .signInText)
            self.lightModeBackgroundColor = .init(try container.decode(String.self, forKey: .lightModeBackgroundColorHex))
            self.darkModeBackgroundColor = .init(try container.decode(String.self, forKey: .darkModeBackgroundColorHex))
            self.lightModeForegroundColor = .init(try container.decode(String.self, forKey: .lightModeForegroundColorHex))
            self.darkModeForegroundColor = .init(try container.decode(String.self, forKey: .darkModeForegroundColorHex))
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(logo, forKey: .logo)
            try container.encode(signInText, forKey: .signInText)
            try container.encode(lightModeBackgroundColor.toHexString(), forKey: .lightModeBackgroundColorHex)
            try container.encode(lightModeForegroundColor.toHexString(), forKey: .lightModeForegroundColorHex)
            try container.encode(darkModeBackgroundColor.toHexString(), forKey: .darkModeBackgroundColorHex)
            try container.encode(darkModeForegroundColor.toHexString(), forKey: .darkModeForegroundColorHex)
        }

    }
}
extension KernelAppUtils.OIDC.OIDCClientUIDesign {

    public static let google: Self = .init(
        logo: .asyncImageURL("https://developers.google.com/static/identity/images/g-logo.png"),
        signInText: "Sign in with Google",
        backgroundColorHex: "#ffffff",
        foregroundColorHex: "#4285f4"
    )
    
    public static let apple: Self = .init(
        logo: .sfSymbol("apple.logo"),
        signInText: "Sign in with Apple",
        lightModeBackgroundColorHex: "#000000",
        lightModeForegroundColorHex: "#ffffff",
        darkModeBackgroundColorHex: "#ffffff",
        darkModeForegroundColorHex: "#000000"
    )
    
//    
//    public static var github: OIDCClientUIDesign {
//        .init(
//            logo: .asyncImageURL("https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png"),
//            signInText: "Login with GitHub",
//            lightModeBackgroundColorHex: "#000000",
//            lightModeForegroundColorHex: "#ffffff",
//            darkModeBackgroundColorHex: "#ffffff",
//            darkModeForegroundColorHex: "#000000"
//        )
//    
//    }
//
//    public static var apple: OIDCClientUIDesign {
//        .init(logoURL: "https://developers.google.com/static/identity/images/g-logo.png", signInText: "Sign in with Google", backgroundColorHex: "#ffffff", foregroundColorHex: "#4285f4")
//    }
}

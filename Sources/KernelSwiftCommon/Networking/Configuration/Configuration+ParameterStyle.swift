//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 27/03/2025.
//

import Foundation

extension KernelNetworking.Configuration {
    public enum ParameterStyle: Sendable {
        case form
        case simple
        case deepObject
    }
}

extension KernelNetworking.Configuration.ParameterStyle {
    static let defaultForPathParameters: Self = .simple
    static let defaultForQueryItems: Self = .form
    static let defaultForHeaderFields: Self = .simple
    static let defaultForCookies: Self = .form
    
    static func defaultExplodeFor(
        forStyle style: KernelNetworking.Configuration.ParameterStyle
    ) -> Bool { style == .form }
}

extension KernelNetworking.Configuration.URICoderConfiguration.Style {
    init(_ style: KernelNetworking.Configuration.ParameterStyle) {
        switch style {
        case .form: self = .form
        case .simple: self = .simple
        case .deepObject: self = .deepObject
        }
    }
}

extension KernelNetworking.Configuration.ParameterStyle {
    static func resolvedQueryStyleAndExplode(
        name: String,
        style: KernelNetworking.Configuration.ParameterStyle?,
        explode: Bool?
    ) throws -> (KernelNetworking.Configuration.ParameterStyle, Bool) {
        let resolvedStyle = style ?? .defaultForQueryItems
        let resolvedExplode = explode ?? KernelNetworking.Configuration.ParameterStyle.defaultExplodeFor(forStyle: resolvedStyle)
        switch resolvedStyle {
        case .form, .deepObject: break
        default:
            throw KernelNetworking.RuntimeError.unsupportedParameterStyle(
                name: name,
                location: .query,
                style: resolvedStyle,
                explode: resolvedExplode
            )
        }
        return (resolvedStyle, resolvedExplode)
    }
}

//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 06/09/2023.
//

import Foundation
import SwiftUI


public struct ForegroundPrimaryStyleEnvironmentKey: EnvironmentKey {
    public static let defaultValue: AnyShapeStyle = .init(.primary)
}

public struct ForegroundSecondaryStyleEnvironmentKey: EnvironmentKey {
    public static let defaultValue: AnyShapeStyle = .init(.secondary)
}

public struct ForegroundTertiaryStyleEnvironmentKey: EnvironmentKey {
    public static let defaultValue: AnyShapeStyle = .init(.tertiary)
}

public struct ForegroundQuaternaryStyleEnvironmentKey: EnvironmentKey {
    public static let defaultValue: AnyShapeStyle = .init(.quaternary)
}

public struct ForegroundQuinaryStyleEnvironmentKey: EnvironmentKey {
    public static let defaultValue: AnyShapeStyle = .init(.quinary)
}

extension EnvironmentValues {
    public var foregroundPrimary: AnyShapeStyle {
        get { self[ForegroundPrimaryStyleEnvironmentKey.self] }
        set { self[ForegroundPrimaryStyleEnvironmentKey.self] = newValue }
    }
    
    public var foregroundSecondary: AnyShapeStyle {
        get { self[ForegroundSecondaryStyleEnvironmentKey.self] }
        set { self[ForegroundSecondaryStyleEnvironmentKey.self] = newValue }
    }
    
    public var foregroundTertiary: AnyShapeStyle {
        get { self[ForegroundTertiaryStyleEnvironmentKey.self] }
        set { self[ForegroundTertiaryStyleEnvironmentKey.self] = newValue }
    }
    
    public var foregroundQuaternary: AnyShapeStyle {
        get { self[ForegroundQuaternaryStyleEnvironmentKey.self] }
        set { self[ForegroundQuaternaryStyleEnvironmentKey.self] = newValue }
    }
    
    public var foregroundQuinary: AnyShapeStyle {
        get { self[ForegroundQuinaryStyleEnvironmentKey.self] }
        set { self[ForegroundQuinaryStyleEnvironmentKey.self] = newValue }
    }
}

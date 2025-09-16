//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 13/03/2025.
//

import Foundation
import KernelSwiftCommon

extension KernelDI.Injector {
    public var matchedGeometryManager: KernelAppUtils.MatchedGeometryManager {
        get { self[KernelAppUtils.MatchedGeometryManager.Token.self] }
        set { self[KernelAppUtils.MatchedGeometryManager.Token.self] = newValue }
    }
}

extension KernelAppUtils {
    @Observable @MainActor
    public final class MatchedGeometryManager: KernelDI.Injectable, KernelDI.ServiceLoggable, @unchecked Sendable {
        public typealias FeatureContainer = KernelAppUtils
        
        public var geometries: [MatchedGeometryInfo] = []
        
        nonisolated required public init() {
            Self.logger.debug("Initialising MatchedGeometryManager")
        }
    }
}

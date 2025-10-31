//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 31/10/2025.
//

import Foundation
import KernelSwiftCommon

extension KernelAppUtils {
    public final class AsyncImageCache: KernelDI.Injectable, KernelDI.ServiceLoggable, @unchecked Sendable {
        public typealias FeatureContainer = Application
        
        @ObservationIgnored
        private var storage: KernelAppUtils.SimpleMemoryCache<String, KSNativeImage> = .init()
        
        nonisolated required public init() {
            Self.logger.debug("Initialising AsyncImageCache")
        }
    }
}

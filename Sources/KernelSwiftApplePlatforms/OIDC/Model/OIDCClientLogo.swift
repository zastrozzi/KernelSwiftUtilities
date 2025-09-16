//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 10/09/2023.
//

import Foundation
import KernelSwiftCommon

public enum OIDCClientLogo: Codable, Equatable, Hashable, Sendable {
    case asyncImageURL(String)
    case sfSymbol(String)
    case bundleAsset(String, BundleAssetLocation?)
    case none
}

public enum BundleAssetLocation: Codable, Equatable, CaseIterable, Sendable {
    case main
//    case module
    
    public var bundle: Bundle {
        switch self {
        case .main: Bundle.main
//        case .module: Bundle.module
        }
    }
}

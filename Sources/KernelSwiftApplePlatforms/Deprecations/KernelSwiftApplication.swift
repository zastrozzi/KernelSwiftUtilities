//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 22/02/2022.
//

import Foundation
import KernelSwiftCommon

@available(*, deprecated)
open class KernelSwiftApplication {
    public let name: String
    public let packageName: String
    public let version: String
    
    public init() {
        let mainBundle = Bundle.main
        let infoDictionary = mainBundle.infoDictionary
        
        name = (infoDictionary?["CFBundleDisplayName"] ?? infoDictionary?["CFBundleName"]) as? String ?? ""
        packageName = mainBundle.bundleIdentifier ?? ""
        version = [
            infoDictionary?["CFBundleShortVersionString"] as? String,
            infoDictionary?["CFBundleVersion"] as? String
        ].compactMap { $0 }.joined(separator: "-")
    }
}

@available(*, deprecated)
extension KernelSwiftApplication: Printable {
    public var  debugDescription: String {
        return "\(name) v\(version) (\(packageName)"
    }
}

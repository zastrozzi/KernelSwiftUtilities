//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 17/08/2023.
//

import Foundation

#if !os(WASI)
public let _DestinationIsTesting: Bool = {
    ProcessInfo.processInfo.environment.keys.contains("XCTestBundlePath")
    || ProcessInfo.processInfo.environment.keys.contains("XCTestConfigurationFilePath")
    || ProcessInfo.processInfo.environment.keys.contains("XCTestSessionIdentifier")
    || (ProcessInfo.processInfo.arguments.first
        .flatMap(URL.init(fileURLWithPath:))
        .map { $0.lastPathComponent == "xctest" || $0.pathExtension == "xctest" }
        ?? false)
    || _ActiveTestCase != nil
}()
#else
public let _DestinationIsTesting = false
#endif

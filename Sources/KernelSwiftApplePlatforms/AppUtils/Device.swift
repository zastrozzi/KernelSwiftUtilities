//
//  File.swift
//
//
//  Created by Jonathan Forbes on 09/01/2022.
//

import Foundation
import KernelSwiftCommon
import Logging

#if os(iOS)
import UIKit


//public var deviceIsPortrait: Bool { UIDevice.current.orientation.isPortrait }
//public var deviceScreen = UIScreen.main.bounds
#endif

#if os(macOS)
import AppKit

//public var deviceScreen: CGRect = NSScreen.main?.frame ?? .init()
#endif


extension KernelDI.Injector {
    @available(iOS 17.0, macOS 14.0, *)
    public var device: KernelAppUtils.Device {
        get { self[KernelAppUtils.Device.Token.self] }
        set { self[KernelAppUtils.Device.Token.self] = newValue }
    }
}

extension KernelAppUtils {
    
    public struct Device: FeatureLoggable, @preconcurrency KernelDI.Injectable, Sendable {
//        public static let logger = makeLogger()
        public let os: OS
        public let osVersion: String
        public let model: String
        public let knownDevice: KnownDevice
        public let isFaceIDCapable: Bool
        public let isTouchIDCapable: Bool
#if os(macOS)
        @MainActor
        public var currentWindow: NSWindow? {
            guard os == .macOS else { return nil }
            return NSApplication.shared.windows.filter { $0.isMainWindow }.first
        }
        
        @MainActor
        public var currentWindowFrame: CGRect {
            guard let currentWindow else { return .zero }
            let frame: CGRect = currentWindow.frame
            return frame
        }
        
        public var currentDeviceFrame: CGRect { NSScreen.main?.frame ?? .zero }
        
        public var hasTopNotch: Bool = false
        public var vendorDeviceIdentifier: UUID? = nil
#endif
        
#if os(iOS)
        @MainActor
        public var currentWindow: UIWindow? {
            os == .macOS ? nil : UIApplication.shared.connectedScenes.filter { $0.activationState == .foregroundActive }.map { $0 as? UIWindowScene }.compactMap { $0 }.first?.windows.filter { $0.isKeyWindow }.first
        }
        
        @MainActor
        public var currentWindowFrame: CGRect {
            guard let currentWindow else { return .zero }
            return currentWindow.frame
        }
        
        @MainActor
        public var currentDeviceFrame: CGRect { currentWindow?.screen.bounds ?? .zero }
        
        @MainActor
        public var hasTopNotch: Bool { os == .iOS ? currentWindow?.safeAreaInsets.top ?? 0 > 20 : false }
        
        @MainActor
        public var vendorDeviceIdentifier: UUID? { UIDevice.current.identifierForVendor }
#endif
        @MainActor
        public init() {
            let processInfo = ProcessInfo.processInfo
            os = .current
            
            let operatingSystem = processInfo.operatingSystemVersion
            osVersion = "\(operatingSystem.majorVersion).\(operatingSystem.minorVersion).\(operatingSystem.patchVersion)"
            
#if targetEnvironment(simulator)
            model = processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "simulator"
#else
            let keys: [Int32]
#if os(macOS)
            keys = [CTL_HW, HW_MODEL]
#else
            keys = [CTL_HW, HW_MACHINE]
#endif
            
            let modelData = keys.withUnsafeBufferPointer { keysPointer -> [Int8]? in
                var requiredSize = 0
                let preFlightResult = Darwin.sysctl(UnsafeMutablePointer<Int32>(mutating: keysPointer.baseAddress), UInt32(keys.count), nil, &requiredSize, nil, 0)
                
                if preFlightResult != 0 {
                    return nil
                }
                
                let data = Array<Int8>(repeating: 0, count: requiredSize)
                let result = try? data.withUnsafeBufferPointer() { dataBuffer throws -> Int32 in
                    return Darwin.sysctl(UnsafeMutablePointer<Int32>(mutating: keysPointer.baseAddress), UInt32(keys.count), UnsafeMutableRawPointer(mutating: dataBuffer.baseAddress), &requiredSize, nil, 0)
                }
                
                if result != 0 {
                    return nil
                }
                return data
            }
            model = modelData?.withUnsafeBufferPointer { dataPointer -> String? in
                dataPointer.baseAddress.flatMap { String(validatingCString: $0) }
            } ?? "Unknown"
#endif
            knownDevice = .fromModel(identifier: model)
            isFaceIDCapable = KnownDevice.isFaceIDCapable(knownDevice)
            isTouchIDCapable = KnownDevice.isTouchIDCapable(knownDevice)
            Self.logger.debug("[\(String(describing: self))] Initialised")
        }
    }
    
}


extension KernelAppUtils.Device {
    public enum OS: String, Printable, Sendable {
        case iOS = "iOS"
        case iPadOS = "iPadOS"
        case macOS = "macOS"
        case watchOS = "watchOS"
        case tvOS = "tvOS"
        case unknown = "unknown"
        case visionOS = "visionOS"
        case iOSExtendedUnspecified = "iOS-Ext-Unspecified"
        case iOSExtendedTV = "iOS-Ext-TV"
        case iOSExtendedCar = "iOS-Ext-Car"
        case iOSExtendedMac = "iOS-Ext-Mac"
        
        @MainActor
        public static var current: Self {
#if os(macOS)
            .macOS
#elseif os(iOS) || os(tvOS) || os(watchOS)
            switch UIDevice.current.userInterfaceIdiom {
            case .phone: .iOS
            case .pad: .iPadOS
            case .unspecified: .unknown
            case .tv: .tvOS
            case .carPlay: .iOSExtendedCar
            case .mac: .macOS
            case .vision: .visionOS
            @unknown default: .unknown
            }
#else
            .unknown
#endif
        }
    }
}

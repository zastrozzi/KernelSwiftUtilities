//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 06/03/2025.
//

extension KernelAppUtils.Device.KnownDevice {
    public static var allTouchIDCapableDevices: [Self] {
        #if os(iOS)
        return [
            .iPhone5s,
            .iPhone6,
            .iPhone6Plus,
            .iPhone6s,
            .iPhone6sPlus,
            .iPhone7,
            .iPhone7Plus,
            .iPhoneSE,
            .iPhone8,
            .iPhone8Plus,
            .iPhoneSE2,
            .iPhoneSE3,
            .iPadAir2,
            .iPad5,
            .iPad6,
            .iPadAir3,
            .iPad7,
            .iPad8,
            .iPad9,
            .iPad10,
            .iPadAir4,
            .iPadAir5,
            .iPadAir11M2,
            .iPadAir13M2,
            .iPadMini3,
            .iPadMini4,
            .iPadMini5,
            .iPadMini6,
            .iPadPro9Inch,
            .iPadPro12Inch,
            .iPadPro12Inch2,
            .iPadPro10Inch
        ]
        #else
        return []
        #endif
    }
    
    public static var allFaceIDCapableDevices: [Self] {
        #if os(iOS)
        return [
            .iPhoneX,
            .iPhoneXS,
            .iPhoneXSMax,
            .iPhoneXR,
            .iPhone11,
            .iPhone11Pro,
            .iPhone11ProMax,
            .iPhone12,
            .iPhone12Mini,
            .iPhone12Pro,
            .iPhone12ProMax,
            .iPhone13,
            .iPhone13Mini,
            .iPhone13Pro,
            .iPhone13ProMax,
            .iPhone14,
            .iPhone14Plus,
            .iPhone14Pro,
            .iPhone14ProMax,
            .iPhone15,
            .iPhone15Plus,
            .iPhone15Pro,
            .iPhone15ProMax,
            .iPhone16,
            .iPhone16Plus,
            .iPhone16Pro,
            .iPhone16ProMax,
            .iPadPro11Inch,
            .iPadPro12Inch3,
            .iPadPro11Inch2,
            .iPadPro12Inch4,
            .iPadPro11Inch3,
            .iPadPro12Inch5,
            .iPadPro11Inch4,
            .iPadPro12Inch6,
            .iPadPro11M4,
            .iPadPro13M4
        ]
        #else
        return []
        #endif
    }
    
    public static func isTouchIDCapable(_ device: Self) -> Bool {
        allTouchIDCapableDevices.contains(device)
    }
    
    public static func isFaceIDCapable(_ device: Self) -> Bool {
        allFaceIDCapableDevices.contains(device)
    }
}

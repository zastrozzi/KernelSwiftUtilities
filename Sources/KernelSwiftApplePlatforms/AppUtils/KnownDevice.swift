//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 06/03/2025.
//

import Foundation

extension KernelAppUtils.Device {
    public enum KnownDevice: Hashable, Equatable, Sendable {
#if os(iOS)
        /// Device is an [iPod touch (5th generation)](https://support.apple.com/kb/SP657)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP657/sp657_ipod-touch_size.jpg)
        case iPodTouch5
        /// Device is an [iPod touch (6th generation)](https://support.apple.com/kb/SP720)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP720/SP720-ipod-touch-specs-color-sg-2015.jpg)
        case iPodTouch6
        /// Device is an [iPod touch (7th generation)](https://support.apple.com/kb/SP796)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP796/ipod-touch-7th-gen_2x.png)
        case iPodTouch7
        /// Device is an [iPhone 4](https://support.apple.com/kb/SP587)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP643/sp643_iphone4s_color_black.jpg)
        case iPhone4
        /// Device is an [iPhone 4s](https://support.apple.com/kb/SP643)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP643/sp643_iphone4s_color_black.jpg)
        case iPhone4s
        /// Device is an [iPhone 5](https://support.apple.com/kb/SP655)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP655/sp655_iphone5_color.jpg)
        case iPhone5
        /// Device is an [iPhone 5c](https://support.apple.com/kb/SP684)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP684/SP684-color_yellow.jpg)
        case iPhone5c
        /// Device is an [iPhone 5s](https://support.apple.com/kb/SP685)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP685/SP685-color_black.jpg)
        case iPhone5s
        /// Device is an [iPhone 6](https://support.apple.com/kb/SP705)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP705/SP705-iphone_6-mul.png)
        case iPhone6
        /// Device is an [iPhone 6 Plus](https://support.apple.com/kb/SP706)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP706/SP706-iphone_6_plus-mul.png)
        case iPhone6Plus
        /// Device is an [iPhone 6s](https://support.apple.com/kb/SP726)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP726/SP726-iphone6s-gray-select-2015.png)
        case iPhone6s
        /// Device is an [iPhone 6s Plus](https://support.apple.com/kb/SP727)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP727/SP727-iphone6s-plus-gray-select-2015.png)
        case iPhone6sPlus
        /// Device is an [iPhone 7](https://support.apple.com/kb/SP743)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP743/iphone7-black.png)
        case iPhone7
        /// Device is an [iPhone 7 Plus](https://support.apple.com/kb/SP744)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP744/iphone7-plus-black.png)
        case iPhone7Plus
        /// Device is an [iPhone SE](https://support.apple.com/kb/SP738)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP738/SP738.png)
        case iPhoneSE
        /// Device is an [iPhone 8](https://support.apple.com/kb/SP767)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP767/iphone8.png)
        case iPhone8
        /// Device is an [iPhone 8 Plus](https://support.apple.com/kb/SP768)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP768/iphone8plus.png)
        case iPhone8Plus
        /// Device is an [iPhone X](https://support.apple.com/kb/SP770)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP770/iphonex.png)
        case iPhoneX
        /// Device is an [iPhone Xs](https://support.apple.com/kb/SP779)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP779/SP779-iphone-xs.jpg)
        case iPhoneXS
        /// Device is an [iPhone Xs Max](https://support.apple.com/kb/SP780)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP780/SP780-iPhone-Xs-Max.jpg)
        case iPhoneXSMax
        /// Device is an [iPhone Xʀ](https://support.apple.com/kb/SP781)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP781/SP781-iPhone-xr.jpg)
        case iPhoneXR
        /// Device is an [iPhone 11](https://support.apple.com/kb/SP804)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP804/sp804-iphone11_2x.png)
        case iPhone11
        /// Device is an [iPhone 11 Pro](https://support.apple.com/kb/SP805)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP805/sp805-iphone11pro_2x.png)
        case iPhone11Pro
        /// Device is an [iPhone 11 Pro Max](https://support.apple.com/kb/SP806)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP806/sp806-iphone11pro-max_2x.png)
        case iPhone11ProMax
        /// Device is an [iPhone SE (2nd generation)](https://support.apple.com/kb/SP820)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP820/iphone-se-2nd-gen_2x.png)
        case iPhoneSE2
        /// Device is an [iPhone 12](https://support.apple.com/kb/SP830)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP830/sp830-iphone12-ios14_2x.png)
        case iPhone12
        /// Device is an [iPhone 12 mini](https://support.apple.com/kb/SP829)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP829/sp829-iphone12mini-ios14_2x.png)
        case iPhone12Mini
        /// Device is an [iPhone 12 Pro](https://support.apple.com/kb/SP831)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP831/iphone12pro-ios14_2x.png)
        case iPhone12Pro
        /// Device is an [iPhone 12 Pro Max](https://support.apple.com/kb/SP832)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP832/iphone12promax-ios14_2x.png)
        case iPhone12ProMax
        /// Device is an [iPhone 13](https://support.apple.com/kb/SP851)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/1000/IM1092/en_US/iphone-13-240.png)
        case iPhone13
        /// Device is an [iPhone 13 mini](https://support.apple.com/kb/SP847)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/1000/IM1091/en_US/iphone-13mini-240.png)
        case iPhone13Mini
        /// Device is an [iPhone 13 Pro](https://support.apple.com/kb/SP852)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/1000/IM1093/en_US/iphone-13pro-240.png)
        case iPhone13Pro
        /// Device is an [iPhone 13 Pro Max](https://support.apple.com/kb/SP848)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/1000/IM1095/en_US/iphone-13promax-240.png)
        case iPhone13ProMax
        /// Device is an [iPhone SE (3rd generation)](https://support.apple.com/kb/SP867)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/1000/IM1136/en_US/iphone-se-3rd-gen-colors-240.png)
        case iPhoneSE3
        /// Device is an [iPhone 14](https://support.apple.com/kb/SP873)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP873/iphone-14_1_2x.png)
        case iPhone14
        /// Device is an [iPhone 14 Plus](https://support.apple.com/kb/SP874)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP873/iphone-14_1_2x.png)
        case iPhone14Plus
        /// Device is an [iPhone 14 Pro](https://support.apple.com/kb/SP875)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP875/sp875-sp876-iphone14-pro-promax_2x.png)
        case iPhone14Pro
        /// Device is an [iPhone 14 Pro Max](https://support.apple.com/kb/SP876)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP875/sp875-sp876-iphone14-pro-promax_2x.png)
        case iPhone14ProMax
        /// Device is an [iPhone 15](https://support.apple.com/en-us/111831)
        ///
        /// ![Image]()
        case iPhone15
        /// Device is an [iPhone 15 Plus](https://support.apple.com/en-us/111830)
        ///
        /// ![Image]()
        case iPhone15Plus
        /// Device is an [iPhone 15 Pro](https://support.apple.com/en-us/111829)
        ///
        /// ![Image]()
        case iPhone15Pro
        /// Device is an [iPhone 15 Pro Max](https://support.apple.com/en-us/111828)
        ///
        /// ![Image]()
        case iPhone15ProMax
        /// Device is an [iPhone 16]()
        ///
        /// ![Image]()
        case iPhone16
        /// Device is an [iPhone 16 Plus]()
        ///
        /// ![Image]()
        case iPhone16Plus
        /// Device is an [iPhone 16 Pro]()
        ///
        /// ![Image]()
        case iPhone16Pro
        /// Device is an [iPhone 16 Pro Max]()
        ///
        /// ![Image]()
        case iPhone16ProMax
        /// Device is an [iPad 2](https://support.apple.com/kb/SP622)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP622/SP622_01-ipad2-mul.png)
        case iPad2
        /// Device is an [iPad (3rd generation)](https://support.apple.com/kb/SP647)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP662/sp662_ipad-4th-gen_color.jpg)
        case iPad3
        /// Device is an [iPad (4th generation)](https://support.apple.com/kb/SP662)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP662/sp662_ipad-4th-gen_color.jpg)
        case iPad4
        /// Device is an [iPad Air](https://support.apple.com/kb/SP692)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP692/SP692-specs_color-mul.png)
        case iPadAir
        /// Device is an [iPad Air 2](https://support.apple.com/kb/SP708)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP708/SP708-space_gray.jpeg)
        case iPadAir2
        /// Device is an [iPad (5th generation)](https://support.apple.com/kb/SP751)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP751/ipad_5th_generation.png)
        case iPad5
        /// Device is an [iPad (6th generation)](https://support.apple.com/kb/SP774)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP774/sp774-ipad-6-gen_2x.png)
        case iPad6
        /// Device is an [iPad Air (3rd generation)](https://support.apple.com/kb/SP787)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP787/ipad-air-2019.jpg)
        case iPadAir3
        /// Device is an [iPad (7th generation)](https://support.apple.com/kb/SP807)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP807/sp807-ipad-7th-gen_2x.png)
        case iPad7
        /// Device is an [iPad (8th generation)](https://support.apple.com/kb/SP822)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP822/sp822-ipad-8gen_2x.png)
        case iPad8
        /// Device is an [iPad (9th generation)](https://support.apple.com/kb/SP849)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/1000/IM1096/en_US/ipad-9gen-240.png)
        case iPad9
        /// Device is an [iPad (10th generation)](https://support.apple.com/kb/SP884)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP884/sp884-ipad-10gen-960_2x.png)
        case iPad10
        /// Device is an [iPad Air (4th generation)](https://support.apple.com/kb/SP828)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP828/sp828ipad-air-ipados14-960_2x.png)
        case iPadAir4
        /// Device is an [iPad Air (5th generation)](https://support.apple.com/kb/SP866)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP866/sp866-ipad-air-5gen_2x.png)
        case iPadAir5
        /// Device is an [iPad Air 11-inch (M2)](https://support.apple.com/en-us/119894)
        ///
        /// ![Image](https://cdsassets.apple.com/content/services/pub/image?productid=301027&size=240x240)
        case iPadAir11M2
        /// Device is an [iPad Air 13-inch (M2)](https://support.apple.com/en-us/119893)
        ///
        /// ![Image](https://cdsassets.apple.com/content/services/pub/image?productid=301029&size=240x240)
        case iPadAir13M2
        /// Device is an [iPad Mini](https://support.apple.com/kb/SP661)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP661/sp661_ipad_mini_color.jpg)
        case iPadMini
        /// Device is an [iPad Mini 2](https://support.apple.com/kb/SP693)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP693/SP693-specs_color-mul.png)
        case iPadMini2
        /// Device is an [iPad Mini 3](https://support.apple.com/kb/SP709)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP709/SP709-space_gray.jpeg)
        case iPadMini3
        /// Device is an [iPad Mini 4](https://support.apple.com/kb/SP725)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP725/SP725ipad-mini-4.png)
        case iPadMini4
        /// Device is an [iPad Mini (5th generation)](https://support.apple.com/kb/SP788)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP788/ipad-mini-2019.jpg)
        case iPadMini5
        /// Device is an [iPad Mini (6th generation)](https://support.apple.com/kb/SP850)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/1000/IM1097/en_US/ipad-mini-6gen-240.png)
        case iPadMini6
        /// Device is an [iPad Pro 9.7-inch](https://support.apple.com/kb/SP739)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP739/SP739.png)
        case iPadPro9Inch
        /// Device is an [iPad Pro 12-inch](https://support.apple.com/kb/SP723)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP723/SP723-iPad_Pro_2x.png)
        case iPadPro12Inch
        /// Device is an [iPad Pro 12-inch (2nd generation)](https://support.apple.com/kb/SP761)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP761/ipad-pro-12in-hero-201706.png)
        case iPadPro12Inch2
        /// Device is an [iPad Pro 10.5-inch](https://support.apple.com/kb/SP762)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP761/ipad-pro-10in-hero-201706.png)
        case iPadPro10Inch
        /// Device is an [iPad Pro 11-inch](https://support.apple.com/kb/SP784)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP784/ipad-pro-11-2018_2x.png)
        case iPadPro11Inch
        /// Device is an [iPad Pro 12.9-inch (3rd generation)](https://support.apple.com/kb/SP785)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP785/ipad-pro-12-2018_2x.png)
        case iPadPro12Inch3
        /// Device is an [iPad Pro 11-inch (2nd generation)](https://support.apple.com/kb/SP814)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP814/ipad-pro-11-2020.jpeg)
        case iPadPro11Inch2
        /// Device is an [iPad Pro 12.9-inch (4th generation)](https://support.apple.com/kb/SP815)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP815/ipad-pro-12-2020.jpeg)
        case iPadPro12Inch4
        /// Device is an [iPad Pro 11-inch (3rd generation)](https://support.apple.com/kb/SP843)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP843/ipad-pro-11_2x.png)
        case iPadPro11Inch3
        /// Device is an [iPad Pro 12.9-inch (5th generation)](https://support.apple.com/kb/SP844)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP844/ipad-pro-12-9_2x.png)
        case iPadPro12Inch5
        /// Device is an [iPad Pro 11-inch (4th generation)](https://support.apple.com/kb/SP882)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP882/ipad-pro-4gen-mainimage_2x.png)
        case iPadPro11Inch4
        /// Device is an [iPad Pro 12.9-inch (6th generation)](https://support.apple.com/kb/SP883)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP882/ipad-pro-4gen-mainimage_2x.png)
        case iPadPro12Inch6
        /// Device is an [iPad Pro 11-inch (M4)](https://support.apple.com/en-us/119892)
        ///
        /// ![Image](https://cdsassets.apple.com/content/services/pub/image?productid=301031&size=240x240)
        case iPadPro11M4
        /// Device is an [iPad Pro 13-inch (M4)](https://support.apple.com/en-us/119891)
        ///
        /// ![Image](https://cdsassets.apple.com/content/services/pub/image?productid=301033&size=240x240)
        case iPadPro13M4
        /// Device is a [HomePod](https://support.apple.com/kb/SP773)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP773/homepod_space_gray_large_2x.jpg)
        case homePod
#elseif os(tvOS)
        /// Device is an [Apple TV HD](https://support.apple.com/kb/SP724) (Previously Apple TV (4th generation))
        ///
        /// ![Image](http://images.apple.com/v/tv/c/images/overview/buy_tv_large_2x.jpg)
        case appleTVHD
        /// Device is an [Apple TV 4K](https://support.apple.com/kb/SP769)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP769/appletv4k.png)
        case appleTV4K
        /// Device is an [Apple TV 4K (2nd generation)](https://support.apple.com/kb/SP845)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/1000/IM1023/en_US/apple-tv-4k-2gen-240.png)
        case appleTV4K2
        /// Device is an [Apple TV 4K (3rd generation)](https://support.apple.com/kb/SP886)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP886/apple-tv-4k-3gen_2x.png)
        case appleTV4K3
#elseif os(watchOS)
        /// Device is an [Apple Watch (1st generation)](https://support.apple.com/kb/SP735)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/0/IM784/en_US/apple_watch_sport-240.png)
        case appleWatchSeries0_38mm
        /// Device is an [Apple Watch (1st generation)](https://support.apple.com/kb/SP735)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/0/IM784/en_US/apple_watch_sport-240.png)
        case appleWatchSeries0_42mm
        /// Device is an [Apple Watch Series 1](https://support.apple.com/kb/SP745)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/0/IM848/en_US/applewatch-series2-aluminum-temp-240.png)
        case appleWatchSeries1_38mm
        /// Device is an [Apple Watch Series 1](https://support.apple.com/kb/SP745)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/0/IM848/en_US/applewatch-series2-aluminum-temp-240.png)
        case appleWatchSeries1_42mm
        /// Device is an [Apple Watch Series 2](https://support.apple.com/kb/SP746)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/0/IM852/en_US/applewatch-series2-hermes-240.png)
        case appleWatchSeries2_38mm
        /// Device is an [Apple Watch Series 2](https://support.apple.com/kb/SP746)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/0/IM852/en_US/applewatch-series2-hermes-240.png)
        case appleWatchSeries2_42mm
        /// Device is an [Apple Watch Series 3](https://support.apple.com/kb/SP766)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/0/IM893/en_US/apple-watch-s3-nikeplus-240.png)
        case appleWatchSeries3_38mm
        /// Device is an [Apple Watch Series 3](https://support.apple.com/kb/SP766)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/0/IM893/en_US/apple-watch-s3-nikeplus-240.png)
        case appleWatchSeries3_42mm
        /// Device is an [Apple Watch Series 4](https://support.apple.com/kb/SP778)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/0/IM911/en_US/aw-series4-nike-240.png)
        case appleWatchSeries4_40mm
        /// Device is an [Apple Watch Series 4](https://support.apple.com/kb/SP778)
        ///
        /// ![Image](https://km.support.apple.com/resources/sites/APPLE/content/live/IMAGES/0/IM911/en_US/aw-series4-nike-240.png)
        case appleWatchSeries4_44mm
        /// Device is an [Apple Watch Series 5](https://support.apple.com/kb/SP808)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP808/sp808-apple-watch-series-5_2x.png)
        case appleWatchSeries5_40mm
        /// Device is an [Apple Watch Series 5](https://support.apple.com/kb/SP808)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP808/sp808-apple-watch-series-5_2x.png)
        case appleWatchSeries5_44mm
        /// Device is an [Apple Watch Series 6](https://support.apple.com/kb/SP826)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP826/sp826-apple-watch-series6-580_2x.png)
        case appleWatchSeries6_40mm
        /// Device is an [Apple Watch Series 6](https://support.apple.com/kb/SP826)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP826/sp826-apple-watch-series6-580_2x.png)
        case appleWatchSeries6_44mm
        /// Device is an [Apple Watch SE](https://support.apple.com/kb/SP827)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP827/sp827-apple-watch-se-580_2x.png)
        case appleWatchSE_40mm
        /// Device is an [Apple Watch SE](https://support.apple.com/kb/SP827)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP827/sp827-apple-watch-se-580_2x.png)
        case appleWatchSE_44mm
        /// Device is an [Apple Watch Series 7](https://support.apple.com/kb/SP860)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP860/series7-480_2x.png)
        case appleWatchSeries7_41mm
        /// Device is an [Apple Watch Series 7](https://support.apple.com/kb/SP860)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP860/series7-480_2x.png)
        case appleWatchSeries7_45mm
        /// Device is an [Apple Watch Series 8](https://support.apple.com/kb/SP878)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP878/apple-watch-series8_2x.png)
        case appleWatchSeries8_41mm
        /// Device is an [Apple Watch Series 8](https://support.apple.com/kb/SP878)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP878/apple-watch-series8_2x.png)
        case appleWatchSeries8_45mm
        /// Device is an [Apple Watch SE (2nd generation)](https://support.apple.com/kb/SP877)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP877/apple-watch-se-2nd-gen_2x.png)
        case appleWatchSE2_40mm
        /// Device is an [Apple Watch SE (2nd generation)](https://support.apple.com/kb/SP877)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP877/apple-watch-se-2nd-gen_2x.png)
        case appleWatchSE2_44mm
        /// Device is an [Apple Watch Ultra](https://support.apple.com/kb/SP879)
        ///
        /// ![Image](https://support.apple.com/library/APPLE/APPLECARE_ALLGEOS/SP879/apple-watch-ultra_2x.png)
        case appleWatchUltra
        /// Device is an [Apple Watch Series 9]()
        ///
        /// ![Image]()
        case appleWatchSeries9_41mm
        /// Device is an [Apple Watch Series 9]()
        ///
        /// ![Image]()
        case appleWatchSeries9_45mm
        /// Device is an [Apple Watch Ultra2]()
        ///
        /// ![Image]()
        case appleWatchUltra2
        /// Device is an [Apple Watch Series 10]()
        ///
        /// ![Image]()
        case appleWatchSeries10_42mm
        /// Device is an [Apple Watch Series 10]()
        ///
        /// ![Image]()
        case appleWatchSeries10_46mm
#endif
        indirect case simulator(KnownDevice)
        case unknown(String)
    }
}

extension KernelAppUtils.Device.KnownDevice {
    public static func fromModel(identifier: String) -> Self {
#if os(iOS)
        return switch identifier {
        case "iPod5,1": .iPodTouch5
        case "iPod7,1": .iPodTouch6
        case "iPod9,1": .iPodTouch7
        case "iPhone3,1", "iPhone3,2", "iPhone3,3": .iPhone4
        case "iPhone4,1": .iPhone4s
        case "iPhone5,1", "iPhone5,2": .iPhone5
        case "iPhone5,3", "iPhone5,4": .iPhone5c
        case "iPhone6,1", "iPhone6,2": .iPhone5s
        case "iPhone7,2": .iPhone6
        case "iPhone7,1": .iPhone6Plus
        case "iPhone8,1": .iPhone6s
        case "iPhone8,2": .iPhone6sPlus
        case "iPhone9,1", "iPhone9,3": .iPhone7
        case "iPhone9,2", "iPhone9,4": .iPhone7Plus
        case "iPhone8,4": .iPhoneSE
        case "iPhone10,1", "iPhone10,4": .iPhone8
        case "iPhone10,2", "iPhone10,5": .iPhone8Plus
        case "iPhone10,3", "iPhone10,6": .iPhoneX
        case "iPhone11,2": .iPhoneXS
        case "iPhone11,4", "iPhone11,6": .iPhoneXSMax
        case "iPhone11,8": .iPhoneXR
        case "iPhone12,1": .iPhone11
        case "iPhone12,3": .iPhone11Pro
        case "iPhone12,5": .iPhone11ProMax
        case "iPhone12,8": .iPhoneSE2
        case "iPhone13,2": .iPhone12
        case "iPhone13,1": .iPhone12Mini
        case "iPhone13,3": .iPhone12Pro
        case "iPhone13,4": .iPhone12ProMax
        case "iPhone14,5": .iPhone13
        case "iPhone14,4": .iPhone13Mini
        case "iPhone14,2": .iPhone13Pro
        case "iPhone14,3": .iPhone13ProMax
        case "iPhone14,6": .iPhoneSE3
        case "iPhone14,7": .iPhone14
        case "iPhone14,8": .iPhone14Plus
        case "iPhone15,2": .iPhone14Pro
        case "iPhone15,3": .iPhone14ProMax
        case "iPhone15,4": .iPhone15
        case "iPhone15,5": .iPhone15Plus
        case "iPhone16,1": .iPhone15Pro
        case "iPhone16,2": .iPhone15ProMax
        case "iPhone17,3": .iPhone16
        case "iPhone17,4": .iPhone16Plus
        case "iPhone17,1": .iPhone16Pro
        case "iPhone17,2": .iPhone16ProMax
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": .iPad2
        case "iPad3,1", "iPad3,2", "iPad3,3": .iPad3
        case "iPad3,4", "iPad3,5", "iPad3,6": .iPad4
        case "iPad4,1", "iPad4,2", "iPad4,3": .iPadAir
        case "iPad5,3", "iPad5,4": .iPadAir2
        case "iPad6,11", "iPad6,12": .iPad5
        case "iPad7,5", "iPad7,6": .iPad6
        case "iPad11,3", "iPad11,4": .iPadAir3
        case "iPad7,11", "iPad7,12": .iPad7
        case "iPad11,6", "iPad11,7": .iPad8
        case "iPad12,1", "iPad12,2": .iPad9
        case "iPad13,18", "iPad13,19": .iPad10
        case "iPad13,1", "iPad13,2": .iPadAir4
        case "iPad13,16", "iPad13,17": .iPadAir5
        case "iPad14,8", "iPad14,9": .iPadAir11M2
        case "iPad14,10", "iPad14,11": .iPadAir13M2
        case "iPad2,5", "iPad2,6", "iPad2,7": .iPadMini
        case "iPad4,4", "iPad4,5", "iPad4,6": .iPadMini2
        case "iPad4,7", "iPad4,8", "iPad4,9": .iPadMini3
        case "iPad5,1", "iPad5,2": .iPadMini4
        case "iPad11,1", "iPad11,2": .iPadMini5
        case "iPad14,1", "iPad14,2": .iPadMini6
        case "iPad6,3", "iPad6,4": .iPadPro9Inch
        case "iPad6,7", "iPad6,8": .iPadPro12Inch
        case "iPad7,1", "iPad7,2": .iPadPro12Inch2
        case "iPad7,3", "iPad7,4": .iPadPro10Inch
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4": .iPadPro11Inch
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8": .iPadPro12Inch3
        case "iPad8,9", "iPad8,10": .iPadPro11Inch2
        case "iPad8,11", "iPad8,12": .iPadPro12Inch4
        case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7": .iPadPro11Inch3
        case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11": .iPadPro12Inch5
        case "iPad14,3", "iPad14,4": .iPadPro11Inch4
        case "iPad14,5", "iPad14,6": .iPadPro12Inch6
        case "iPad16,3", "iPad16,4": .iPadPro11M4
        case "iPad16,5", "iPad16,6": .iPadPro13M4
        case "AudioAccessory1,1": .homePod
        case "i386", "x86_64", "arm64": .simulator(fromModel(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))
        default: .unknown(identifier)
        }
#elseif os(tvOS)
        return switch identifier {
        case "AppleTV5,3": .appleTVHD
        case "AppleTV6,2": .appleTV4K
        case "AppleTV11,1": .appleTV4K2
        case "AppleTV14,1": .appleTV4K3
        case "i386", "x86_64", "arm64": .simulator(fromModel(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))
        default: .unknown(identifier)
        }
#elseif os(watchOS)
        return switch identifier {
        case "Watch1,1": .appleWatchSeries0_38mm
        case "Watch1,2": .appleWatchSeries0_42mm
        case "Watch2,6": .appleWatchSeries1_38mm
        case "Watch2,7": .appleWatchSeries1_42mm
        case "Watch2,3": .appleWatchSeries2_38mm
        case "Watch2,4": .appleWatchSeries2_42mm
        case "Watch3,1", "Watch3,3": .appleWatchSeries3_38mm
        case "Watch3,2", "Watch3,4": .appleWatchSeries3_42mm
        case "Watch4,1", "Watch4,3": .appleWatchSeries4_40mm
        case "Watch4,2", "Watch4,4": .appleWatchSeries4_44mm
        case "Watch5,1", "Watch5,3": .appleWatchSeries5_40mm
        case "Watch5,2", "Watch5,4": .appleWatchSeries5_44mm
        case "Watch6,1", "Watch6,3": .appleWatchSeries6_40mm
        case "Watch6,2", "Watch6,4": .appleWatchSeries6_44mm
        case "Watch5,9", "Watch5,11": .appleWatchSE_40mm
        case "Watch5,10", "Watch5,12": .appleWatchSE_44mm
        case "Watch6,6", "Watch6,8": .appleWatchSeries7_41mm
        case "Watch6,7", "Watch6,9": .appleWatchSeries7_45mm
        case "Watch6,14", "Watch6,16": .appleWatchSeries8_41mm
        case "Watch6,15", "Watch6,17": .appleWatchSeries8_45mm
        case "Watch6,10", "Watch6,12": .appleWatchSE2_40mm
        case "Watch6,11", "Watch6,13": .appleWatchSE2_44mm
        case "Watch6,18": .appleWatchUltra
        case "Watch7,3": .appleWatchSeries9_41mm
        case "Watch7,4": .appleWatchSeries9_45mm
        case "Watch7,5": .appleWatchUltra2
        case "Watch7,8", "Watch7,10": .appleWatchSeries10_42mm
        case "Watch7,9", "Watch7,11": .appleWatchSeries10_46mm
        case "i386", "x86_64", "arm64": .simulator(fromModel(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "watchOS"))
        default: .unknown(identifier)
        }
#elseif os(visionOS)
        // TODO: Replace with proper implementation for visionOS.
        return .unknown(identifier)
#else
        return .unknown(identifier)
#endif
    }

}

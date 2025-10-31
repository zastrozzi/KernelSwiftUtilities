//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 20/03/2025.
//

import Foundation

#if os(macOS)
import AppKit
#else
import UIKit
#endif

public struct KSNativeImageColors: Sendable {
    public var background: KSNativeColor
    public var primary: KSNativeColor
    public var secondary: KSNativeColor
    public var detail: KSNativeColor
    
    public init(
        background: KSNativeColor,
        primary: KSNativeColor,
        secondary: KSNativeColor,
        detail: KSNativeColor
    ) {
        self.background = background
        self.primary = primary
        self.secondary = secondary
        self.detail = detail
    }
}

public enum KSNativeImageColorsQuality: CGFloat {
    case lowest = 50
    case low = 100
    case high = 250
    case highest = 0
}

fileprivate struct KSNativeImageColorsCounter {
    let color: Double
    let count: Int
    init(color: Double, count: Int) {
        self.color = color
        self.count = count
    }
}

fileprivate extension Double {
    
    private var r: Double {
        return fmod(floor(self/1000000),1000000)
    }
    
    private var g: Double {
        return fmod(floor(self/1000),1000)
    }
    
    private var b: Double {
        return fmod(self,1000)
    }
    
    var isDarkColor: Bool {
        return (r*0.2126) + (g*0.7152) + (b*0.0722) < 127.5
    }
    
    var isBlackOrWhite: Bool {
        return (r > 232 && g > 232 && b > 232) || (r < 23 && g < 23 && b < 23)
    }
    
    func isDistinct(_ other: Double) -> Bool {
        let _r = self.r
        let _g = self.g
        let _b = self.b
        let o_r = other.r
        let o_g = other.g
        let o_b = other.b
        
        return (fabs(_r - o_r) > 63.75 || fabs(_g - o_g) > 63.75 || fabs(_b - o_b) > 63.75)
        && !(fabs(_r - _g) < 7.65 && fabs(_r - _b) < 7.65 && fabs(o_r - o_g) < 7.65 && fabs(o_r - o_b) < 7.65)
    }
    
    func with(minSaturation: Double) -> Double {
        let _r = r / 255
        let _g = g / 255
        let _b = b / 255
        var H, S, V: Double
        let M = fmax(_r, fmax(_g, _b))
        var C = M - fmin(_r, fmin(_g, _b))
        
        V = M
        S = V == 0 ? 0 : C / V
        
        if minSaturation <= S { return self }
        
        if C == 0 { H = 0 }
        else if _r == M { H = fmod((_g - _b) / C, 6) }
        else if _g == M { H = 2 + ((_b-_r) / C) }
        else { H = 4 + ((_r - _g) / C) }
        
        if H < 0 { H += 6 }

        C = V * minSaturation
        let X = C * (1 - fabs(fmod(H, 2) - 1))
        var R, G, B: Double
        
        switch H {
        case 0...1:
            R = C
            G = X
            B = 0
        case 1...2:
            R = X
            G = C
            B = 0
        case 2...3:
            R = 0
            G = C
            B = X
        case 3...4:
            R = 0
            G = X
            B = C
        case 4...5:
            R = X
            G = 0
            B = C
        case 5..<6:
            R = C
            G = 0
            B = X
        default:
            R = 0
            G = 0
            B = 0
        }
        
        let m = V - C
        
        return (floor((R + m) * 255) * 1000000) + (floor((G + m) * 255) * 1000) + floor((B + m) * 255)
    }
    
    func isContrasting(_ color: Double) -> Bool {
        let bgLum = (0.2126 * r) + (0.7152 * g) + (0.0722 * b) + 12.75
        let fgLum = (0.2126 * color.r) + (0.7152 * color.g) + (0.0722 * color.b) + 12.75
        if bgLum > fgLum {
            return 1.6 < bgLum / fgLum
        } else {
            return 1.6 < fgLum / bgLum
        }
    }
    
    var nativeColor: KSNativeColor {
        return KSNativeColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: 1)
    }
    
    var pretty: String {
        return "\(Int(self.r)), \(Int(self.g)), \(Int(self.b))"
    }
}

public enum KSNativeImageColorError: Error, LocalizedError, CustomStringConvertible {
    case unableToGenerateColors
    
    
    public var errorDescription: String? { self.description }
    
    public var description: String {
        let caseDescription: String = switch self {
        case .unableToGenerateColors: "Unable to generate colors"
        }
        
        return "KSNativeImageColorError: \(caseDescription)"
    }
}


extension KSNativeImage {
#if os(OSX)
    private func resizeForNativeImageColors(newSize: CGSize) -> KSNativeImage? {
        let frame = CGRect(origin: .zero, size: newSize)
        guard let representation = bestRepresentation(for: frame, context: nil, hints: nil) else {
            return nil
        }
        let result = NSImage(size: newSize, flipped: false, drawingHandler: { (_) -> Bool in
            return representation.draw(in: frame)
        })
        
        return result
    }
#else
    private func resizeForNativeImageColors(newSize: CGSize) -> KSNativeImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else {
            fatalError("KSNativeImageColors.resizeForNativeImageColors failed: UIGraphicsGetImageFromCurrentImageContext returned nil.")
        }
        
        return result
    }
#endif
    
    public func getColorsAsync(quality: KSNativeImageColorsQuality = .high) async throws -> KSNativeImageColors {
        return try await withCheckedThrowingContinuation { continuation in
            guard let result = self.getColors(quality: quality) else {
                continuation.resume(throwing: KSNativeImageColorError.unableToGenerateColors)
                return
            }
            continuation.resume(returning: result)
        }
    }
    
    public func getColors(quality: KSNativeImageColorsQuality = .high) -> KSNativeImageColors? {
        var scaleDownSize: CGSize = self.size
        if quality != .highest {
            if self.size.width < self.size.height {
                let ratio = self.size.height/self.size.width
                scaleDownSize = CGSize(width: quality.rawValue/ratio, height: quality.rawValue)
            } else {
                let ratio = self.size.width/self.size.height
                scaleDownSize = CGSize(width: quality.rawValue, height: quality.rawValue/ratio)
            }
        }
        
        guard let resizedImage = self.resizeForNativeImageColors(newSize: scaleDownSize) else { return nil }
        
#if os(OSX)
        guard let cgImage = resizedImage.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return nil }
#else
        guard let cgImage = resizedImage.cgImage else { return nil }
#endif
        
        let width: Int = cgImage.width
        let height: Int = cgImage.height
        
        let threshold = Int(CGFloat(height)*0.01)
        var proposed: [Double] = [-1,-1,-1,-1]
        
        guard let data = CFDataGetBytePtr(cgImage.dataProvider!.data) else {
            fatalError("KSNativeImageColors.getColors failed: could not get cgImage data.")
        }
        
        let imageColors = NSCountedSet(capacity: width*height)
        for x in 0..<width {
            for y in 0..<height {
                let pixel: Int = (y * cgImage.bytesPerRow) + (x * 4)
                if 127 <= data[pixel+3] {
                    imageColors.add((Double(data[pixel+2])*1000000)+(Double(data[pixel+1])*1000)+(Double(data[pixel])))
                }
            }
        }
        
        let sortedColorComparator: Comparator = { (main, other) -> ComparisonResult in
            let m = main as! KSNativeImageColorsCounter, o = other as! KSNativeImageColorsCounter
            if m.count < o.count {
                return .orderedDescending
            } else if m.count == o.count {
                return .orderedSame
            } else {
                return .orderedAscending
            }
        }
        
        var enumerator = imageColors.objectEnumerator()
        var sortedColors = NSMutableArray(capacity: imageColors.count)
        while let K = enumerator.nextObject() as? Double {
            let C = imageColors.count(for: K)
            if threshold < C {
                sortedColors.add(KSNativeImageColorsCounter(color: K, count: C))
            }
        }
        sortedColors.sort(comparator: sortedColorComparator)
        
        var proposedEdgeColor: KSNativeImageColorsCounter
        if 0 < sortedColors.count {
            proposedEdgeColor = sortedColors.object(at: 0) as! KSNativeImageColorsCounter
        } else {
            proposedEdgeColor = KSNativeImageColorsCounter(color: 0, count: 1)
        }
        
        if proposedEdgeColor.color.isBlackOrWhite && 0 < sortedColors.count {
            for i in 1..<sortedColors.count {
                let nextProposedEdgeColor = sortedColors.object(at: i) as! KSNativeImageColorsCounter
                if Double(nextProposedEdgeColor.count)/Double(proposedEdgeColor.count) > 0.3 {
                    if !nextProposedEdgeColor.color.isBlackOrWhite {
                        proposedEdgeColor = nextProposedEdgeColor
                        break
                    }
                } else {
                    break
                }
            }
        }
        proposed[0] = proposedEdgeColor.color
        
        enumerator = imageColors.objectEnumerator()
        sortedColors.removeAllObjects()
        sortedColors = NSMutableArray(capacity: imageColors.count)
        let findDarkTextColor = !proposed[0].isDarkColor
        
        while var K = enumerator.nextObject() as? Double {
            K = K.with(minSaturation: 0.15)
            if K.isDarkColor == findDarkTextColor {
                let C = imageColors.count(for: K)
                sortedColors.add(KSNativeImageColorsCounter(color: K, count: C))
            }
        }
        sortedColors.sort(comparator: sortedColorComparator)
        
        for color in sortedColors {
            let color = (color as! KSNativeImageColorsCounter).color
            
            if proposed[1] == -1 {
                if color.isContrasting(proposed[0]) {
                    proposed[1] = color
                }
            } else if proposed[2] == -1 {
                if !color.isContrasting(proposed[0]) || !proposed[1].isDistinct(color) {
                    continue
                }
                proposed[2] = color
            } else if proposed[3] == -1 {
                if !color.isContrasting(proposed[0]) || !proposed[2].isDistinct(color) || !proposed[1].isDistinct(color) {
                    continue
                }
                proposed[3] = color
                break
            }
        }
        
        let isDarkBackground = proposed[0].isDarkColor
        for i in 1...3 {
            if proposed[i] == -1 {
                proposed[i] = isDarkBackground ? 255255255:0
            }
        }
        
        return KSNativeImageColors(
            background: proposed[0].nativeColor,
            primary: proposed[1].nativeColor,
            secondary: proposed[2].nativeColor,
            detail: proposed[3].nativeColor
        )
    }
}

extension KSNativeImage {
    public var averageColor: KSNativeColor? {
        #if os(macOS)
        guard
            let tiffRepresentation = self.tiffRepresentation,
            let tiffBitmap = NSBitmapImageRep(data: tiffRepresentation),
            let inputImage = CIImage(bitmapImageRep: tiffBitmap)   
        else {
            return nil
        }
        #else
        guard let inputImage = CIImage(image: self) else { return nil }
        #endif
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)
        
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull!])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        
        return KSNativeColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}

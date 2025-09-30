//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 30/09/2025.
//

import SwiftUI
import CoreGraphics
//import UIKit

#if canImport(UIKit)
extension BarcodeImageView {
    enum CodabarRenderer {
        
        // Codabar patterns are sequences of 7 elements (bar/space/bar/space/bar/space/bar),
        // each "n" (narrow) or "w" (wide). Between characters there is a narrow space (inter-character gap).
        // These patterns are the standard NW-7 (Codabar) encodings.
        private static let patterns: [Character: String] = [
            "0": "nnnnwwn",
            "1": "nnnwwnn",
            "2": "nnwnnwn",
            "3": "wwnnnnn",
            "4": "nwnnwnn",
            "5": "wnnnwnn",
            "6": "nnnwnwn",
            "7": "nnnwnnw",
            "8": "nwnnnwn",
            "9": "wnnnnwn",
            "-": "nnnwwnw",
            "$": "nnwwnnw",
            ":": "wnnnwnw",
            "/": "wnnwnnw",
            ".": "wnwnnnw",
            "+": "nnwnwnw",
            // Start/Stop (A–D) — Codabar requires one of A/B/C/D as start and end
            "A": "nnwwnnn",
            "B": "nnnwwnn",
            "C": "nnnnwwn",
            "D": "nnnwnwn"
        ]
        
        @MainActor static func render(text: String,
                           targetWidth: Int,
                           height: Int,
                           module: Int,
                           wideRatio: Int,
                           quietZoneModules: Int) -> UIImage? {
            
            // 1) Normalize text: ensure start/stop (A–D). If missing, wrap with 'A'.
            let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
            let normalized: [Character] = {
                guard let first = trimmed.first, let last = trimmed.last,
                      "ABCD".contains(first), "ABCD".contains(last) else {
                    return Array("A" + trimmed + "A")
                }
                return Array(trimmed)
            }()
            
            // 2) Build the sequence of bar/space modules (in pixels), starting with a bar.
            // Each character contributes 7 elements; we add a narrow inter-character space (= 1 module) between characters.
            var sequence: [Int] = [] // widths in pixels; odd indices are spaces, even are bars (starting at 0).
            let narrow = module
            let wide = module * max(2, wideRatio)
            
            func appendPattern(_ pattern: String) {
                // pattern length should be 7
                for ch in pattern {
                    sequence.append(ch == "w" ? wide : narrow)
                }
            }
            
            // Quiet zone (both sides)
            let quiet = max(quietZoneModules, 10) * narrow
            
            // Accumulate patterns
            for (i, ch) in normalized.enumerated() {
                guard let pat = patterns[ch] else {
                    // Unsupported character -> fail
                    return nil
                }
                appendPattern(pat)
                if i != normalized.count - 1 {
                    // Inter-character gap (narrow space)
                    sequence.append(narrow)
                }
            }
            
            // 3) Compute total width and scale if needed to hit targetWidth (roughly).
            let contentWidth = sequence.reduce(0, +)
            var scale: CGFloat = 1.0
            let totalWidth = contentWidth + 2 * quiet
            if totalWidth < targetWidth {
                // upscale modules evenly to better fill the targetWidth
                scale = CGFloat(targetWidth) / CGFloat(totalWidth)
            }
            
            // 4) Draw bars into a grayscale bitmap
            let scaledHeight = max(1, height)
            let finalWidth = Int(ceil(CGFloat(totalWidth) * scale))
            
            let colorSpace = CGColorSpaceCreateDeviceGray()
            guard let ctx = CGContext(
                data: nil,
                width: finalWidth,
                height: scaledHeight,
                bitsPerComponent: 8,
                bytesPerRow: 0,
                space: colorSpace,
                bitmapInfo: CGImageAlphaInfo.none.rawValue
            ) else { return nil }
            
            // White background
            ctx.setFillColor(CGColor(gray: 1.0, alpha: 1.0))
            ctx.fill(CGRect(x: 0, y: 0, width: finalWidth, height: scaledHeight))
            
            // Black bars
            ctx.setFillColor(CGColor(gray: 0.0, alpha: 1.0))
            
            var x = Int(CGFloat(quiet) * scale)
            var isBar = true
            for widthPx in sequence.map({ Int(ceil(CGFloat($0) * scale)) }) {
                if isBar && widthPx > 0 {
                    ctx.fill(CGRect(x: x, y: 0, width: widthPx, height: scaledHeight))
                }
                x += widthPx
                isBar.toggle()
            }
            
            guard let cg = ctx.makeImage() else { return nil }
            return UIImage(cgImage: cg, scale: UIScreen.main.scale, orientation: .up)
        }
    }
}
#endif

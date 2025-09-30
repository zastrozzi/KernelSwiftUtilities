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
import UIKit

extension BarcodeImageView {
    enum Code39Renderer {
        
        // Patterns from Code 39 spec: 9 elements per char (B S B S B S B S B), 3 wide & 6 narrow.
        // "n" = narrow, "w" = wide. Starts with a bar.
        // Source: TechnoRiver table + general spec details. (See citations in the chat text.)
        private static let patterns: [Character: String] = [
            "0":"nnnwwnwnn","1":"wnnwnnnnw","2":"nnwwnnnnw","3":"wnwwnnnnn",
            "4":"nnnwwnnnw","5":"wnnwwnnnn","6":"nnwwwnnnn","7":"nnnwnnwnw",
            "8":"wnnwnnwnn","9":"nnwwnnwnn",
            "A":"wnnnnwnnw","B":"nnwnnwnnw","C":"wnwnnwnnn","D":"nnnnwwnnw",
            "E":"wnnnwwnnn","F":"nnwnwwnnn","G":"nnnnnwwnw","H":"wnnnnwwnn",
            "I":"nnwnnwwnn","J":"nnnnwwwnn",
            "K":"wnnnnnnww","L":"nnwnnnnww","M":"wnwnnnnwn","N":"nnnnwnnww",
            "O":"wnnnwnnwn","P":"nnwnwnnwn","Q":"nnnnnnwww","R":"wnnnnnwwn",
            "S":"nnwnnnwwn","T":"nnnnwnwwn",
            "U":"wwnnnnnnw","V":"nwwnnnnnw","W":"wwwnnnnnn","X":"nwnnwnnnw",
            "Y":"wwnnwnnnn","Z":"nwwnwnnnn",
            "-":"nwnnnnwnw",".":"wwnnnnwnn"," ":"nwwnnnwnn","*":"nwnnwnwnn",
            "$":"nwnwnwnnn","/":"nwnwnnnwn","+":"nwnnnwnwn","%":"nnnwnwnwn"
        ]
        
        @MainActor static func render(text: String,
                           targetWidth: Int,
                           height: Int,
                           module: Int,
                           wideRatio: Int,
                           quietZoneModules: Int) -> UIImage? {
            
            // 1) Normalize input: enforce start/stop '*' (auto-wrap if absent).
            let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
            let normalized: [Character] = {
                guard let f = trimmed.first, let l = trimmed.last, f == "*", l == "*" else {
                    return Array("*" + trimmed + "*")
                }
                return Array(trimmed)
            }()
            
            // 2) Validate characters
            for ch in normalized {
                guard patterns[ch] != nil else { return nil }
            }
            
            // 3) Build element widths (starting with a bar); add narrow inter-character space after each char.
            let narrow = max(1, module)
            let wide = narrow * wideRatio
            let quiet = quietZoneModules * narrow
            
            var sequence: [Int] = [] // widths in pixels; toggles bar/space, starting with bar
            sequence.reserveCapacity(normalized.count * 10 + 2)
            
            func appendPattern(_ p: String) {
                for e in p {
                    sequence.append(e == "w" ? wide : narrow) // 9 elements per char
                }
            }
            
            for (i, ch) in normalized.enumerated() {
                appendPattern(patterns[ch]!)
                if i != normalized.count - 1 {
                    // Inter-character gap: 1 narrow space
                    sequence.append(narrow)
                }
            }
            
            // 4) Compute total and scale up to roughly match targetWidth (keeps modules integral).
            let contentWidth = sequence.reduce(0, +)
            let totalWidth = contentWidth + 2 * quiet
            let scale = totalWidth < targetWidth ? CGFloat(targetWidth) / CGFloat(totalWidth) : 1.0
            let finalWidth = Int(ceil(CGFloat(totalWidth) * scale))
            let finalHeight = max(1, height)
            
            // 5) Draw bitmap (grayscale)
            let cs = CGColorSpaceCreateDeviceGray()
            guard let ctx = CGContext(data: nil,
                                      width: finalWidth,
                                      height: finalHeight,
                                      bitsPerComponent: 8,
                                      bytesPerRow: 0,
                                      space: cs,
                                      bitmapInfo: CGImageAlphaInfo.none.rawValue) else { return nil }
            
            // White background
            ctx.setFillColor(CGColor(gray: 1, alpha: 1))
            ctx.fill(CGRect(x: 0, y: 0, width: finalWidth, height: finalHeight))
            
            // Black bars
            ctx.setFillColor(CGColor(gray: 0, alpha: 1))
            
            var x = Int(CGFloat(quiet) * scale)
            var isBar = true
            for w in sequence {
                let wpx = Int(ceil(CGFloat(w) * scale))
                if isBar && wpx > 0 {
                    ctx.fill(CGRect(x: x, y: 0, width: wpx, height: finalHeight))
                }
                x += wpx
                isBar.toggle()
            }
            
            guard let cg = ctx.makeImage() else { return nil }
            return UIImage(cgImage: cg, scale: UIScreen.main.scale, orientation: .up)
        }
    }
}
#endif

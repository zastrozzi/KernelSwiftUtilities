//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 06/09/2023.
//

import Foundation

extension String {
    public static let fourSpaceTab: String = tab(4)
    public static func tab(_ spaces: Int = 4) -> String { return String(repeating: .space, count: spaces)}
    public static func tabbedNewLine(tabCount: Int = 1, tabSpaces: Int = 4) -> String {
        return .newLine + String(repeating: .tab(tabSpaces), count: tabCount)
    }
    public static func tabs(tabCount: Int = 1, tabSpaces: Int = 4) -> String {
        return String(repeating: .tab(tabSpaces), count: tabCount)
    }
    public static func debugPropertyTabbedNewLine(tabCount: Int = 1, tabSpaces: Int = 4, property: String) -> String {
        tabbedNewLine(tabCount: tabCount, tabSpaces: tabSpaces) + "- \(property): "
    }
    public static let newLine: String = "\n"
    public static let space: String = " "
}

//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/08/2023.
//

import Foundation
import SwiftUI

public protocol BinaryInputRepresentable: Equatable, Hashable, Identifiable, RawRepresentable where Self.RawValue == Bool {
    var image: String { get }
    var title: String { get }
    var labelColor: Color { get }
    var iconColor: Color { get }
}

extension BinaryInputRepresentable {
    public static var options: [Self] { [.init(rawValue: false)!, .init(rawValue: true)!] }
}

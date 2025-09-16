//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/08/2023.
//

import Foundation
import SwiftUI

extension HorizontalAlignment {
    public var asProportion: Double {
        switch self {
        case .leading: 0
        case .trailing: 1
        default: 0.5
        }
    }
}

extension VerticalAlignment {
    public var asProportion: Double {
        switch self {
        case .top: 0
        case .bottom: 1
        default: 0.5
        }
    }
}

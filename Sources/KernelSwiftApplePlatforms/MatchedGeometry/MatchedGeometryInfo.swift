//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 13/03/2025.
//

import Foundation
import SwiftUI

public struct MatchedGeometryInfo: Identifiable, @unchecked Sendable {
    private(set) public var id: UUID = .init()
    private(set) var infoID: String
    var isActive: Bool = false
    var layerView: AnyView?
    var animateView: Bool = false
    var hideView: Bool = false
    var sourceAnchor: Anchor<CGRect>?
    var destinationAnchor: Anchor<CGRect>?
    var updateSourceContinuously: Bool = false
    var lastSourceAnchor: Anchor<CGRect>?
    var sCornerRadius: CGFloat = 0
    var dCornerRadius: CGFloat = 0
    var zIndex: Double = 0
    var completion: (Bool) -> () = { _ in }
    
    public init(id: String) {
        self.infoID = id
    }
}

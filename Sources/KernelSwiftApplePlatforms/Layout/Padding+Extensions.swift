//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 29/08/2023.
//

import Foundation
import SwiftUI

extension View {
    public func padding(vertical: CGFloat, horizontal: CGFloat) -> some View {
        self.padding(.init(vertical: vertical, horizontal: horizontal))
    }
}

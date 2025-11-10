//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 01/09/2022.
//

import Foundation
import SwiftUI

extension EdgeInsets {
    public init(vertical: CGFloat = 0, horizontal: CGFloat = 0) {
        self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }
    
    public init(vertical: CGFloat = 0, leading: CGFloat = 0, trailing: CGFloat = 0) {
        self.init(top: vertical, leading: leading, bottom: vertical, trailing: trailing)
    }
    
    public init(horizontal: CGFloat = 0, top: CGFloat = 0, bottom: CGFloat = 0) {
        self.init(top: top, leading: horizontal, bottom: bottom, trailing: horizontal)
    }
    
    public init(top: CGFloat = 0, bottom: CGFloat = 0, leading: CGFloat = 0, trailing: CGFloat = 0) {
        self.init(top: top, leading: leading, bottom: bottom, trailing: trailing)
    }
    
    public init(_ all: CGFloat = 0) {
        self.init(vertical: all, horizontal: all)
    }
}

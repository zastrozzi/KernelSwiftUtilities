//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 30/08/2022.
//

import Foundation
import SwiftUI

public struct DefaultCaseView<Content>: View where Content: View {
    private let content: () -> Content
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        self.content()
    }
}

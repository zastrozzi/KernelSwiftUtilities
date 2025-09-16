//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 30/08/2022.
//

import Foundation
import SwiftUI

public struct IfLetView<Value: Sendable, IfContent, ElseContent>: View where IfContent: View, ElseContent: View {
    public let value: Binding<Value?>
    public let ifContent: (Binding<Value>) -> IfContent
    public let elseContent: () -> ElseContent
    
    public init(_ value: Binding<Value?>, @ViewBuilder then ifContent: @escaping (Binding<Value>) -> IfContent, @ViewBuilder else elseContent: @escaping () -> ElseContent) {
        self.value = value
        self.ifContent = ifContent
        self.elseContent = elseContent
    }
    
    public var body: some View {
        if let $value = Binding(unwrapping: self.value) { ifContent($value) } else { elseContent() }
    }
}

extension IfLetView where ElseContent == EmptyView {
    public init(_ value: Binding<Value?>, @ViewBuilder then ifContent: @escaping (Binding<Value>) -> IfContent) {
        self.value = value
        self.ifContent = ifContent
        self.elseContent = { EmptyView() }
    }
}


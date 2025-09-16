//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 30/08/2022.
//

import Foundation
import SwiftUI
import KernelSwiftCommon

public struct IfCaseLetView<Enum: Sendable, Case: Sendable, IfContent, ElseContent>: View where IfContent: View, ElseContent: View {
    public let bkEnum: Binding<Enum>
    public let casePath: KernelCasePath<Enum, Case>
    public let ifContent: (Binding<Case>) -> IfContent
    public let elseContent: () -> ElseContent
    
    public init(_ bkEnum: Binding<Enum>, pattern casePath: KernelCasePath<Enum, Case>, @ViewBuilder ifContent: @escaping (Binding<Case>) -> IfContent, @ViewBuilder elseContent: @escaping () -> ElseContent) {
        self.bkEnum = bkEnum
        self.casePath = casePath
        self.ifContent = ifContent
        self.elseContent = elseContent
    }
    
    public var body: some View {
        if let caseBinding = Binding(unwrapping: self.bkEnum, case: self.casePath) { ifContent(caseBinding) } else { elseContent() }
    }
}

extension IfCaseLetView where ElseContent == EmptyView {
    public init(_ bkEnum: Binding<Enum>, pattern casePath: KernelCasePath<Enum, Case>, @ViewBuilder ifContent: @escaping (Binding<Case>) -> IfContent) {
        self.bkEnum = bkEnum
        self.casePath = casePath
        self.ifContent = ifContent
        self.elseContent = { EmptyView() }
    }
}

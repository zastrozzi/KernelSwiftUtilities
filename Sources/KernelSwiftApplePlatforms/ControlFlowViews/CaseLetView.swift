//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 30/08/2022.
//

import Foundation
import SwiftUI
import KernelSwiftCommon

#if compiler(>=5.7)
public struct CaseLetView<Enum: Sendable, Case: Sendable, Content>: View where Content: View {
    @EnvironmentObject private var bkEnum: ControlFlowBindingObject<Enum>
    
    public let casePath: KernelCasePath<Enum, Case>
    public let content: (Binding<Case>) -> Content
    
    public init(_ casePath: KernelCasePath<Enum, Case>, @ViewBuilder then content: @escaping (Binding<Case>) -> Content) {
        self.casePath = casePath
        self.content = content
    }
    
    public var body: some View {
        Binding(unwrapping: self.bkEnum.wrappedValue, case: self.casePath).map(self.content)
    }
}


public protocol EnumCaseContent<E> {
    associatedtype E: Sendable
    associatedtype C: Sendable
    associatedtype V: View
}


public struct CaseLetView2<ECC: EnumCaseContent>: View {
    @EnvironmentObject private var bkEnum: ControlFlowBindingObject<ECC.E>
    
    public let casePath: KernelCasePath<ECC.E, ECC.C>
    public let content: (Binding<ECC.C>) -> ECC.V
    
    public init(_ casePath: KernelCasePath<ECC.E, ECC.C>, @ViewBuilder then content: @escaping (Binding<ECC.C>) -> ECC.V) {
        self.casePath = casePath
        self.content = content
    }
    
    public var body: some View {
//        Binding(unwrapping: self.bkEnum.wrappedValue, case: self.casePath).map(self.content)
        Text("")
    }
}
#endif

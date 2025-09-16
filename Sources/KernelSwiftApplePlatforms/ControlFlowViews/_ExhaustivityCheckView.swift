//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 30/08/2022.
//

import Foundation
import SwiftUI
import KernelSwiftCommon

public struct _ExhaustivityCheckView<Enum>: View {
    @EnvironmentObject private var bkEnum: ControlFlowBindingObject<Enum>
    let file: StaticString
    let line: UInt
    
    public var body: some View {
    #if DEBUG
        let message = """
        Warning: SwitchView.body@\(self.file):\(self.line)
        
        "SwitchView" did not handle "\(describeCase(self.bkEnum.wrappedValue.wrappedValue))"
        
        Make sure that you exhaustively provide a "CaseLetView" view for each case in "\(Enum.self)", \
        provide a "DefaultView" view at the end of the "SwitchView", or use an "IfCaseLetView" view instead.
        """
        VStack(spacing: 15) {
            Image(systemName: "exclamationmark.triangle.fill").font(.largeTitle)
            Text(message)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(.white)
        .padding()
        .background(Color.red.edgesIgnoringSafeArea(.all))
        .onAppear {
            raiseBreakpoint(
                """
                ---
                \(message)
                ---
                """
            )
        }
    #else
        EmptyView()
    #endif
    }
    
    func describeCase(_ targetEnum: Enum) -> String {
        let mirror = Mirror(reflecting: targetEnum)
        let targetEnumCaseDescription: String
        if mirror.displayStyle == .enum, let child = mirror.children.first, let label = child.label {
            let childMirror = Mirror(reflecting: child.value)
            let associatedValueMirror = childMirror.displayStyle == .tuple ? childMirror : Mirror(targetEnum, unlabeledChildren: [child.value], displayStyle: .tuple)
            targetEnumCaseDescription = """
            \(label)(\
            \(associatedValueMirror.children.map { "\($0.label ?? "_"):" }.joined())\
            )
            """
        } else {
            targetEnumCaseDescription = "\(targetEnum)"
        }
        
        var type = String(reflecting: Enum.self)
        if let index = type.firstIndex(of: ".") { type.removeSubrange(...index) }
        return "\(type).\(targetEnumCaseDescription)"
    }
}

//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/12/2025.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct KernelSwiftApplePlatformMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        ProgressOptionSetMacro.self
    ]
}

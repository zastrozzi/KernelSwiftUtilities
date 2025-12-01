//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/12/2025.
//

import KernelSwiftApplePlatforms

@attached(member, names: named(completed), named(mostRecentStage))
@attached(peer)
public macro ProgressOptionSet() = #externalMacro(
    module: "KernelSwiftApplePlatformMacroDeclarations",
    type: "ProgressOptionSetMacro"
)


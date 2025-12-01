//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/12/2025.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct ProgressOptionSetMacro {}

extension ProgressOptionSetMacro: MemberMacro {
    public static func expansion(
        of attribute: AttributeSyntax,
        providingMembersOf decl: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        
        return [
            // Stored properties
            DeclSyntax(stringLiteral: """
            var completed: Set<Stage> = []
            """),
            
            DeclSyntax(stringLiteral: """
            var mostRecentStage: Stage? = nil
            """)
        ]
    }
}


extension ProgressOptionSetMacro: PeerMacro {
    public static func expansion(
        of attribute: AttributeSyntax,
        providingPeersOf decl: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        
        guard let structDecl = decl.as(StructDeclSyntax.self) else { return [] }
        
        let inheritedType = InheritedTypeSyntax(
            type: TypeSyntax(stringLiteral: "ProgressOptionSet")
        )
        
        let newInheritance =
        structDecl.inheritanceClause?.with(
            \.inheritedTypes,
             structDecl.inheritanceClause!.inheritedTypes.appending(inheritedType)
        )
        ?? InheritanceClauseSyntax(inheritedTypes: [inheritedType])
        
        var newStruct = structDecl
        newStruct.inheritanceClause = newInheritance
        
        return [DeclSyntax(newStruct)]
    }
}

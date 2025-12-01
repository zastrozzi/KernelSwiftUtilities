//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/12/2025.
//

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct ProgressOptionSetMacro: MemberMacro, PeerMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        return Self.makeMembers()
    }
    
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        return Self.makeMembers()
    }
    
    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
            return []
        }
        
        let inheritedType = InheritedTypeSyntax(
            type: TypeSyntax(stringLiteral: "_ProgressOptionSet")
        )
        
        let newInheritance: InheritanceClauseSyntax
        if let clause = structDecl.inheritanceClause {
            newInheritance = clause.with(
                \.inheritedTypes,
                clause.inheritedTypes + [inheritedType]
            )
        } else {
            newInheritance = InheritanceClauseSyntax(
                inheritedTypes: InheritedTypeListSyntax([inheritedType])
            )
        }
        
        var newStruct = structDecl
        newStruct.inheritanceClause = newInheritance
        
        return [DeclSyntax(newStruct)]
    }
    
    private static func makeMembers() -> [DeclSyntax] {
        let members: [DeclSyntax] = [
            // Storage for completed stages
            """
            var completed: Set<Stage> = []
            """,
            // Most recently completed stage
            """
            var mostRecentStage: Stage? = nil
            """,
            // Default initialiser
            """
            init() {}
            """,
            """
            init(arrayLiteral elements: Stage...) {
                self.init()
                self.completed = Set(elements)
                self.mostRecentStage = elements.last
            }
            """
        ].map { DeclSyntax(stringLiteral: $0) }
        return members
    }
}


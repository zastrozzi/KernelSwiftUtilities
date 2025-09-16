//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 11/02/2025.
//

import SQLKit
//
//extension SQLBinaryExpression {
//    public init(_ expressions: [SQLBinaryExpression], _ op: SQLBinaryOperator) {
//        guard !expressions.isEmpty else {
//            preconditionFailure("Binary expression list must contain at least one expression")
//        }
//        if expressions.count == 1 {
//            self = expressions[0]
//            return
//        }
//        guard [.and, .or].contains(op) else {
//            preconditionFailure("Unsupported binary operator \(op)")
//        }
//        var index: Int = expressions.count - 1
//        var formedExpression: SQLBinaryExpression = .init(expressions[index - 1], op, expressions[index])
//        index -= 2
//        while index > 0 {
//            formedExpression = .init(expressions[index], op, formedExpression)
//            index -= 1
//        }
//        self = formedExpression
//    }
//    
//    public init(_ expressions: SQLBinaryExpression..., op: SQLBinaryOperator) {
//        self.init(expressions, op)
//    }
//}

extension SQLBinaryExpression {
    /// Create a nested expression containing a series of expressions joined by a given operator (usually either `.and` or `.or`).
    public init(operator: SQLBinaryOperator, _ firstExpr: SQLBinaryExpression, _ expressions: [SQLBinaryExpression]) {
        self = expressions.reduce(firstExpr) { SQLBinaryExpression($0, `operator`, $1) }
    }
    
    /// Create a nested expression containing a series of expressions joined by a given operator (usually either `.and` or `.or`).
    public init(operator: SQLBinaryOperator, _ firstExpr: SQLBinaryExpression, _ expressions: SQLBinaryExpression...) {
        self.init(operator: `operator`, firstExpr, expressions)
    }
}

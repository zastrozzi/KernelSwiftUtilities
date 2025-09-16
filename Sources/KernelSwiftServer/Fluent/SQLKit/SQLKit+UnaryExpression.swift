//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 04/11/2024.
//

import SQLKit

public enum SQLUnaryOperator: SQLExpression {
    /// Boolean inversion, or `NOT`.
    case not
    
    /// Arithmetic negation, or `-`.
    case negate
    
    /// Arithmetic positation, or `+` (no operation).
    case plus
    
    /// Bitwise inversion, or `~`.
    case invert
    
    /// Escape hatch for easily defining additional unary operators.
    case custom(String)
    
    // See `SQLExpression.serialize(to:)`.
    @inlinable
    public func serialize(to serializer: inout SQLSerializer) {
        switch self {
        case .not: serializer.write("NOT")
        case .negate: serializer.write("-")
        case .plus: serializer.write("+")
        case .invert: serializer.write("~")
        case .custom(let custom): serializer.write(custom)
        }
    }
}

/// A fundamental syntactical expression - a unary operator and its single operand.
public struct SQLUnaryExpression: SQLExpression {
    /// The unary operator.
    public let op: any SQLExpression
    
    /// The operand to which the operator applies.
    public let operand: any SQLExpression
    
    /// Create a new unary expression from components.
    ///
    /// - Parameters:
    ///   - op: The operator.
    ///   - operand: The operand.
    public init(op: some SQLExpression, operand: some SQLExpression) {
        self.op = op
        self.operand = operand
    }
    
    /// Create a unary expression from a predefined unary operator and an operand expression.
    ///
    /// - Parameters:
    ///   - op: The operator.
    ///   - operand: The operand.
    public init(_ op: SQLUnaryOperator, _ operand: some SQLExpression) {
        self.init(op: op, operand: operand)
    }
    
    // See `SQLExpression.serialize(to:)`.
    public func serialize(to serializer: inout SQLSerializer) {
        serializer.statement {
            $0.append(self.op, self.operand)
        }
    }
}

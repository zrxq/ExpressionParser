//
//  Parser.swift
//
//
//  Created by Zoreslav Khimich on 26.12.2023.
//

import Foundation

extension ExpressionParser {
    public static func parse(_ tokens: Tokens) throws -> Decimal {
        var index: Tokens.Index = 0

        var isAtEnd: Bool {
            index >= tokens.count
        }

        var current: Token? {
            guard index < tokens.count else {
                return .none
            }
            return tokens[index]
        }

        @discardableResult
        func popCurrent() -> Token? {
            let result = current
            index += 1
            return result
        }

        func parseParens() throws -> Decimal {
            guard let token = popCurrent(), case Token.parensOpen = token else {
                throw ParserError(.beginOfParenthesisExpected, index - 1)
            }

            let expression = try parseExpression()

            guard let token = popCurrent(), case Token.parensClose = token else {
                throw ParserError(.endOfParenthesisExpected, index - 1)
            }
            return expression
        }

        func parseDecimal() throws -> Decimal {
            guard let token = popCurrent(), case Token.decimal(let value) = token else {
                throw ParserError(.invalidNumber, index - 1)
            }
            return value
        }

        func parseUnary() throws -> Decimal {
            guard let token = popCurrent() else {
                throw ParserError(.unexpectedEndOfExpression, index - 1)
            }
            switch token {
            case .plus:
                return try parsePrimary(beforeOperator: false)
            case .minus:
                return try -parsePrimary(beforeOperator: false)
            default:
                throw ParserError(.unaryOperatorExpected(token), index - 1)
            }
        }

        func parsePrimary(beforeOperator: Bool) throws -> Decimal {
            switch current {
            case .decimal:
                return try parseDecimal()
            case .parensOpen:
                return try parseParens()
            case .minus, .plus:
                return try parseUnary()
            case .none:
                if beforeOperator {
                    throw ParserError(.unexpectedEndOfExpression, index)
                } else {
                    throw ParserError(.expressionAfterOperatorExpected, index)
                }
            case .some(let token):
                if beforeOperator {
                    throw ParserError(.unaryOperatorExpected(token), index)
                } else {
                    throw ParserError(.expressionAfterOperatorExpected, index)
                }
            }
        }

        func parseOperator() throws -> Operation {
            let token = popCurrent()
            switch token {
            case .plus:
                return .add
            case .minus:
                return .sub
            case .multiply:
                return .mul
            case .divide:
                return .div
            default:
                throw ParserError(.operatorExpected, index - 1)
            }
        }

        func parseBinaryOperations(lhs: Decimal) throws -> Decimal {
            var lhs = lhs
            while true {
                guard let current else { break }
                if case Token.parensClose = current {
                    return lhs // end of expression in parenthesis
                }
                let op = try parseOperator()
                let rhs = try parsePrimary(beforeOperator: false)
                switch op {
                case .mul:
                    lhs = lhs * rhs
                case .div:
                    lhs = lhs / rhs
                case .add:
                    let rhs = try parseBinaryOperations(lhs: rhs)
                    return lhs + rhs
                case .sub:
                    let rhs = try parseBinaryOperations(lhs: rhs)
                    return lhs - rhs
                }
            }
            return lhs
        }

        func parseExpression() throws -> Decimal {
            let lhs = try parsePrimary(beforeOperator: true)
            return try parseBinaryOperations(lhs: lhs)
        }

        enum Operation: String, CustomStringConvertible {
            case add = "+"
            case sub = "-"
            case mul = "*"
            case div = "/"

            var description: String {
                rawValue
            }
        }

        return try parseExpression()
    }
}

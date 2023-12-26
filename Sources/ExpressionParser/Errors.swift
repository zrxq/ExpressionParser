//
//  Errors.swift
//
//
//  Created by Zoreslav Khimich on 26.12.2023.
//

import Foundation

extension ExpressionParser {
    enum TokenizerError: Error {
        case invalidCharacter(character: Character, index: String.Index)
        case invalidDecimal(decialString: String, index: String.Index)
    }
}

extension ExpressionParser {
    struct ParserError: Error {
        init(_ kind: ErrorType, _ index: Tokens.Index) {
            self.type = kind
            self.tokenIndex = index
        }

        let type: ErrorType
        let tokenIndex: Tokens.Index
    }
}

extension ExpressionParser.ParserError {
    enum ErrorType {
        case invalidNumber
        case beginOfParenthesisExpected
        case endOfParenthesisExpected
        case unaryOperatorExpected(ExpressionParser.Token)
        case expressionAfterOperatorExpected
        case operatorExpected
        case unexpectedToken(ExpressionParser.Token)
        case unexpectedEndOfExpression
    }
}

extension ExpressionParser.ParserError.ErrorType: CustomStringConvertible {
    var description: String {
        switch self {
        case .beginOfParenthesisExpected:
            return "'(' expected."
        case .endOfParenthesisExpected:
            return "')' expected"
        case .invalidNumber:
            return "Invalid number"
        case .expressionAfterOperatorExpected:
            return "Expected expression after operator"
        case .unaryOperatorExpected(let token):
            return "'\(token)' is not a prefix unary operator"
        case .operatorExpected:
            return "Operator expected"
        case .unexpectedToken(let token):
            return "Unexpected token '\(token)'"
        case .unexpectedEndOfExpression:
            return "Unexpected end of expression"
        }
    }
}

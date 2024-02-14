//
//  Errors.swift
//
//
//  Created by Zoreslav Khimich on 26.12.2023.
//

import Foundation

extension ExpressionParser {
    public struct EvaluationError: Error, CustomStringConvertible {
        public let error: ErrorType
        public let location: Int
        public let index: String.Index

        public var description: String {
            switch error {
            case .tokenizer(let error):
                return error.description
            case .parser(let error):
                return error.description
            }
        }
    }

    public enum ErrorType {
        case tokenizer(TokenizerError)
        case parser(ParserError)
    }
}

extension ExpressionParser {

    public struct TokenizerError: Error, CustomStringConvertible {
        public let error: TokenizerErrorType
        public let index: String.Index

        public var description: String {
            error.description
        }
    }

    public enum TokenizerErrorType: Equatable {
        case invalidCharacter(Character)
        case invalidDecimal(decimalString: String)
    }
}

extension ExpressionParser.TokenizerErrorType: CustomStringConvertible {
    public var description: String {
        switch self {
        case .invalidCharacter(character: let c):
            return "Invalid character '\(c)'"
        case.invalidDecimal(decimalString: let string):
            return "'\(string)' is not a valid decimal number"
        }
    }
}

extension ExpressionParser {
    public struct ParserError: Error, CustomStringConvertible {
        init(_ error: ParserErrorType, _ index: Tokens.Index) {
            self.error = error
            self.tokenIndex = index
        }

        public let error: ParserErrorType
        public let tokenIndex: Tokens.Index

        public var description: String {
            error.description
        }
    }

    public enum ParserErrorType: Equatable {
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
extension ExpressionParser.ParserErrorType: CustomStringConvertible {
    public var description: String {
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

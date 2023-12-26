//
//  Lexeme.swift
//
//
//  Created by Zoreslav Khimich on 26.12.2023.
//

import Foundation

extension ExpressionParser {
    public struct Lexeme: Equatable {
        let token: Token
        let location: String.Index
    }

    public enum Token: Equatable {
        case decimal(Decimal)
        case plus
        case minus
        case multiply
        case divide
        case parensOpen
        case parensClose
    }

    public typealias Tokens = [Token]
}

extension ExpressionParser.Token: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .decimal(let value):
            return "\(value)"
        case .plus:
            return "+"
        case .minus:
            return "-"
        case .multiply:
            return "*"
        case .divide:
            return "/"
        case .parensOpen:
            return "("
        case .parensClose:
            return ")"
        }
    }
}

//
//  ExpressionParser.swift
//  SwiftUIPlayground
//
//  Created by Zoreslav Khimich on 24.12.2023.
//

import Foundation

public enum ExpressionParser {
    static public func evaluate(_ expression: String) throws -> Decimal {
        do {
            let lexemes = try tokenize(expression)
            let tokens = lexemes.tokens
            do {
                return try parse(tokens)
            }
            catch let parserError as ParserError {

                let lexemeIndex = parserError.tokenIndex
                let stringIndex: String.Index
                if lexemeIndex < lexemes.count {
                    stringIndex = lexemes[lexemeIndex].index
                } else {
                    stringIndex = expression.endIndex
                }
                let location = expression.location(of: stringIndex)

                throw EvaluationError(
                    error: .parser(parserError),
                    location: location,
                    index: stringIndex
                )
            }
        }
        catch let tokenizerError as TokenizerError {
            let stringIndex = tokenizerError.index
            throw EvaluationError(error: .tokenizer(tokenizerError),
                                  location: expression.location(of: stringIndex),
                                  index: stringIndex)
        }
        catch let otherError {
            throw otherError
        }
    }
}

internal extension String {
    func location(of index: String.Index) -> Int {
        distance(from: self.startIndex, to: index)
    }
}

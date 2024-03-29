//
//  ParserTests.swift
//
//
//  Created by Zoreslav Khimich on 26.12.2023.
//

import XCTest
@testable import ExpressionParser

final class ParserTests: XCTestCase {

    typealias Token = ExpressionParser.Token
    typealias ParserError = ExpressionParser.ParserError
    typealias ErrorType = ExpressionParser.ParserErrorType

    func testParseEmpty() {
        let tokens: [Token] = []
        XCTAssertThrowsError(try ExpressionParser.parse(tokens)) { error in
            guard let error = error as? ParserError else {
                XCTFail("Unexpected error type: \(error)")
                return
            }
            XCTAssertEqual(error.error, .unexpectedEndOfExpression)
        }
    }
    
    func testParseSimpleExpression() throws {
        let tokens: [Token] = [
            .decimal(3),
            .plus,
            .decimal(4)
        ]
        let result = try ExpressionParser.parse(tokens)
        XCTAssertEqual(result, 7)
    }

    func testParseComplexExpression() throws {
        let tokens: [Token] = [
            .decimal(3),
            .plus,
            .parensOpen,
            .decimal(4),
            .multiply,
            .decimal(2),
            .parensClose,
            .minus,
            .decimal(1)
        ]
        let result = try ExpressionParser.parse(tokens)
        XCTAssertEqual(result, 10)
    }

    func testParseUnaryOperators() throws {
        let tokens: [Token] = [
            .minus,
            .decimal(3),
            .plus,
            .minus,
            .decimal(5)
        ]
        let result = try ExpressionParser.parse(tokens)
        XCTAssertEqual(result, -8)
    }

    func testParseInvalidExpression() {
        let tokens: [Token] = [
            .decimal(3),
            .plus
        ]
        XCTAssertThrowsError(try ExpressionParser.parse(tokens)) { error in
            guard let error = error as? ParserError else {
                XCTFail("Unexpected error type: \(error)")
                return
            }
            XCTAssertEqual(error.error, .expressionAfterOperatorExpected)
        }
    }

    // test unary operator precedence
    func testParseUnaryOperatorsPrecedence() throws {
        // -3 + -5 * 2
        let tokens: [Token] = [
            .minus,
            .decimal(3),
            .plus,
            .minus,
            .decimal(5),
            .multiply,
            .decimal(2)
        ]
        let result = try ExpressionParser.parse(tokens)
        XCTAssertEqual(result, -13)
    }
}

import XCTest
@testable import ExpressionParser

final class TokenizerTests: XCTestCase {

    func testTokenizeSingleToken() throws {
        let input = "22.4"
        let actual = try ExpressionParser.tokenize(input)
        let expected: [ExpressionParser.Lexeme] = [
            .init(token: .decimal(22.4), location: input.startIndex)
        ]
        XCTAssertEqual(actual, expected)
    }

    func testTokenizeSimpleExpression() throws {
        let input = "1.5 + 8.4 - (2  *  7)/3"
        let lexemes = try ExpressionParser.tokenize(input)

        let actualTokens = lexemes.map(\.token)
        let expectedTokens: [ExpressionParser.Token] = [
            .decimal(1.5),
            .plus,
            .decimal(8.4),
            .minus,
            .parensOpen,
            .decimal(2),
            .multiply,
            .decimal(7),
            .parensClose,
            .divide,
            .decimal(3)
        ]
        XCTAssertEqual(actualTokens, expectedTokens)

        let actualOffsets = lexemes.map {
            input.distance(from: input.startIndex, to: $0.location)
        }
        let expectedOffsets = [0, 4, 6, 10, 12, 13, 16, 19, 20, 21, 22]
        XCTAssertEqual(actualOffsets, expectedOffsets)
    }

    func testTokenizeWithDifferentSeparators() throws {
        let input = "1'000'000.5 + 20 000,4"
        let lexemes = try ExpressionParser.tokenize(input)

        let actualTokens = lexemes.map(\.token)
        let expectedTokens: [ExpressionParser.Token] = [
            .decimal(1_000_000.5),
            .plus,
            .decimal(20_000.4),
        ]
        XCTAssertEqual(actualTokens, expectedTokens)
    }

    func testTokenizeWithMultipleDecimalSeparators() throws {
        let input = "1,000.00.0.5"
        let lexemes = try ExpressionParser.tokenize(input)

        let actualTokens = lexemes.map(\.token)
        let expectedTokens: [ExpressionParser.Token] = [
            .decimal(1_000_000.5),
        ]
        XCTAssertEqual(actualTokens, expectedTokens)
    }

    func testTokenizeInvalidCharacterError() throws {
        let input = "3 + a"
        XCTAssertThrowsError(try ExpressionParser.tokenize(input)) { error in
            guard case let ExpressionParser.TokenizerError.invalidCharacter(character, index) 
                    = error else {
                return XCTFail("Expected LexerError.invalidCharacter")
            }
            XCTAssertEqual(character, "a")
            XCTAssertEqual(index, input.index(input.startIndex, offsetBy: 4))
        }
    }
}

//
//  Tokenizer.swift
//
//
//  Created by Zoreslav Khimich on 26.12.2023.
//

import Foundation

extension ExpressionParser {
    
    public static func tokenize(_ expression: String) throws -> [Lexeme] {
        var decimalSeparators = CharacterSet(charactersIn: ",.'")
            .union(.whitespaces)

        if let localDecimalSeparator = Locale.current.decimalSeparator {
            decimalSeparators.formUnion(
                CharacterSet(charactersIn: localDecimalSeparator)
            )
        }

        if let localGroupingSeparator = Locale.current.decimalSeparator {
            decimalSeparators.formUnion(
                CharacterSet(charactersIn: localGroupingSeparator)
            )
        }

        let standardLocale = Locale(identifier: "en_US_POSIX")

        func normalize(numericsString: String) -> String {
            var comps = numericsString.split { character in
                for aScalar in character.unicodeScalars {
                    if decimalSeparators.contains(aScalar) {
                        return true
                    }
                }
                return false
            }
            if comps.count == 1 {
                return numericsString
            }
            let fractionString = comps.popLast().flatMap { String($0) }
            let integerString = comps.joined()
            return [integerString, fractionString].compactMap { $0 }.joined(separator: ".")
        }

        let decimalCharacterSet = CharacterSet.decimalDigits
            .union(decimalSeparators)

        var lexemes = [Lexeme]()
        let scanner = Scanner(string: expression)
        // `charactersToBeSkipped` is .whitespacesAndNewlines by default.
        // We don't want that behavior since it messes the start index of the token.
        scanner.charactersToBeSkipped = nil
        let ignoredCharacters = CharacterSet.whitespacesAndNewlines
        while !scanner.isAtEnd {
            // manually skip whitespaces
            _ = scanner.scanCharacters(from: ignoredCharacters)
            let startingIndex = scanner.currentIndex
            if let numericsString = scanner.scanCharacters(from: decimalCharacterSet) {
                let normalized = normalize(numericsString: numericsString)
                if let value = Decimal(string: normalized, locale: standardLocale) {
                    lexemes.append(
                        .init(token: .decimal(value), location: startingIndex)
                    )
                } else {
                    throw TokenizerError.invalidDecimal(decialString: numericsString,
                                                    index: startingIndex)
                }
            } else if let character = scanner.scanCharacter() {
                switch character {
                case "+": lexemes.append(.init(token: .plus, location: startingIndex))
                case "-": lexemes.append(.init(token: .minus, location: startingIndex))
                case "*": lexemes.append(.init(token: .multiply, location: startingIndex))
                case "/": lexemes.append(.init(token: .divide, location: startingIndex))
                case "(": lexemes.append(.init(token: .parensOpen, location: startingIndex))
                case ")": lexemes.append(.init(token: .parensClose, location: startingIndex))
                default: throw TokenizerError.invalidCharacter(character: character,
                                                           index: startingIndex)
                }
            }
        }

        return lexemes
    }
}

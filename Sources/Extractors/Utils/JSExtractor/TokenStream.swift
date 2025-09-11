//
//  TokenStream.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 15/12/2024.
//

import Foundation

enum ParsingError: Error {
    case illegalCharacter(Character)
    case numberFormatError
    case unterminatedStringLiteral
    case unterminatedComment
    case invalidUnicodeEscape
    case invalidURL
}

public class TokenStream {
    private let sourceString: String
    private var sourceCursor: Int
    private var cursor: Int

    private var stringBuffer: [Character]
    private var stringBufferTop: Int

    var tokenBeg: Int// String.Index
    var tokenEnd: Int//String.Index


    private var lineno: Int
    private var lineStart: Int
    private var lineEndChar: UInt8 = 1

    private let languageVersion: Int

    private var dirtyLine: Bool = false
    private var string: String = ""

    private var ungetCursor: Int
    private var ungetBuffer: [UInt8] = [UInt8](repeating: 0, count: 3)
    private var hitEOF: Bool = false

    // Constants
    private static let EOF_CHAR: UInt8 = 1// "\u{0}"
    private static let BYTE_ORDER_MARK: Character = "\u{FEFF}"
    private static let NUMERIC_SEPARATOR: Character = "_"

    init(_ sourceString: String, lineno: Int = 1, languageVersion: Int = 6) {
        fatalError(#function)
    }

    func nextToken() throws -> Token {
        var token = try getToken()
        while token == .eol || token == .comment {
            token = try getToken()
        }
        return token
    }

    private func getToken() throws -> Token {
        fatalError(#function)
    }

    private func getCharIgnoreLineEnd(skipFormattingChars: Bool = true) -> UInt8 {
        getChar(skipFormattingChars: skipFormattingChars, ignoreLineEnd: true)
    }

    private func getChar(skipFormattingChars: Bool, ignoreLineEnd: Bool) -> UInt8 {
        fatalError(#function)
    }

    private func getChar() -> UInt8 {
        fatalError(#function)
    }

    private func matchChar(_ test: Character) -> Bool {
        // Placeholder implementation
        return false
    }

    private func skipLine() {
        // skip to end of line
        var c: UInt8
        repeat {
            c = getChar()
        } while c != TokenStream.EOF_CHAR && c != Int("\n")!
        ungetChar(c)
        tokenEnd = cursor
    }

    private func ungetChar(_ c: UInt8) {
        fatalError(#function)
    }

    private func isJSSpace(_ c: Character) -> Bool {
        if c <= 127 {
            return c == 0x20 || c == 0x09 || c == 0x0C || c == 0x0B
        }

        return c == 0xA0
        || c == TokenStream.BYTE_ORDER_MARK
        || c.unicodeScalars.allSatisfy({ $0.properties.generalCategory == .spaceSeparator || $0 == "\u{9}" })
    }

    //    // Utility methods (stubs to be fully implemented)
    private func addToString(_ c: UInt8) {
        fatalError(#function)
    }

    private static func isJSFormatChar(_ c: UInt8) -> Bool {
        return c > 127 && Character(UnicodeScalar(c)) == "\u{FEFF}"
    }

    /// Parser calls the method when it gets / or /= in literal context.
    func readRegExp(_ startToken: Token) throws {
        fatalError(#function)
    }

    private func peekChar() -> UInt8 {
        let c = getChar()
        ungetChar(c)
        return c
    }
}

import Foundation
//
//class TokenStream {
//    // Constants
//    private static let EOF_CHAR = -1
//    private static let REPORT_NUMBER_FORMAT_ERROR = -2
//    private static let BYTE_ORDER_MARK: Character = "\u{FEFF}"
//    private static let NUMERIC_SEPARATOR: Character = "_"
//
//    // Properties
//    private var sourceString: String
//    private var sourceCursor: String.Index
//    private var cursor: String.Index
//
//    private var lineno: Int
//    private var languageVersion: Int
//
//    private var dirtyLine = false
//    private var string = ""
//
//    private var stringBuffer = [Character](repeating: " ", count: 128)
//    private var stringBufferTop = 0
//    private var allStrings = [String: Int]()
//
//    private var ungetBuffer = [Int](repeating: 0, count: 3)

//
//    private var hitEOF = false
//    private var lineStart: String.Index
//    private var lineEndChar = -1
//
//    private var tokenBeg: String.Index
//    private var tokenEnd: String.Index
//
//    private let isStrictMode: Bool
//
//    // Initializer
//    init(sourceString: String, lineno: Int, languageVersion: Int, isStrictMode: Bool = false) {
//        self.sourceString = sourceString
//        self.sourceCursor = sourceString.startIndex
//        self.cursor = sourceString.startIndex
//        self.lineStart = sourceString.startIndex
//        self.tokenBeg = sourceString.startIndex
//        self.tokenEnd = sourceString.startIndex
//
//        self.lineno = lineno
//        self.languageVersion = languageVersion
//        self.isStrictMode = isStrictMode
//    }
//
//    // Static method to check if a string is a keyword
//    static func isKeyword(_ s: String, version: Int, isStrict: Bool) -> Bool {
//        return stringToKeyword(s, version: version, isStrict: isStrict) != .EOF
//    }
//
//    // Static method to convert string to keyword token
//    static func stringToKeyword(_ name: String, version: Int, isStrict: Bool) -> Token {
//        if version < Context.VERSION_ES6 {
//            return stringToKeywordForJS(name)
//        }
//        return stringToKeywordForES(name, isStrict: isStrict)
//    }
//
//    // JavaScript 1.8 and earlier keyword handling
//    private static func stringToKeywordForJS(_ name: String) -> Token {
//        // Implement keyword mapping similar to the Java version
//        // This is a simplified version and should be expanded
//        switch name {
//        case "break": return .BREAK
//        case "case": return .CASE
//        case "continue": return .CONTINUE
//        // Add more cases for other keywords
//        default: return .EOF
//        }
//    }
//
//    // ECMAScript 6 keyword handling
//    private static func stringToKeywordForES(_ name: String, isStrict: Bool) -> Token {
//        // Implement keyword mapping similar to the Java version
//        // This is a simplified version and should be expanded
//        switch name {
//        case "break": return .BREAK
//        case "case": return .CASE
//        case "catch": return .CATCH
//        // Add more cases for other keywords
//        default: return .EOF
//        }
//    }
//
//    // Token retrieval method (partial implementation)
//    func getToken() throws -> Token {
//        // This is a simplified stub and should be fully implemented
//        // Similar to the Java version's getToken method
//        var c: Int
//
//        while true {
//            // Eat whitespace
//            c = try getChar()
//
//            if c == Self.EOF_CHAR {
//                return .EOF
//            }
//
//            // Add more token parsing logic here
//
//            break
//        }
//
//        // Placeholder return
//        return .EOF
//    }
//
//    // Regular expression parsing method
//
//
//    // Utility methods (stubs to be fully implemented)
//    private func addToString(_ c: Int) {
//        if stringBufferTop == stringBuffer.count {
//            stringBuffer.append(contentsOf: [Character](repeating: " ", count: stringBuffer.count))
//        }
//        stringBuffer[stringBufferTop] = Character(UnicodeScalar(c)!)
//        stringBufferTop += 1
//    }
//
//    private func addToString(_ s: String) {
//        for char in s {
//            addToString(Int(char.asciiValue ?? 0))
//        }
//    }
//
//    private func getChar() throws -> Int {
//        // Implement character retrieval logic
//        // This is a simplified stub
//        guard sourceCursor < sourceString.endIndex else {
//            return Self.EOF_CHAR
//        }
//
//        let char = sourceString[sourceCursor]
//        sourceCursor = sourceString.index(after: sourceCursor)
//        return Int(char.asciiValue ?? 0)
//    }
//
//    private func getCharIgnoreLineEnd() throws -> Int {
//        // Implement character retrieval logic ignoring line endings
//        return try getChar()
//    }
//
//    private func ungetCharIgnoreLineEnd(_ c: Int) {
//        // Implement character push-back logic
//        ungetBuffer[ungetCursor] = c
//        ungetCursor += 1
//        sourceCursor = sourceString.index(before: sourceCursor)
//    }
//
//    private func peekChar() -> Int {
//        // Peek at the next character
//        guard sourceCursor < sourceString.endIndex else {
//            return Self.EOF_CHAR
//        }
//        return Int(sourceString[sourceCursor].asciiValue ?? 0)
//    }
//
//    // Helper static methods
//    private static func isAlpha(_ c: Int) -> Bool {
//        guard let char = UnicodeScalar(c) else { return false }
//        let charValue = Character(char)
//        return (charValue >= "A" && charValue <= "Z") || (charValue >= "a" && charValue <= "z")
//    }
//
//    private static func isDigit(_ c: Int) -> Bool {
//        return c >= Character("0").asciiValue! && c <= Character("9").asciiValue!
//    }
//
//    // Placeholder for other utility methods and token parsing logic
//}


extension String {
    #warning("move me somewhere else")
    subscript(i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}

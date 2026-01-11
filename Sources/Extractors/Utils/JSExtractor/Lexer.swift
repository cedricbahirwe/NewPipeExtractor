//
//  Lexer.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 15/12/2024.
//

import Foundation

/**
 * JavaScript lexer that is able to parse JavaScript code and return its
 * tokens.
 *
 * <p>
 * The algorithm for distinguishing between division operators and regex literals
 * was taken from the <a href="https://github.com/rusty-ecma/RESS/">RESS lexer</a>.
 * </p>
 */

//public class Lexer {
//    private class Paren {
//        let funcExpr: Bool
//        let conditional: Bool
//
//        init(funcExpr: Bool, conditional: Bool) {
//            self.funcExpr = funcExpr
//            self.conditional = conditional
//        }
//    }
//
//    private class Brace {
//        let isBlock: Bool
//        let paren: Paren
//
//        init(isBlock: Bool, paren: Paren) {
//            self.isBlock = isBlock
//            self.paren = paren
//        }
//    }
//
//    private class MetaToken {
//        let token: Token
//        let lineno: Int
//
//        init(token: Token, lineno: Int) {
//            self.token = token
//            self.lineno = lineno
//        }
//    }
//
//    private class BraceMetaToken: MetaToken {
//        let brace: Brace
//
//        init(token: Token, lineno: Int, brace: Brace) {
//            super.init(token: token, lineno: lineno)
//            self.brace = brace
//        }
//    }
//
//    private class ParenMetaToken: MetaToken {
//        let paren: Paren
//
//        init(token: Token, lineno: Int, paren: Paren) {
//            super.init(token: token, lineno: lineno)
//            self.paren = paren
//        }
//    }
//
//    /// Parsed token, containing the token and its position in the input string
//    public struct ParsedToken {
//        public let token: Token
//        public let start: Int
//        public let end: Int
//
//        public init(token: Token, start: Int, end: Int) {
//            self.token = token
//            self.start = start
//            self.end = end
//        }
//    }
//
//    /// Tracks the last three tokens for context analysis
//    private class LookBehind {
//        private var list: [MetaToken?] = [nil, nil, nil]
//
//        /// Push a new token into the look-behind list
//        func push(_ t: MetaToken) {
//            var toShift: MetaToken? = t
//            for i in 0..<3 {
//                let tmp = list[i]
//                list[i] = toShift
//                toShift = tmp
//            }
//        }
//
//        /// Get the most recent token
//        func one() -> MetaToken? {
//            return list[0]
//        }
//
//        /// Get the second most recent token
//        func two() -> MetaToken? {
//            return list[1]
//        }
//
//        /// Get the third most recent token
//        func three() -> MetaToken? {
//            return list[2]
//        }
//
//        /// Check if the most recent token matches a given token
//        func oneIs(_ token: Token) -> Bool {
//            return list[0] != nil && list[0]?.token == token
//        }
//
//        /// Check if the second most recent token matches a given token
//        func twoIs(_ token: Token) -> Bool {
//            return list[1] != nil && list[1]?.token == token
//        }
//
//        /// Check if the third most recent token matches a given token
//        func threeIs(_ token: Token) -> Bool {
//            return list[2] != nil && list[2]?.token == token
//        }
//    }
//    private let stream: TokenStream
//    private var lastThree: LookBehind
//    private var braceStack: [Brace]
//    private var parenStack: [Paren]
//
//    /// Create a new JavaScript lexer with the given source code
//    /// - Parameters:
//    ///   - js: JavaScript source code
//    ///   - languageVersion: JavaScript language version (defaulting to default version)
//    public init(js: String, languageVersion: Int = 0) {
//        stream = TokenStream(js, lineno: 0, languageVersion: languageVersion)
//        lastThree = LookBehind()
//        braceStack = []
//        parenStack = []
//    }
//
//    /// Continue parsing and return the next token
//    /// - Returns: Next parsed token
//    /// - Throws: ParsingException if parsing fails
//    public func getNextToken() throws -> ParsedToken {
//        var token = try stream.nextToken()
//
//        // Check for regex start
//        if (token == .div || token == .assignDiv) && isRegexStart() {
//            try stream.readRegExp(token)
//            token = .regexp
//        }
//
//        let parsedToken = ParsedToken(token: token, start: stream.tokenBeg, end: stream.tokenEnd)
//        try keepBooks(parsedToken)
//        return parsedToken
//    }
//
//    /// Check if the parser is balanced (equal amount of open and closed parentheses and braces)
//    public func isBalanced() -> Bool {
//        return braceStack.isEmpty && parenStack.isEmpty
//    }
//
//    /// Evaluate the token for possible regex start and handle bookkeeping
//    private func keepBooks(_ parsedToken: ParsedToken) throws {
//        if parsedToken.token.isPunct {
//            switch parsedToken.token {
//            case .lp:
//                handleOpenParenBooks()
//                return
//            case .lc:
//                handleOpenBraceBooks()
//                return
//            case .rp:
//                try handleCloseParenBooks(parsedToken.start)
//                return
//            case .rc:
//                try handleCloseBraceBooks(parsedToken.start)
//                return
//            default:
//                break
//            }
//        }
//
//        if parsedToken.token != .comment {
//            lastThree.push(MetaToken(token: parsedToken.token, lineno: stream.lineno))
//        }
//    }
//
//    /// Handle bookkeeping when finding an opening parenthesis
//    private func handleOpenParenBooks() {
//        var funcExpr = false
//        if lastThree.oneIs(.function) {
//            funcExpr = lastThree.two() != nil && checkForExpression(lastThree.two()!.token)
//        } else if lastThree.twoIs(.function) {
//            funcExpr = lastThree.three() != nil && checkForExpression(lastThree.three()!.token)
//        }
//
//        let conditional = lastThree.one() != nil
//            && lastThree.one()!.token.isConditional()
//
//        let paren = Paren(funcExpr: funcExpr, conditional: conditional)
//        parenStack.append(paren)
//        lastThree.push(ParenMetaToken(token: .lp, lineno: stream.lineno, paren: paren))
//    }
//
//    /// Handle bookkeeping when finding an opening brace
//    private func handleOpenBraceBooks() {
//        var isBlock = true
//        if let lastToken = lastThree.one() {
//            switch lastToken.token {
//            case .lp, .lc, .case:
//                isBlock = false
//            case .colon:
//                isBlock = !braceStack.isEmpty && braceStack.last!.isBlock
//            case .return, .yield, .yieldStar:
//                isBlock = lastThree.two() != nil && lastThree.two()!.lineno != stream.lineno
//            default:
//                isBlock = !lastToken.token.isOp
//            }
//        }
//
//        var paren: Paren?
//        if let lastToken = lastThree.one() as? ParenMetaToken,
//           lastToken.token == .rp {
//            paren = lastToken.paren
//        }
//
//        let brace = Brace(isBlock: isBlock, paren: paren)
//        braceStack.append(brace)
//        lastThree.push(BraceMetaToken(token: .lc, lineno: stream.lineno, brace: brace))
//    }
//
//    /// Handle bookkeeping when finding a closing parenthesis
//    private func handleCloseParenBooks(_ start: Int) throws {
//        guard !parenStack.isEmpty else {
//            throw ParsingException(message: "unmatched closing paren at \(start)")
//        }
//        lastThree.push(ParenMetaToken(token: .rp, lineno: stream.lineno, paren: parenStack.removeLast()))
//    }
//
//    /// Handle bookkeeping when finding a closing brace
//    private func handleCloseBraceBooks(_ start: Int) throws {
//        guard !braceStack.isEmpty else {
//            throw ParsingException(message: "unmatched closing brace at \(start)")
//        }
//        lastThree.push(BraceMetaToken(token: .rc, lineno: stream.lineno, brace: braceStack.removeLast()))
//    }
//
//    /// Check if a token indicates an expression
//    private func checkForExpression(_ token: Token) -> Bool {
//        return token.isOp || token == .return || token == .case
//    }
//
//    /// Detect if the `/` is the beginning of a regex or is division
//    private func isRegexStart() -> Bool {
//        guard let lastToken = lastThree.one() else {
//            return true
//        }
//
//        if lastToken.token.isKeyw {
//            return lastToken.token != .this
//        } else if lastToken.token == .rp,
//                  let parenToken = lastThree.one() as? ParenMetaToken {
//            return parenToken.paren.conditional
//        } else if lastToken.token == .rc,
//                  let braceToken = lastThree.one() as? BraceMetaToken {
//            if braceToken.brace.isBlock {
//                if let paren = braceToken.brace.paren {
//                    return !paren.funcExpr
//                } else {
//                    return true
//                }
//            } else {
//                return false
//            }
//        } else if lastToken.token.isPunct {
//            return lastToken.token != .rb
//        } else {
//            return false
//        }
//    }
//}
func == (lhs: Character, rhs: UInt8) -> Bool {
    if let scalarValue = lhs.asciiValue {
        return scalarValue == rhs
    }
    return false
}

func <= (lhs: Character, rhs: UInt8) -> Bool {
    if let scalarValue = lhs.asciiValue {
        return scalarValue <= rhs
    }
    return false
}

func == (lhs: UInt8, rhs: Character) -> Bool {
    if let scalarValue = rhs.asciiValue {
        return lhs == scalarValue
    }
    return false
}

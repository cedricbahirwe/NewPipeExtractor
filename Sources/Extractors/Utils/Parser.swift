//
//  Parser.swift
//  NewPipe
//
//  Created by Cédric Bahirwe on 15/11/2024.
//

import Foundation

//enum ParsingException: Error {
//    case regexException(String)
//}

public class Parser {

    private init() {}

    class RegexException: ParsingException, @unchecked Sendable {
        convenience init(message: String) {
            self.init(message)
        }
    }

    public static func matchGroup1(pattern: String, input: String) throws -> String {
        return try matchGroup(pattern: pattern, input: input, group: 1)
    }

    public static func matchGroup1(pattern: NSRegularExpression, input: String) throws -> String {
        return try matchGroup(pattern: pattern, input: input, group: 1)
    }

    public static func matchGroup(pattern: String, input: String, group: Int) throws -> String {
        let regex = try NSRegularExpression(pattern: pattern)
        return try matchGroup(pattern: regex, input: input, group: group)
    }

    public static func matchGroup(pattern: NSRegularExpression, input: String, group: Int) throws -> String {
        let range = NSRange(location: 0, length: input.utf16.count)
        if let match = pattern.firstMatch(in: input, options: [], range: range) {
            let groupRange = match.range(at: group)
            if groupRange.location != NSNotFound {
                return (input as NSString).substring(with: groupRange)
            } else {
                throw RegexException(message: "Group \(group) not found")
            }
        } else {
            if input.count > 1024 {
                throw RegexException(message: "Failed to find pattern \"\(pattern.pattern)\"")
            } else {
                throw RegexException(message: "Failed to find pattern \"\(pattern.pattern)\" inside of \"\(input)\"")
            }
        }
    }

    public static func matchGroup1MultiplePatterns(patterns: [NSRegularExpression], input: String) throws -> String {
        let matcher = try matchMultiplePatterns(patterns: patterns, input: input)
        return (input as NSString).substring(with: matcher.range(at: 1))
    }

    public static func matchMultiplePatterns(patterns: [NSRegularExpression], input: String) throws -> NSTextCheckingResult {
        var exception: RegexException?
        for pattern in patterns {
            let range = NSRange(location: 0, length: input.utf16.count)
            if let matcher = pattern.firstMatch(in: input, options: [], range: range) {
                return matcher
            } else if exception == nil {
                if input.count > 1024 {
                    exception = RegexException(message: "Failed to find pattern \"\(pattern.pattern)\"")
                } else {
                    exception = RegexException(message: "Failed to find pattern \"\(pattern.pattern)\" inside of \"\(input)\"")
                }
            }
        }

        if let exception = exception {
            throw exception
        } else {
            throw RegexException(message: "Empty patterns array passed to matchMultiplePatterns")
        }
    }

    public static func isMatch(pattern: String, input: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: pattern)
        return regex.firstMatch(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count)) != nil
    }

    public static func isMatch(pattern: NSRegularExpression, input: String) -> Bool {
        return pattern.firstMatch(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count)) != nil
    }

    public static func compatParseMap(input: String) -> [String: String] {
        return input.split(separator: "&")
            .map { $0.split(separator: "=") }
            .filter { $0.count > 1 }
            .reduce(into: [String: String]()) { result, splitArg in
                let key = String(splitArg[0])
                let value = Utils.decodeUrlUtf8(String(splitArg[1]))
                result[key] = value
            }
    }
}

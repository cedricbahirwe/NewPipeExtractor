//
//  Utils.swift
//  NewPipe
//
//  Created by Cédric Bahirwe on 15/11/2024.
//

import Foundation

public class Utils {
    public static let HTTP: String = "http://"
    public static let HTTPSL: String = "https://"
    private static let M_PATTERN: NSRegularExpression = try! NSRegularExpression(pattern: "(https?)?://m\\.", options: [])
    private static let WWW_PATTERN: NSRegularExpression = try! NSRegularExpression(pattern: "(https?)?://www\\.", options: [])


    /**
     Decodes a URL using the UTF-8 character set.
     - Parameter url: The URL to be decoded.
     - Returns: The decoded URL as a string.
     */
    static func decodeUrlUtf8(_ url: String) -> String {
        return url.removingPercentEncoding ?? url
    }

    static func getBaseUrl(_ url: String) throws(ParsingException) -> String {
        do {
            let uri = try stringToURL(url)  // using the previous stringToURL function
            guard let scheme = uri.scheme,
                  let host = uri.host else {
                throw ParsingException.malformedURL(url)
            }
            return "\(scheme)://\(host)"
        } catch let error as URLErrorCustom {
            // Handle "unknown protocol" case
            let message = error.localizedDescription
            guard message.starts(with: "no protocol: ") else {
                throw ParsingException.malformedURL(url, cause: error)
            }

            // Return just the protocol part (similar to Java) (e.g. vnd.youtube)
            let prefixLength = "no protocol: ".count
            let startIndex = message.index(message.startIndex, offsetBy: prefixLength)
            return String(message[startIndex...])
        } catch {
            throw ParsingException.malformedURL(url, cause: error)
        }
    }

    /**
     If the provided url is a Google search redirect, then the actual url is extracted from the
     `url=` query value and returned, otherwise the original url is returned.

     - Parameter url: The URL which can possibly be a Google search redirect.
     - Returns: A URL with no Google search redirects.
     */
    public static func followGoogleRedirectIfNeeded(_ url: String) -> String {
        do {
            // If the url is a redirect from a Google search, extract the actual URL
            let decodedUrl = try stringToURL(url)
            if decodedUrl.host?.contains("google") == true && decodedUrl.path == "/url" {
                let extractedUrl = try Parser.matchGroup1(pattern: "&url=([^&]+)(?:&|$)", input: url)
                return decodeUrlUtf8(extractedUrl)
            }
        } catch {}

        // URL is not a Google search redirect
        return url
    }

    public static func isBlank(_ string: String?) -> Bool {
        return string?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
    }


    /// Checks if a collection is `nil` or empty.
    ///
    /// - Parameter collection: The collection to check.
    /// - Returns: `true` if the collection is `nil` or empty; otherwise, `false`.
    public static func isNullOrEmpty<T: Collection>(_ collection: T?) -> Bool {
        return collection?.isEmpty ?? true
    }

    public enum URLErrorCustom: Error {
        case malformedURL(_ url: String)
    }

    public static func stringToURL(_ url: String) throws(URLErrorCustom) -> URL {
        if let validURL = URL(string: url) {
            return validURL
        }

        // Try prepending https:// if missing scheme
        if !url.contains("://"), let httpsURL = URL(string: "https://\(url)") {
            return httpsURL
        }

        // Otherwise, throw an error
        throw URLErrorCustom.malformedURL(url)
    }

    public func isHTTP(_ url: URL) -> Bool {
        guard let scheme = url.scheme?.lowercased(),
              scheme == "http" || scheme == "https" else {
            return false
        }

        let port = url.port
        let defaultPort: Int
        if scheme == "http" {
            defaultPort = 80
        } else { // https
            defaultPort = 443
        }

        let usesDefaultPort = port == defaultPort
        let setsNoPort = port == nil

        return usesDefaultPort || setsNoPort
    }

    /// Returns the value of a URL query parameter by name.
    /// If a query parameter appears multiple times, only the first occurrence is returned.
    /// - Parameters:
    ///   - url: The URL to search.
    ///   - parameterName: The name of the query parameter to retrieve.
    /// - Returns: The value of the query parameter, or `nil` if not found.
    public static func getQueryValue(from url: URL, parameterName: String) -> String? {
        guard let query = url.query else { return nil }

        for param in query.split(separator: "&") {
            let parts = param.split(separator: "=", maxSplits: 1)
            let key = decodeUrlUtf8(String(parts[0]))

            if key == parameterName {
                if parts.count > 1 {
                    return decodeUrlUtf8(String(parts[1]))
                } else {
                    return nil
                }
            }
        }

        return nil
    }


    /// Removes all non-digit characters from a string.
    ///
    /// Examples:
    /// - `"1 234 567 views"` → `"1234567"`
    /// - `"$31,133.124"` → `"31133124"`
    ///
    /// - Parameter toRemove: The string from which non-digit characters should be removed.
    /// - Returns: A string that contains only digits.
    static func removeNonDigitCharacters(_ toRemove: String) -> String {
        return toRemove.replacingOccurrences(of: "\\D+", with: "", options: .regularExpression)
    }

    /// Errors thrown by regex parser functions.
    enum RegexError: Error {
        case noMatch(group: Int)
    }

    /// Tries multiple string regular expressions on an input and returns the first match of group 0 (full match).
    /// - Parameters:
    ///   - input: The input string to search.
    ///   - regexStrings: An array of regex strings to try.
    /// - Throws: `RegexError.noMatch` if none of the regexes matched the input.
    /// - Returns: The matched string from group 0.
    public static func getStringResultFromRegexArray(
        _ input: String,
        regexStrings: [String]
    ) throws -> String {
        return try getStringResultFromRegexArray(input, regexStrings: regexStrings, group: 0)
    }

    /// Tries multiple regular expressions on an input and returns the first match of group 0 (full match).
    /// - Parameters:
    ///   - input: The input string to search.
    ///   - regexes: An array of `NSRegularExpression` objects to try.
    /// - Throws: `RegexError.noMatch` if none of the regexes matched the input.
    /// - Returns: The matched string from group 0.
    public static func getStringResultFromRegexArray(
        _ input: String,
        regexes: [NSRegularExpression]
    ) throws -> String {
        return try getStringResultFromRegexArray(input, regexes: regexes, group: 0)
    }


    /// Tries multiple string regular expressions on an input and returns the first match of a specific capture group.
    /// - Parameters:
    ///   - input: The input string to search.
    ///   - regexStrings: An array of regex strings to try.
    ///   - group: The capture group index to extract.
    /// - Throws: `RegexError.noMatch` if none of the regexes matched the input on the specified group.
    /// - Returns: The matched string from the specified capture group.
    public static func getStringResultFromRegexArray(
        _ input: String,
        regexStrings: [String],
        group: Int
    ) throws -> String {
        // Filter out nil values and compile to NSRegularExpression
        let regexes: [NSRegularExpression] = try regexStrings.compactMap { regexString in
            return try NSRegularExpression(pattern: regexString, options: [])
        }

        // Call the previous function that works with NSRegularExpression array
        return try getStringResultFromRegexArray(input, regexes: regexes, group: group)
    }

    /// Tries multiple regular expressions on an input and returns the first match of a specific capture group.
    /// - Parameters:
    ///   - input: The input string to search.
    ///   - regexes: An array of `NSRegularExpression` objects to try.
    ///   - group: The capture group index to extract.
    /// - Throws: `RegexError.noMatch` if none of the regexes matched the input on the specified group.
    /// - Returns: The matched string from the specified capture group.
    public static func getStringResultFromRegexArray(
        _ input: String,
        regexes: [NSRegularExpression],
        group: Int
    ) throws -> String {
        for regex in regexes {
            let range = NSRange(input.startIndex..<input.endIndex, in: input)
            if let match = regex.firstMatch(in: input, options: [], range: range) {
                // Ensure the group index is valid
                if group < match.numberOfRanges {
                    let matchRange = match.range(at: group)
                    if let swiftRange = Range(matchRange, in: input) {
                        return String(input[swiftRange])
                    }
                }
            }
        }

        throw Parser.RegexException("No regex matched the input on group \(group)")
    }
}

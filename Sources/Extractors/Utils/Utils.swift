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

    static func getBaseUrl(_ url: String) throws -> String {
        guard let uri = stringToURL(url) else {
            throw ParsingException("Malformed url: \(url)")
        }

        if let scheme = uri.scheme, let host = uri.host {
            return "\(scheme)://\(host)"
        }

        // Handle unknown protocol case (e.g., "vnd.youtube")
        if uri.absoluteString.starts(with: "unknown protocol: ") {
            return String(uri.absoluteString.dropFirst("unknown protocol: ".count))
        }

        throw ParsingException("Malformed url: \(url)")
    }

    /**
     If the provided url is a Google search redirect, then the actual url is extracted from the
     `url=` query value and returned, otherwise the original url is returned.

     - Parameter url: The URL which can possibly be a Google search redirect.
     - Returns: A URL with no Google search redirects.
     */
    public static func followGoogleRedirectIfNeeded(_ url: String) throws -> String {
        // If the url is a redirect from a Google search, extract the actual URL
        if let decodedUrl = stringToURL(url) {
            if decodedUrl.host?.contains("google") == true && decodedUrl.path == "/url" {
                let extractedUrl = try Parser.matchGroup1(pattern: "&url=([^&]+)(?:&|$)", input: url)
                return decodeUrlUtf8(extractedUrl)
            }
        }

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

    private static func stringToURL(_ url: String) -> URL? {
        return URL(string: url)
    }
}

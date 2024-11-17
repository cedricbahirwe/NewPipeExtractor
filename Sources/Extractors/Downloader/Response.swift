//
//  Response.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 16/11/2024.
//

import Foundation

public struct Response {
    public let responseCode: Int
    public let responseMessage: String
    public let responseHeaders: [String: [String]]
    public let responseBody: String

    /// Used for detecting a possible redirection, limited to the latest one.
    /// - Returns: The latest URL known right before this response object was created.
    public let latestUrl: String

    public init(responseCode: Int,
                responseMessage: String,
                responseHeaders: [String: [String]]? = nil,
                responseBody: String? = nil,
                latestUrl: String? = nil) {
        self.responseCode = responseCode
        self.responseMessage = responseMessage
        self.responseHeaders = responseHeaders ?? [:]
        self.responseBody = responseBody ?? ""
        self.latestUrl = latestUrl ?? ""
    }

    // MARK: - Utils

    /// For easy access to some header value that (usually) doesn't repeat itself.
    ///
    /// For getting all the values associated to the header, use `responseHeaders()` (e.g., `Set-Cookie`).
    /// - Parameter name: The name of the header.
    /// - Returns: The first value assigned to this header, or `nil` if not found.
    public func getHeader(_ name: String) -> String? {
        for (key, values) in responseHeaders {
            if key.lowercased() == name.lowercased(), !values.isEmpty {
                return values.first
            }
        }
        return nil
    }
}

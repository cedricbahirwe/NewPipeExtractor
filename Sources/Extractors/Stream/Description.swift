//
//  Description.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 17/11/2024.
//


import Foundation

/// Represents a description with a type indicating its format.
public struct Description: Codable, Equatable, Hashable, Sendable {

    // MARK: - Static Constants

    /// Description type: HTML.
    static let HTML = 1

    /// Description type: Markdown.
    static let MARKDOWN = 2

    /// Description type: Plain text.
    static let PLAIN_TEXT = 3

    /// An empty description instance.
    static let EMPTY = Description(content: "", type: PLAIN_TEXT)

    // MARK: - Properties

    /// The content of the description.
    public let content: String

    /// The type of the description (HTML, Markdown, or Plain Text).
    public let type: Int

    // MARK: - Initializer

    /// Initializes a description with the given content and type.
    ///
    /// - Parameters:
    ///   - content: The description content. Defaults to an empty string if `nil`.
    ///   - type: The type of the description (e.g., `HTML`, `MARKDOWN`, or `PLAIN_TEXT`).
    public  init(content: String? = nil, type: Int) {
        self.content = content ?? ""
        self.type = type
    }

    // MARK: - Equatable

    /// Checks if two `Description` instances are equal.
    public static func == (lhs: Description, rhs: Description) -> Bool {
        return lhs.type == rhs.type && lhs.content == rhs.content
    }

    // MARK: - Hashable

    /// Computes the hash value for the description.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(content)
        hasher.combine(type)
    }
}

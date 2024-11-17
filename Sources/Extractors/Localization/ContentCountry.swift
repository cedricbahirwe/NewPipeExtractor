//
//  ContentCountry.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 16/11/2024.
//

import Foundation

/// Represents a country that should be used when fetching content.
///
/// YouTube, for example, gives different results in their feed depending on which country is selected.
public struct ContentCountry: Equatable, Hashable, CustomStringConvertible, Sendable {
    public static let DEFAULT = ContentCountry(Localization.DEFAULT.getCountryCode())

    private let countryCode: String

    /// Creates a list of `ContentCountry` objects from a list of country codes.
    /// - Parameter countryCodeList: A list of country codes.
    /// - Returns: An array of `ContentCountry` instances.
    public static func listFrom(_ countryCodeList: String...) -> [ContentCountry] {
        return countryCodeList.map { ContentCountry($0) }
    }

    public init(_ countryCode: String) {
        self.countryCode = countryCode
    }

    public func getCountryCode() -> String {
        return countryCode
    }

    public var description: String {
        return getCountryCode()
    }

    public static func == (lhs: ContentCountry, rhs: ContentCountry) -> Bool {
        return lhs.countryCode == rhs.countryCode
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(countryCode)
    }
}

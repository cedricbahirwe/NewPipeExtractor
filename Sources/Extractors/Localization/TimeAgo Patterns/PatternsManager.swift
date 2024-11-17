//
//  PatternsManager.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 17/11/2024.
//

import Foundation

/// A manager class for retrieving `PatternsHolder` instances based on localization.
public enum PatternsManager: Sendable {

    /// A registry mapping localization codes to their respective `PatternsHolder` instances.
    nonisolated(unsafe) private static var patternsRegistry: [String: PatternsHolder.Type] = [:]

    /// Registers a `PatternsHolder` type for a given localization code.
    ///
    /// - Parameters:
    ///   - code: The localization code (e.g., "en", "en_US").
    ///   - holderType: The `PatternsHolder` type to register.
    static func registerPatterns(for code: String, holderType: PatternsHolder.Type) {
        patternsRegistry[code] = holderType
    }

    /// Retrieves the `PatternsHolder` for the given language and country codes.
    ///
    /// - Parameters:
    ///   - languageCode: The language code (e.g., "en").
    ///   - countryCode: The optional country code (e.g., "US").
    /// - Returns: The `PatternsHolder` instance, or `nil` if not found.
    public static func getPatterns(languageCode: String, countryCode: String?) -> PatternsHolder? {
        let targetLocalizationCode = languageCode + (countryCode?.isEmpty == false ? "_\(countryCode!)" : "")

        guard let holderType = patternsRegistry[targetLocalizationCode] else {
            print("Localization not supported for \(targetLocalizationCode)")
            return nil
        }

        // Call the required initializer to create an instance
        return holderType.init(
            wordSeparator: " ",
            seconds: ["second", "sec"],
            minutes: ["minute", "min"],
            hours: ["hour", "hr"],
            days: ["day"],
            weeks: ["week"],
            months: ["month"],
            years: ["year"]
        )
    }
}

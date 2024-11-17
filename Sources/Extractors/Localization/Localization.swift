//
//  Localization.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 16/11/2024.
//

import Foundation

public struct Localization: Hashable, CustomStringConvertible, Sendable {
    public static let DEFAULT = Localization(languageCode: "en", countryCode: "GB")

    private let languageCode: String
    private let countryCode: String?

    /**
     * @param localizationCodeList a list of localization code, formatted like {@link
     *                             #getLocalizationCode()}
     * @throws IllegalArgumentException If any of the localizationCodeList is formatted incorrectly
     * @return list of Localization objects
     */
    public static func listFrom(_ localizationCodeList: String...) throws -> [Localization] {
        try localizationCodeList.map { localizationCode in
            guard let localization = fromLocalizationCode(localizationCode) else {
                throw IllegalArgumentException("Not a localization code: \(localizationCode)")
            }
            return localization
        }
    }

    /**
     * @param localizationCode a localization code, formatted like {@link #getLocalizationCode()}
     * @return A Localization, if the code was valid.
     */
    public static func fromLocalizationCode(_ localizationCode: String) -> Localization? {
        let locale = Locale(identifier: localizationCode)
        let language = locale.languageCode
        let country = locale.regionCode
        guard let language = language else { return nil }
        return Localization(languageCode: language, countryCode: country)
    }

    public init(languageCode: String, countryCode: String? = nil) {
        self.languageCode = languageCode
        self.countryCode = countryCode
    }

    public func getLanguageCode() -> String {
        return languageCode
    }

    public func getCountryCode() -> String {
        return countryCode ?? ""
    }

    public static func fromLocale(_ locale: Locale) -> Localization {
        return Localization(languageCode: locale.languageCode ?? "", countryCode: locale.regionCode)
    }

    /**
     * Return a formatted string in the form of: {@code language-Country}, or
     * just {@code language} if country is {@code null}.
     *
     * @return A correctly formatted localizationCode for this localization.
     */
    public func getLocalizationCode() -> String {
        return countryCode == nil ? languageCode : "\(languageCode)-\(countryCode!)"
    }

    public var description: String {
        return "Localization[\(getLocalizationCode())]"
    }

    public static func ==(lhs: Localization, rhs: Localization) -> Bool {
        return lhs.languageCode == rhs.languageCode && lhs.countryCode == rhs.countryCode
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(languageCode)
        hasher.combine(countryCode)
    }

    /**
     * Converts a three letter language code (ISO 639-2/T) to a Locale
     * because limits of Java Locale class.
     *
     * @param code a three letter language code
     * @return the Locale corresponding
     */
    public static func getLocaleFromThreeLetterCode(_ code: String) throws -> Locale {
        let languages = Locale.availableIdentifiers
        var localeMap: [String: Locale] = [:]
        for language in languages {
            let locale = Locale(identifier: language)
            localeMap[locale.languageCode ?? ""] = locale
        }
        if let locale = localeMap[code] {
            return locale
        } else {
            throw ParsingException("Could not get Locale from this three letter language code: \(code)")
        }
    }
}


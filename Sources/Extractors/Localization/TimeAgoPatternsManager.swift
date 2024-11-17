//
//  TimeAgoPatternsManager.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 17/11/2024.
//

import Foundation

public enum TimeAgoPatternsManager {

    private static func getPatternsFor(localization: Localization) -> PatternsHolder? {
        return PatternsManager.getPatterns(
            languageCode: localization.getLanguageCode(),
            countryCode: localization.getCountryCode()
        )
    }

    public static func getTimeAgoParserFor(_ localization: Localization) -> TimeAgoParser? {
        guard let holder = getPatternsFor(localization: localization) else { return  nil }

        return TimeAgoParser(patternsHolder: holder)
    }
}

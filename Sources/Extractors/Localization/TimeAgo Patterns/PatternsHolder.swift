//
//  PatternsHolder.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 17/11/2024.
//

import Foundation

/// Abstract base class for holding patterns to parse time-related strings.
public class PatternsHolder {

    // MARK: - Properties

    /// The word separator for parsing patterns.
    private let wordSeparator: String

    /// Collections of strings representing different time units.
    private let seconds: [String]
    private let minutes: [String]
    private let hours: [String]
    private let days: [String]
    private let weeks: [String]
    private let months: [String]
    private let years: [String]

    /// Special cases for parsing time-related strings.
    private var specialCases: [ChronoUnit: [String: Int]] = [:]

    // MARK: - Initializers

    /// Initializes the `PatternsHolder` with arraay of patterns.
    ///
    /// - Parameters:
    ///   - wordSeparator: The word separator for parsing patterns.
    ///   - seconds: Patterns representing seconds.
    ///   - minutes: Patterns representing minutes.
    ///   - hours: Patterns representing hours.
    ///   - days: Patterns representing days.
    ///   - weeks: Patterns representing weeks.
    ///   - months: Patterns representing months.
    ///   - years: Patterns representing years.
    public required init(wordSeparator: String,
                seconds: [String],
                minutes: [String],
                hours: [String],
                days: [String],
                weeks: [String],
                months: [String],
                years: [String]) {
        self.wordSeparator = wordSeparator
        self.seconds = seconds
        self.minutes = minutes
        self.hours = hours
        self.days = days
        self.weeks = weeks
        self.months = months
        self.years = years
    }

    // MARK: - Methods

    /// Returns the word separator.
    public func getWordSeparator() -> String {
        return wordSeparator
    }

    /// Returns the collection of second patterns.
    public func getSeconds() -> [String] {
        return seconds
    }

    /// Returns the collection of minute patterns.
    public func getMinutes() -> [String] {
        return minutes
    }

    /// Returns the collection of hour patterns.
    public func getHours() -> [String] {
        return hours
    }

    /// Returns the collection of day patterns.
    public func getDays() -> [String] {
        return days
    }

    /// Returns the collection of week patterns.
    public func getWeeks() -> [String] {
        return weeks
    }

    /// Returns the collection of month patterns.
    public func getMonths() -> [String] {
        return months
    }

    /// Returns the collection of year patterns.
    public func getYears() -> [String] {
        return years
    }

    /// Returns the map of special cases.
    public func getSpecialCases() -> [ChronoUnit: [String: Int]] {
        return specialCases
    }

    /// Adds a special case to the `specialCases` map.
    ///
    /// - Parameters:
    ///   - unit: The `ChronoUnit` associated with the special case.
    ///   - caseText: The text representation of the special case.
    ///   - caseAmount: The value associated with the special case.
    public func putSpecialCase(unit: ChronoUnit, caseText: String, caseAmount: Int) {
        if specialCases[unit] == nil {
            specialCases[unit] = [:]
        }
        specialCases[unit]?[caseText] = caseAmount
    }

    /// Converts the time unit patterns to a map.
    ///
    /// - Returns: A map of `ChronoUnit` to its associated patterns.
    public func asMap() -> [ChronoUnit: [String]] {
        return [
            .seconds: seconds,
            .minutes: minutes,
            .hours: hours,
            .days: days,
            .weeks: weeks,
            .months: months,
            .years: years
        ]
    }
}

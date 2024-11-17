//
//  TimeAgoParser.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 17/11/2024.
//


import Foundation

/// A helper class for parsing durations (e.g., "23 seconds") and upload dates (e.g., "2 days ago").
public class TimeAgoParser {

    private static let durationPattern = try! NSRegularExpression(pattern: "(?:(\\d+) )?([A-Za-z]+)")
    
    private let patternsHolder: PatternsHolder
    private let now: Date
    
    /// Creates a helper to parse upload dates in the format '2 days ago'.
    ///
    /// Instantiate a new `TimeAgoParser` every time you extract a new batch of items.
    ///
    /// - Parameter patternsHolder: An object that holds the "time ago" patterns, special cases, and the language word separator.
    public init(patternsHolder: PatternsHolder) {
        self.patternsHolder = patternsHolder
        self.now = Date()
    }
    
    /// Parses a textual date in the format '2 days ago' into a `DateWrapper` object.
    ///
    /// - Parameter textualDate: The original date as provided by the streaming service.
    /// - Throws: A `ParsingException` if the time unit cannot be recognized.
    /// - Returns: The parsed time as a `DateWrapper` (may be approximated).
    public func parse(_ textualDate: String) throws -> DateWrapper {
        for (chronoUnit, specialCases) in patternsHolder.getSpecialCases() {
            for (caseText, caseAmount) in specialCases {
                if textualDateMatches(textualDate, caseText) {
                    return getResultFor(caseAmount, chronoUnit: chronoUnit)
                }
            }
        }
        
        let amount = parseTimeAgoAmount(textualDate)
        let chronoUnit = try parseChronoUnit(textualDate)
        return getResultFor(amount, chronoUnit: chronoUnit)
    }
    
    /// Parses a textual duration into a duration in seconds.
    ///
    /// - Parameter textualDuration: The textual duration to parse.
    /// - Throws: A `ParsingException` if the textual duration cannot be parsed.
    /// - Returns: The parsed duration in seconds.
    public func parseDuration(_ textualDuration: String) throws -> TimeInterval {
        let matches = Self.durationPattern.matches(in: textualDuration, options: [], range: NSRange(textualDuration.startIndex..., in: textualDuration))
        
        let results: [TimeInterval] = matches.compactMap { match in
            let range1 = Range(match.range(at: 1), in: textualDuration)
            let range2 = Range(match.range(at: 2), in: textualDuration)
            
            let digits = range1.flatMap { Int(textualDuration[$0]) } ?? 1
            let word = range2.map { String(textualDuration[$0]) } ?? ""
            
            guard let unit = try? parseChronoUnit(word) else { return nil }
            return TimeInterval(digits) * unit.durationInSeconds
        }
        
        guard !results.isEmpty else {
            throw ParsingException("Could not parse duration \"\(textualDuration)\"")
        }
        
        return results.reduce(0, +)
    }
    
    // MARK: - Private Helpers
    
    private func parseTimeAgoAmount(_ textualDate: String) -> Int {
        let digits = textualDate.filter { $0.isNumber }
        return Int(digits) ?? 1
    }
    
    private func parseChronoUnit(_ textualDate: String) throws -> ChronoUnit {
        for (chronoUnit, phrases) in patternsHolder.asMap() {
            if phrases.contains(where: { textualDateMatches(textualDate, $0) }) {
                return chronoUnit
            }
        }
        throw ParsingException("Unable to parse the date: \(textualDate)")
    }
    
    private func textualDateMatches(_ textualDate: String, _ agoPhrase: String) -> Bool {
        if textualDate.caseInsensitiveCompare(agoPhrase) == .orderedSame {
            return true
        }
        
        let wordSeparator = patternsHolder.getWordSeparator()
        if wordSeparator.isEmpty {
            return textualDate.localizedCaseInsensitiveContains(agoPhrase)
        }
        
        let escapedPhrase = NSRegularExpression.escapedPattern(for: agoPhrase.lowercased())
        let escapedSeparator = wordSeparator == " " ? "\\s" : NSRegularExpression.escapedPattern(for: wordSeparator)
        let pattern = "(^|\(escapedSeparator))\(escapedPhrase)($|\(escapedSeparator))"
        
        return textualDate.range(of: pattern, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    private func getResultFor(_ timeAgoAmount: Int, chronoUnit: ChronoUnit) -> DateWrapper {
        var date = now
        var isApproximation = false
        
        switch chronoUnit {
        case .seconds, .minutes, .hours:
            date = Calendar.current.date(byAdding: chronoUnit.calendarComponent, value: -timeAgoAmount, to: date)!
        case .days, .weeks, .months:
            date = Calendar.current.date(byAdding: chronoUnit.calendarComponent, value: -timeAgoAmount, to: date)!
            isApproximation = true
        case .years:
            date = Calendar.current.date(byAdding: .year, value: -timeAgoAmount, to: date)!
            date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
            isApproximation = true
        }
        
        if isApproximation {
            date = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
        }
        
        return DateWrapper(date: date, isApproximation: isApproximation)
    }
}

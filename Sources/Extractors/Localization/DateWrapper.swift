//
//  DateWrapper.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 16/11/2024.
//

import Foundation

/// A wrapper class that provides a field to describe if the date/time is precise or just an approximation.
public class DateWrapper: Codable {
    /// The wrapped date/time as an `ISO8601DateFormatter` compatible value.
    private let offsetDateTime: Date
    /// Indicates if the date/time is an approximation.
    private let isApproximation: Bool

    // MARK: - Initializers

    /// Initializes the `DateWrapper` with a `Date` value.
    /// - Parameter date: The date value to wrap.
    /// - Parameter isApproximation: Whether the date is an approximation. Defaults to `false`.
    public init(date: Date, isApproximation: Bool = false) {
        self.offsetDateTime = date
        self.isApproximation = isApproximation
    }

    /// Initializes the `DateWrapper` with a `Calendar` instance.
    /// - Parameters:
    ///   - calendar: The calendar instance.
    ///   - isApproximation: Whether the date is an approximation. Defaults to `false`.
    /// - Note: This initializer is marked as deprecated and will be removed in the future.
    @available(*, deprecated, message: "Use init(date:isApproximation:) instead.")
    public convenience init(calendar: Calendar, isApproximation: Bool = false) {
        let date = calendar.date(from: DateComponents()) ?? Date()
        self.init(date: date, isApproximation: isApproximation)
    }

    // MARK: - Public Methods

    /// Returns the wrapped date/time as a `Date`.
    /// - Returns: The wrapped date/time.
    public func date() -> Date {
        return offsetDateTime
    }

    /// Indicates whether the date is an approximation.
    /// - Returns: `true` if the date is an approximation; otherwise, `false`.
    public func isDateApproximation() -> Bool {
        return isApproximation
    }

    /// Converts the date to a string representation in ISO 8601 format.
    /// - Returns: A string representation of the date in ISO 8601 format.
    public func iso8601String() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.string(from: offsetDateTime)
    }
}

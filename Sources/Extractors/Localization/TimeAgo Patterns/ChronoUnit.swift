//
//  ChronoUnit.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 17/11/2024.
//

import Foundation

public enum ChronoUnit {
    case seconds, minutes, hours, days, weeks, months, years

    public var calendarComponent: Calendar.Component {
        switch self {
        case .seconds: return .second
        case .minutes: return .minute
        case .hours: return .hour
        case .days: return .day
        case .weeks: return .weekOfYear
        case .months: return .month
        case .years: return .year
        }
    }

    public var durationInSeconds: TimeInterval {
        switch self {
        case .seconds: return 1
        case .minutes: return 60
        case .hours: return 3600
        case .days: return 86400
        case .weeks: return 604800
        case .months: return 2592000 // Approximation
        case .years: return 31536000 // Approximation
        }
    }
}

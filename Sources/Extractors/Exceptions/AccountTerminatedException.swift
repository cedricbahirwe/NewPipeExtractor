//
//  AccountTerminatedException.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 20/11/2024.
//

import Foundation

public class AccountTerminatedException: ContentNotAvailableException, @unchecked Sendable {
    public enum Reason {
        case unknown
        case violation
    }

    private var reason: Reason = .unknown

    public init(_ message: String, reason: Reason) {
        self.reason = reason
        super.init(message)
    }

    // The reason for the violation. There should also be more info in the exception's message.
    public func getReason() -> Reason {
        return reason
    }
}

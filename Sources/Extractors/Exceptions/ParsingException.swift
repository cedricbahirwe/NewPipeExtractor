//
//  ParsingException.swift
//  NewPipe
//
//  Created by Cédric Bahirwe on 15/11/2024.
//

import Foundation

public class ParsingException: ExtractionException, @unchecked Sendable {
    public let cause: Error?

    public init(_ message: String, _ cause: Error? = nil) {
        self.cause = cause
        super.init(message)
    }
}

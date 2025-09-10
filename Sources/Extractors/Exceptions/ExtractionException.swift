//
//  ExtractionException.swift
//  NewPipe
//
//  Created by Cédric Bahirwe on 15/11/2024.
//


import Foundation

public class ExtractionException: Error, @unchecked Sendable {
    public let message: String?
    public let cause: Error?

    public init(_ message: String? = nil, _ cause: Error? = nil) {
        self.message = message
        self.cause = cause
    }
}

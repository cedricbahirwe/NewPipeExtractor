//
//  Exception.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 16/11/2024.
//

import Foundation

public struct Exception: Error {
    public let message: String
    public let cause: Error?

    public init(_ message: String, _ cause: Error? = nil) {
        self.message = message
        self.cause = cause
    }
}

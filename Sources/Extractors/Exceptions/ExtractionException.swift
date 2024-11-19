//
//  ExtractionException.swift
//  NewPipe
//
//  Created by Cédric Bahirwe on 15/11/2024.
//


import Foundation

public class ExtractionException: Error, @unchecked Sendable {
    public let message: String
    init (_ message: String) {
        self.message = message
    }
}

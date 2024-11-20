//
//  IllegalArgumentException.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 16/11/2024.
//

import Foundation

public class IllegalArgumentException: Error, @unchecked Sendable {
    public let message: String

    init(_ message: String) {
        self.message = message
    }
}

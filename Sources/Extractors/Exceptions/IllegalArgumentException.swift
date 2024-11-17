//
//  IllegalArgumentException.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 16/11/2024.
//

import Foundation

public struct IllegalArgumentException: Error {
    public let message: String

    init(_ message: String) {
        self.message = message
    }
}

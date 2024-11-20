//
//  ContentNotSupportedException.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 20/11/2024.
//

import Foundation

public class ContentNotSupportedException: ParsingException, @unchecked Sendable {
    public init(_ message: String) {
        super.init(message)
    }

    public init(_ message: String, cause: Error) {
        super.init(message, cause)
    }
}

//
//  ReCaptchaException.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 16/11/2024.
//

import Foundation

public class ReCaptchaException: ExtractionException, @unchecked Sendable {
    public let urlString: String

    public init(_ message: String, _ urlString: String) {
        self.urlString = urlString
        super.init(message)
    }

}

//
//  ReCaptchaException.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 16/11/2024.
//

import Foundation

public class ReCaptchaException: ExtractionException, @unchecked Sendable {
    private let url: URL

    public init(url: URL) {
        self.url = url
        super.init(url.absoluteString)
    }

    func getUrl() -> URL {
        url
    }
}

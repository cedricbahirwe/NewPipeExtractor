//
//  LinkHandler.swift
//  NewPipe
//
//  Created by Cédric Bahirwe on 15/11/2024.
//

import Foundation

public class LinkHandler {
    private let originalUrl: String
    private let url: String
    private let id: String

    public init(_ originalUrl: String, _ url: String, _ id: String) {
        self.originalUrl = originalUrl
        self.url = url
        self.id = id
    }

    public func getOriginalUrl() -> String {
        return originalUrl
    }

    func getUrl() -> String {
        return url
    }

    func getId() -> String {
        return id
    }

    func getBaseUrl() throws -> String {
        try Utils.getBaseUrl(url)
    }
}


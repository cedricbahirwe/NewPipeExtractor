//
//  Page.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 16/11/2024.
//

import Foundation

public class Page: Codable {
    private let url: String?
    private let id: String?
    private let ids: [String]?
    private let cookies: [String: String]?
    private let body: Data?

    public init(url: String? = nil,
         id: String? = nil,
         ids: [String]? = nil,
         cookies: [String: String]? = nil,
         body: Data? = nil) {
        self.url = url
        self.id = id
        self.ids = ids
        self.cookies = cookies
        self.body = body
    }

    // Convenience initializers
    public convenience init(url: String) {
        self.init(url: url, id: nil, ids: nil, cookies: nil, body: nil)
    }

    public convenience init(url: String, id: String) {
        self.init(url: url, id: id, ids: nil, cookies: nil, body: nil)
    }

    public convenience init(url: String, id: String, body: Data) {
        self.init(url: url, id: id, ids: nil, cookies: nil, body: body)
    }

    public convenience init(url: String, body: Data) {
        self.init(url: url, id: nil, ids: nil, cookies: nil, body: body)
    }

    public convenience init(url: String, cookies: [String: String]) {
        self.init(url: url, id: nil, ids: nil, cookies: cookies, body: nil)
    }

    public convenience init(ids: [String]) {
        self.init(url: nil, id: nil, ids: ids, cookies: nil, body: nil)
    }

    public convenience init(ids: [String], cookies: [String: String]) {
        self.init(url: nil, id: nil, ids: ids, cookies: cookies, body: nil)
    }

    // Static method to validate a Page instance
    public static func isValid(_ page: Page?) -> Bool {
        guard let page = page else { return false }
        return !(page.url?.isEmpty ?? true) || !(page.ids?.isEmpty ?? true)
    }

    public func getUrl() -> String? {
        url
    }

    public func getIds() -> [String]? {
        ids
    }

    public func getCookies() -> [String: String]? {
        cookies
    }

    public func getBody() -> Data? {
        body
    }
}

//
//  ListLinkHandler.swift
//  NewPipe
//
//  Created by Cédric Bahirwe on 15/11/2024.
//

import Foundation

public class ListLinkHandler: LinkHandler {
    private let contentFilters: [String]
    private let sortFilter: String

    public init(_ originalUrl: String, _ url: String, _ id: String, _ contentFilters: [String], _ sortFilter: String) {
        self.contentFilters = contentFilters
        self.sortFilter = sortFilter
        super.init(originalUrl, url, id)
    }

    public convenience init(handler: ListLinkHandler) {
        self.init(handler.getOriginalUrl(),
                  handler.getUrl(),
                  handler.getId(),
                  handler.getContentFilters(),
                  handler.getSortFilter())
    }

    public convenience init(handler: LinkHandler) {
        self.init(handler.getOriginalUrl(),
                  handler.getUrl(),
                  handler.getId(),
                  [],
                  "")
    }

    public func getContentFilters() -> [String] {
        return contentFilters
    }

    public func getSortFilter() -> String {
        return sortFilter
    }
}


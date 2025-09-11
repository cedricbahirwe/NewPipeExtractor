//
//  ListLinkHandlerFactory.swift
//  NewPipe
//
//  Created by Cédric Bahirwe on 15/11/2024.
//

import Foundation

public protocol ListLinkHandlerFactory: LinkHandlerFactory {
    func getUrl(id: String, contentFilters: [String], sortFilter: String) throws(ParsingUnsupportedOperation) -> String
}

extension ListLinkHandlerFactory {
    func getUrl(id: String, contentFilters: [String], sortFilter: String, baseUrl: String) throws(ParsingUnsupportedOperation) -> String {
        try getUrl(id: id, contentFilters: contentFilters, sortFilter: sortFilter)
    }
    // MARK: - Logic

    public func fromUrl(url: String) throws(ParsingException) -> ListLinkHandler {
        let polishedUrl = Utils.followGoogleRedirectIfNeeded(url)
        let baseUrl = try Utils.getBaseUrl(polishedUrl)
        return try fromUrl(polishedUrl, baseUrl)
    }

    public func fromUrl(_ url: String, _ baseUrl: String) throws(ParsingException) -> ListLinkHandler {
        ListLinkHandler(handler: try fromId(url, baseUrl))
    }

    public func fromId(_ id: String) throws(ParsingException) -> ListLinkHandler {
        ListLinkHandler(handler: try fromId(id))
    }

    public func fromId(_ id: String, _ baseUrl: String) throws(ParsingException) -> ListLinkHandler {
        ListLinkHandler(handler: try fromId(id, baseUrl))
    }

    public func fromQuery(id: String, contentFilters: [String], sortFilter: String) throws -> ListLinkHandler {
        let url = try getUrl(id: id, contentFilters: contentFilters, sortFilter: sortFilter)
        return ListLinkHandler(url, url, id, contentFilters, sortFilter)
    }

    public func fromQuery(id: String, contentFilters: [String], sortFilter: String, baseUrl: String) throws -> ListLinkHandler {
        let url = try getUrl(id: id, contentFilters: contentFilters, sortFilter: sortFilter, baseUrl: baseUrl)
        return ListLinkHandler(url, url, id, contentFilters, sortFilter)
    }

    /**
     * For making ListLinkHandlerFactory compatible with LinkHandlerFactory we need to override
     * this, however it should not be overridden by the actual implementation.
     *
     * @return the url corresponding to id without any filters applied
     */
    public func getUrl(_ id: String) throws(ParsingUnsupportedOperation) -> String {
        try getUrl(id: id, contentFilters: [], sortFilter: "")
    }

    public func getUrl(_ id: String, _ baseUrl: String) throws(ParsingUnsupportedOperation) -> String {
        try getUrl(id: id, contentFilters: [], sortFilter: "", baseUrl: baseUrl)
    }

    /**
     * Will returns content filter the corresponding extractor can handle like "channels", "videos",
     * "music", etc.
     *
     * @return filter that can be applied when building a query for getting a list
     */
    public func getAvailableContentFilter() -> [String] {
        return []
    }

    /**
     * Will returns sort filter the corresponding extractor can handle like "A-Z", "oldest first",
     * "size", etc.
     *
     * @return filter that can be applied when building a query for getting a list
     */
    func getAvailableSortFilter() -> [String] {
        return []
    }
}

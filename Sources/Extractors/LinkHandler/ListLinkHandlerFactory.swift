//
//  ListLinkHandlerFactory.swift
//  NewPipe
//
//  Created by Cédric Bahirwe on 15/11/2024.
//

import Foundation

public protocol ListLinkHandlerFactory: LinkHandlerFactory {

    // MARK: - To Override
    func getUrl(id: String, contentFilters: [String], sortFilter: String) throws -> String

    func getUrl(id: String, contentFilters: [String], sortFilter: String, baseUrl: String) throws -> String
}

extension ListLinkHandlerFactory {

    // MARK: - Logic

    public func fromUrl(_ url: String) throws -> LinkHandler {
        try fromUrl(url: url)
    }

    public func fromUrl(_ url: String, _ baseUrl: String) throws -> LinkHandler {
        try fromUrl(url: url, baseUrl: baseUrl)
    }

    public func fromId(_ id: String) throws -> LinkHandler {
       try fromId(id: id)
    }

    public func fromId(_ id: String, _ baseUrl: String) throws -> LinkHandler {
        try fromId(id: id, baseUrl: id)
    }


    public func getUrl(_ id: String, _ baseUrl: String) throws -> String {
        try getUrl(id: id, contentFilters: [], sortFilter: "", baseUrl: baseUrl)
    }


    private func fromUrl(url: String) throws -> ListLinkHandler {
        let polishedUrl = try Utils.followGoogleRedirectIfNeeded(url)
        let baseUrl = try Utils.getBaseUrl(polishedUrl)
        return try fromUrl(url: polishedUrl, baseUrl: baseUrl)
    }

    private func fromUrl(url: String, baseUrl: String) throws -> ListLinkHandler {
        return ListLinkHandler(handler: try fromUrl(url, baseUrl))
    }

    private func fromId(id: String) throws -> ListLinkHandler {
        return ListLinkHandler(handler: try fromId(id))
    }


    private func fromId(id: String, baseUrl: String) throws -> ListLinkHandler {
        return ListLinkHandler(handler: try fromId(id, baseUrl))
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
    public func getUrl(_ id: String) throws -> String {
        try getUrl(id: id, contentFilters: [], sortFilter: "")
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

//
//  SearchQueryHandlerFactory.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 13/12/2024.
//


public protocol SearchQueryHandlerFactory: ListLinkHandlerFactory {}

// MARK: - Logic

public extension SearchQueryHandlerFactory {
    private func getSearchString(from url: String) -> String { "" }

    func getId(_ url: String) throws -> String {
        return getSearchString(from: url)
    }

    func fromQuery(query: String, contentFilter: [String], sortFilter: String) throws -> SearchQueryHandler {
        return SearchQueryHandler(handler: try fromQuery(id: query, contentFilters: contentFilter, sortFilter: sortFilter))
    }

    func fromQuery(query: String) throws -> SearchQueryHandler {
        return try fromQuery(query: query, contentFilter: [], sortFilter: "")
    }

    /// It's not mandatory for NewPipe to handle the URL
    func onAcceptUrl(url: String) -> Bool {
        return false
    }
}

//
//  SearchQueryHandler.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 17/11/2024.
//

import Foundation

/// A handler for managing search queries, extending the functionality of `ListLinkHandler`.
public class SearchQueryHandler: ListLinkHandler {

    // MARK: - Initializers
    
    /// Initializes a `SearchQueryHandler` with the specified parameters.
    /// - Parameters:
    ///   - originalUrl: The original URL of the query.
    ///   - url: The processed URL for the query.
    ///   - searchString: The search string for the query.
    ///   - contentFilters: The content filters applied to the query.
    ///   - sortFilter: The sort filter applied to the query.
    public init(originalUrl: String,
         url: String,
         searchString: String,
         contentFilters: [String],
         sortFilter: String) {
        super.init(originalUrl,
                   url,
                   searchString,
                   contentFilters,
                   sortFilter)
    }

    /// Initializes a `SearchQueryHandler` using an existing `ListLinkHandler`.
    /// - Parameter handler: The `ListLinkHandler` to initialize from.
    public init(handler: ListLinkHandler) {
        super.init(handler.getOriginalUrl(),
                   handler.getUrl(),
                   handler.getId(),
                   handler.getContentFilters(),
                   handler.getSortFilter())
    }

    // MARK: - Methods
    
    /// Returns the search string. Since `ListQueryHandler` is based on `ListLinkHandler`,
    /// `getSearchString()` is equivalent to calling `getId()`.
    ///
    /// - Returns: The search string.
    public func getSearchString() -> String {
        return getId()
    }
}

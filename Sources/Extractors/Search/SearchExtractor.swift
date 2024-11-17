//
//  SearchExtractor.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 17/11/2024.
//

import Foundation

/// Abstract base class for search extractors.
public class SearchExtractor<R: InfoItem>: ListExtractor<R> {

    /// Exception thrown when nothing is found.
    public class NothingFoundException: ExtractionException, @unchecked Sendable {}

    /// Initializes the search extractor.
    ///
    /// - Parameters:
    ///   - service: The streaming service associated with the extractor.
    ///   - linkHandler: The search query handler.
    public init(service: any StreamingService, linkHandler: SearchQueryHandler) {
        super.init(service: service, linkHandler: linkHandler)
    }

    /// Retrieves the search string from the link handler.
    ///
    /// - Returns: The search string.
    public func getSearchString() -> String {
        return getLinkHandler().getSearchString()
    }

    /// The search suggestion provided by the service.
    ///
    /// This method also returns the corrected query if `isCorrectedSearch()` is `true`.
    ///
    /// - Throws: `ParsingException` if the search suggestion cannot be retrieved.
    /// - Returns: A suggestion for another query, the corrected query, or an empty string.
    public func getSearchSuggestion() throws -> String {
        fatalError("getSearchSuggestion() must be overridden")
    }

    /// Retrieves the link handler as a `SearchQueryHandler`.
    ///
    /// - Returns: The `SearchQueryHandler` associated with the extractor.
    public override func getLinkHandler() -> SearchQueryHandler {
        return super.getLinkHandler() as! SearchQueryHandler
    }

    /// Retrieves the name of the search extractor.
    ///
    /// - Returns: The search string.
    public override func getName() -> String {
        return getSearchString()
    }

    /// Indicates whether the search was corrected by the service.
    ///
    /// Example: If you search for "pewdeipie" on YouTube, it might return results for "pewdiepie."
    ///
    /// - Throws: `ParsingException` if the correction status cannot be determined.
    /// - Returns: `true` if the search results were corrected, otherwise `false`.
    public func isCorrectedSearch() throws -> Bool {
        fatalError("isCorrectedSearch() must be overridden")
    }

    /// Retrieves meta information about the search query.
    ///
    /// Example: On YouTube, searching for "Covid-19" might show a box with information from WHO and a link to their website.
    ///
    /// - Throws: `ParsingException` if meta information cannot be retrieved.
    /// - Returns: A list of additional meta information about the search query.
    public func getMetaInfo() throws -> [MetaInfo] {
        fatalError("getMetaInfo() must be overridden")
    }
}

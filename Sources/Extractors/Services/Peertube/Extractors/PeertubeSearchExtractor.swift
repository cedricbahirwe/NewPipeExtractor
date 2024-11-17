//
//  PeertubeSearchExtractor.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 17/11/2024.
//

import Foundation

public class PeertubeSearchExtractor: SearchExtractor<StreamInfoItem> {

    // MARK: - Properties
    
    /// Indicates whether to use `PeertubeSepiaStreamInfoItemExtractor`.
    private let sepia: Bool

    // MARK: - Initializers

    /// Initializes the extractor with the given streaming service and link handler.
    ///
    /// - Parameters:
    ///   - service: The streaming service associated with the extractor.
    ///   - linkHandler: The search query handler.
    ///   - sepia: Whether to use Sepia extractor (default: `false`).
    init(service: any StreamingService, linkHandler: SearchQueryHandler, sepia: Bool = false) {
        self.sepia = sepia
        super.init(service: service, linkHandler: linkHandler)
    }

    // MARK: - Methods

    /// Returns the search suggestion.
    ///
    /// - Returns: An empty string as PeerTube does not provide search suggestions.
    public override func getSearchSuggestion() -> String {
        return ""
    }

    /// Indicates if the search query was corrected.
    ///
    /// - Returns: `false` as PeerTube does not provide corrected search queries.
    public override func isCorrectedSearch() -> Bool {
        return false
    }

    /// Returns meta information about the search.
    ///
    /// - Returns: An empty list as PeerTube does not provide meta information.
    public override func getMetaInfo() -> [MetaInfo] {
        return []
    }

    /// Retrieves the initial page of search results.
    ///
    /// - Throws: `IOException` or `ExtractionException` if the page cannot be loaded or parsed.
    /// - Returns: The `InfoItemsPage` containing the initial search results.
    override func getInitialPage() throws -> InfoItemsPage<StreamInfoItem> {
        let initialUrl = try getUrl() + "&\(PeertubeParsingHelper.START_KEY)=0&\(PeertubeParsingHelper.COUNT_KEY)=\(PeertubeParsingHelper.ITEMS_PER_PAGE)"
        return try getPage(Page(url: initialUrl))
    }

    /// Retrieves a specific page of search results.
    ///
    /// - Parameter page: The page to retrieve.
    /// - Throws: `IOException`, `ParsingException`, or `ExtractionException`.
    /// - Returns: The `InfoItemsPage` containing the search results for the specified page.
    public override func getPage(_ page: Page?) throws -> InfoItemsPage<StreamInfoItem> {
        guard let page = page, let pageUrl = page.getUrl(), Utils.isNullOrEmpty(pageUrl) else {
            throw IllegalArgumentException("Page doesn't contain a URL")
        }

        let response = try getDownloader().get(pageUrl)
        let responseBody = response.responseBody

        guard !Utils.isBlank(responseBody) else {
            throw ExtractionException("Unable to get PeerTube search info")
        }

        let json: JsonObject
        do {
            json = try JsonParser.parse(from: responseBody)
        } catch {
            throw ParsingException("Could not parse JSON data for search info", error)
        }

        try PeertubeParsingHelper.validate(json)
        let total = json.getLong("total")

        let collector = MultiInfoItemsCollector<StreamInfoItem, PeertubeStreamInfoItemExtractor>(serviceId: getServiceId())
        try PeertubeParsingHelper.collectItemsFrom(collector, json, try getBaseUrl(), sepia)

        if let pageUrl = page.getUrl() {
            return InfoItemsPage(
                collector: collector,
                nextPage: PeertubeParsingHelper.getNextPage(pageUrl, total)
            )
        } else {
            throw ExtractionException("Page doesn't contain a URL")
        }

    }

    /// Fetches the current page. Not implemented for this extractor.
    ///
    /// - Parameter downloader: The downloader to use.
    public override func onFetchPage(downloader: Downloader) throws {
        // Not implemented
    }
}

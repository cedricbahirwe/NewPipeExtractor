//
//  Extractor.swift
//  NewPipe
//
//  Created by Cédric Bahirwe on 15/11/2024.
//

import Foundation

/// Base class for extractors, providing common functionality for different types of extractors.
open class Extractor {

    // MARK: - Properties

    /// The streaming service related to this extractor.
    private let service: any StreamingService

    /// The link handler associated with this extractor.
    private let linkHandler: LinkHandler

    /// Optional forced localization for this extractor.
    private var forcedLocalization: Localization?

    /// Optional forced content country for this extractor.
    private var forcedContentCountry: ContentCountry?

    /// Indicates whether the page has been fetched.
    public var isPageFetched: Bool = false

    /// The downloader used for fetching data.
    private let downloader: Downloader

    // MARK: - Initializer

    /// Initializes an `Extractor` with the given service and link handler.
    ///
    /// - Parameters:
    ///   - service: The streaming service related to this extractor.
    ///   - linkHandler: The link handler associated with this extractor.
    public init(service: any StreamingService, linkHandler: LinkHandler) {
        guard let downloader = NewPipe.getDownloader() else {
            fatalError("Downloader is null")
        }
        self.service = service
        self.linkHandler = linkHandler
        self.downloader = downloader
    }

    // MARK: - Methods

    /// Returns the link handler for the current extractor.
    ///
    /// - Returns: The `LinkHandler` instance.
    public func getLinkHandler() -> LinkHandler {
        return linkHandler
    }

    /// Fetches the current page.
    ///
    /// - Throws: `IOException` if the page cannot be loaded or `ExtractionException` if the page's content is not understood.
    public func fetchPage() throws {
        if isPageFetched {
            return
        }
        try onFetchPage(downloader: downloader)
        isPageFetched = true
    }

    /// Ensures the page has been fetched before proceeding.
    public func assertPageFetched() {
        guard isPageFetched else {
            fatalError("Page is not fetched. Make sure you call fetchPage()")
        }
    }

    /// Abstract method to fetch the current page using the given downloader.
    ///
    /// - Parameter downloader: The downloader to use.
    /// - Throws: `IOException` or `ExtractionException`.
    public func onFetchPage(downloader: Downloader) throws {
        fatalError("onFetchPage(downloader:) must be overridden in subclasses")
    }

    /// Gets the ID of the link handler.
    ///
    /// - Throws: `ParsingException` if the ID cannot be retrieved.
    /// - Returns: The ID as a `String`.
    public func getId() throws -> String {
        return linkHandler.getId()
    }

    /// Abstract method to get the name.
    ///
    /// - Throws: `ParsingException` if the name cannot be extracted.
    /// - Returns: The name as a `String`.
    public func getName() throws -> String {
        fatalError("getName() must be overridden in subclasses")
    }

    /// Gets the original URL of the link handler.
    ///
    /// - Throws: `ParsingException` if the original URL cannot be retrieved.
    /// - Returns: The original URL as a `String`.
    public func getOriginalUrl() throws -> String {
        return linkHandler.getOriginalUrl()
    }

    /// Gets the URL of the link handler.
    ///
    /// - Throws: `ParsingException` if the URL cannot be retrieved.
    /// - Returns: The URL as a `String`.
    public func getUrl() throws -> String {
        return linkHandler.getUrl()
    }

    /// Gets the base URL of the link handler.
    ///
    /// - Throws: `ParsingException` if the base URL cannot be retrieved.
    /// - Returns: The base URL as a `String`.
    public func getBaseUrl() throws -> String {
        return try linkHandler.getBaseUrl()
    }

    /// Gets the streaming service related to this extractor.
    ///
    /// - Returns: The `StreamingService` instance.
    public func getService() -> any StreamingService {
        return service
    }

    /// Gets the service ID of the streaming service.
    ///
    /// - Returns: The service ID as an `Int`.
    public func getServiceId() -> Int {
        return service.getServiceId()
    }

    /// Gets the downloader used by this extractor.
    ///
    /// - Returns: The `Downloader` instance.
    public func getDownloader() -> Downloader {
        return downloader
    }

    // MARK: - Localization

    /// Forces a specific localization for this extractor.
    ///
    /// - Parameter localization: The `Localization` to force.
    public func forceLocalization(_ localization: Localization) {
        forcedLocalization = localization
    }

    /// Forces a specific content country for this extractor.
    ///
    /// - Parameter contentCountry: The `ContentCountry` to force.
    public func forceContentCountry(_ contentCountry: ContentCountry) {
        forcedContentCountry = contentCountry
    }

    /// Gets the localization for this extractor.
    ///
    /// - Returns: The `Localization` instance.
    public func getExtractorLocalization() -> Localization {
        return forcedLocalization ?? service.getLocalization()
    }

    /// Gets the content country for this extractor.
    ///
    /// - Returns: The `ContentCountry` instance.
    public func getExtractorContentCountry() -> ContentCountry {
        return forcedContentCountry ?? service.getContentCountry()
    }

    /// Gets the time-ago parser for this extractor.
    ///
    /// - Returns: The `TimeAgoParser` instance.
    public func getTimeAgoParser() throws -> TimeAgoParser {
        return try service.getTimeAgoParser(for: getExtractorLocalization())
    }
}

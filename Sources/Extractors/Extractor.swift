//
//  Extractor.swift
//  NewPipe
//
//  Created by Cédric Bahirwe on 15/11/2024.
//

import Foundation

public class Extractor {

    /// ``StreamingService`` currently related to this extractor. Useful for getting other things from a service (like the url handlers for cleaning/accepting/get id from urls).
    private let service: StreamingService

    private let linkHandler: LinkHandler

    private var forcedLocalization: Localization?

    private var forcedContentCountry: ContentCountry?

    /// Indicates whether the page has been fetched.
    private var pageFetched: Bool = false

    private let downloader: Downloader

    // MARK: - Initializer

    public init(_ service: StreamingService, _ linkHandler: LinkHandler) {
        self.service = service
        self.linkHandler = linkHandler
        guard let downloader = NewPipe.getDownloader() else {
            fatalError("Downloader is null")
        }
        self.downloader = downloader
    }

    // MARK: - Methods

    /// - Returns: The ``LinkHandler`` of the current extractor object (e.g. a ChannelExtractor
    /// .should return a channel url handler).
    public func getLinkHandler() -> LinkHandler {
        return linkHandler
    }

    public enum CopierError: Error {
        case outOfPaper
    }

    public enum CopierSuccess: Error {
        case outOfPaper
    }

    /// Fetches the current page.
    ///
    /// - Throws: `IOException` if the page cannot be loaded or `ExtractionException` if the page's content is not understood.
    public func fetchPage() throws(IOExtractionException) {
        if pageFetched {
            return
        }
        try onFetchPage(downloader)
        pageFetched = true
    }

    public func assertPageFetched() throws {
        guard pageFetched else {
            throw IllegalStateError("Page is not fetched. Make sure you call fetchPage()")
        }
    }

    /// Fetch the current page.
    ///
    /// - Parameter downloader: The downloader to use.
    /// - Throws: `IOExtractionException`  the page can not be loaded or the pages content is not understood
    public func onFetchPage(_ downloader: Downloader) throws(IOExtractionException) {
        fatalError("onFetchPage(downloader:) must be overridden in subclasses")
    }

    public func getId() throws(ParsingException) -> String {
        linkHandler.getId()
    }


    //// Get the name
    ///
    /// - Throws: ``ParsingException`` if the name cannot be extracted.
    /// - Returns: the name
    public func getName() throws(ParsingException) -> String {
        fatalError("getName() must be overridden in subclasses")
    }

    public func getOriginalUrl() throws(ParsingException) -> String {
        linkHandler.getOriginalUrl()
    }

    public func getUrl() throws -> String {
        linkHandler.getUrl()
    }

    public func getBaseUrl() throws -> String {
        try linkHandler.getBaseUrl()
    }

    public func getService() -> StreamingService {
        return service
    }

    public func getServiceId() -> Int {
        service.serviceId
    }

    public func getDownloader() -> Downloader {
        return downloader
    }

    // MARK: - Localization

    public func forceLocalization(_ localization: Localization) {
        forcedLocalization = localization
    }

    public func forceContentCountry(_ contentCountry: ContentCountry) {
        forcedContentCountry = contentCountry
    }

    public func getExtractorLocalization() -> Localization {
        forcedLocalization ?? service.getLocalization()
    }

    public func getExtractorContentCountry() -> ContentCountry {
        forcedContentCountry ?? service.getContentCountry()
    }

    public func getTimeAgoParser() throws -> TimeAgoParser {
        try service.getTimeAgoParser(getExtractorLocalization())
    }
}

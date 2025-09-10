//
//  StreamingService.swift
//  NewPipe
//
//  Created by Cédric Bahirwe on 15/11/2024.
//

import Foundation

public typealias SubscriptionExtractor = String
public typealias SearchQueryExtractor = String
public typealias ItagItem = String

public typealias List<T> = Array<T>

public typealias AnyStreamingService = StreamingService
public class StreamingService: CustomStringConvertible {

    /// This class holds meta information about the service implementation.
    public struct ServiceInfo {
        public let name: String

        public let mediaCapabilities: List<MediaCapability>

        
        /// Creates a new instance of a ServiceInfo
        /// - Parameters:
        ///   - name: the name of the service
        ///   - mediaCapabilities: the type of media this service can handle
        public init(_ name: String, _ mediaCapabilities: List<MediaCapability>) {
            self.name = name;
            self.mediaCapabilities = mediaCapabilities
        }

        public enum MediaCapability {
            case audio, video, live, comments
        }
    }

    /// LinkType will be used to determine which type of URL you are handling,
    /// and therefore which part of NewPipe should handle a certain URL.
    public enum LinkType {
        case none,
             stream,
             channel,
             playlist
    }

    public let serviceId: Int
    public let serviceInfo: ServiceInfo

    
    ///  Creates a new Streaming service.
    ///
    ///  If you Implement one do not set id within your implementation of this extractor, instead
    ///  set the id when you put the extractor into `NewPipe`
    ///  All other parameters can be set directly from the overriding constructor.
    /// - Parameters:
    ///   - id: the number of the service to identify him within the NewPipe frontend
    ///   - name: the name of the service
    ///   - capabilities: the type of media this service can handle
    /// - SeeAlso: `NewPipe`
    public init(_ id: Int,
                _ name: String,
                _ capabilities: List<ServiceInfo.MediaCapability>) {
        self.serviceId = id
        self.serviceInfo = ServiceInfo(name, capabilities)
    }

    public var description: String {
        "\(serviceId):\(serviceInfo.name)"
    }


    // Abstracts
    public func getBaseUrl() -> String {
        fatalError("Must override")
    }


    // MARK: - Url Id handler

    ///  Must return a new instance of an implementation of LinkHandlerFactory for streams.
    /// - Returns: an instance of a LinkHandlerFactory for streams
    public func getStreamLHFactory() throws -> LinkHandlerFactory {
        fatalError("Must override")
    }

    /// Must return a new instance of an implementation of ListLinkHandlerFactory for channels.
    /// If support for channels is not given null must be returned.
    /// - Returns: an instance of a ListLinkHandlerFactory for channels or null
    public func getChannelLHFactory() throws -> ListLinkHandlerFactory? {
        fatalError("Must override")
    }

    /// Must return a new instance of an implementation of ListLinkHandlerFactory for channel tabs.
    /// If support for channel tabs is not given null must be returned.
    /// - Returns: an instance of a ListLinkHandlerFactory for channels or null
    public func  getChannelTabLHFactory() throws -> ListLinkHandlerFactory? {
        fatalError("Must override")
    }

    /// Must return a new instance of an implementation of ListLinkHandlerFactory for playlists.
    /// If support for playlists is not given null must be returned.
    /// - Returns: an instance of a ListLinkHandlerFactory for playlists or null
    public  func getPlaylistLHFactory() throws -> ListLinkHandlerFactory? {
        fatalError("Must override")
    }

    /// Must return an instance of an implementation of SearchQueryHandlerFactory.
    /// - Returns: an instance of a SearchQueryHandlerFactory
    public func getSearchQHFactory() -> SearchQueryHandlerFactory {
        fatalError("Must override")
    }

    public func getCommentsLHFactory() throws -> ListLinkHandlerFactory {
        fatalError("Must override")
    }

    // MARK: - Extractors

    /// Must create a new instance of a SearchExtractor implementation.
    /// - Parameter queryHandler: specifies the keyword to look for, and the filters which should be applied.
    /// - Returns: a new SearchExtractor instance
    public func getSearchExtractor(_ queryHandler: SearchQueryHandler) -> SearchExtractor {
        fatalError("Must override")
    }

    /// Must create a new instance of a SuggestionExtractor implementation.
    /// - Returns: a new SuggestionExtractor instance
    public func getSuggestionExtractor() -> SuggestionExtractor {
        fatalError("Must override")
    }

    /**
     * Outdated or obsolete. null can be returned.
     * @return just null
     */
    func getSubscriptionExtractor() -> SubscriptionExtractor? {
        fatalError()
    }

    /**
     * Must create a new instance of a KioskList implementation.
     * @return a new KioskList instance
     */
    func getKioskList() throws -> KioskList {
        fatalError("Must override")
    }

    /**
     * Must create a new instance of a ChannelExtractor implementation.
     * @param linkHandler is pointing to the channel which should be handled by this new instance.
     * @return a new ChannelExtractor
     */
    func getChannelExtractor(_ linkHandler: ListLinkHandler) throws -> ChannelExtractor {
        fatalError("Must override")
    }

    /**
     * Must create a new instance of a ChannelTabExtractor implementation.
     *
     * @param linkHandler is pointing to the channel which should be handled by this new instance.
     * @return a new ChannelTabExtractor
     */
    func getChannelTabExtractor(_ linkHandler: ListLinkHandler) throws -> ChannelTabExtractor {
        fatalError("Must override")
    }

    /**
     * Must crete a new instance of a PlaylistExtractor implementation.
     * @param linkHandler is pointing to the playlist which should be handled by this new instance.
     * @return a new PlaylistExtractor
     */
    func getPlaylistExtractor(_ linkHandler: ListLinkHandler) throws -> PlaylistExtractor {
        fatalError("Must override")
    }

    /**
     * Must create a new instance of a StreamExtractor implementation.
     * @param linkHandler is pointing to the stream which should be handled by this new instance.
     * @return a new StreamExtractor
     */
    func getStreamExtractor(_ linkHandler: LinkHandler) throws -> StreamExtractor {
        fatalError("Must override")
    }

    func getCommentsExtractor(_ linkHandler: ListLinkHandler) throws -> CommentsExtractor {
        fatalError("Must override")
    }

    /**
     * Creates a new Streaming service.
     * If you Implement one do not set id within your implementation of this extractor, instead
     * set the id when you put the extractor into {@link ServiceList}
     * All other parameters can be set directly from the overriding constructor.
     * @param id the number of the service to identify him within the NewPipe frontend
     * @param name the name of the service
     * @param capabilities the type of media this service can handle
     */
    //    func `init`(id: Int,
    //         name: String,
    //         capabilities: List<StreamingServiceInfo.MediaCapability>)
}

extension StreamingService  {
    //    public func `init`(
    //        id: Int,
    //        name: String,
    //        capabilities: List<StreamingServiceInfo.MediaCapability>
    //    ) {
    //        self.serviceId = id
    //        self.serviceInfo = StreamingServiceInfo(name, capabilities)
    //    }
}

extension StreamingService {

    /**
     * This method decides which strategy will be chosen to fetch the feed. In YouTube, for example,
     * a separate feed exists which is lightweight and made specifically to be used like this.
     * <p>
     * In services which there's no other way to retrieve them, null should be returned.
     *
     * @return a {@link FeedExtractor} instance or null.
     */
    public func getFeedExtractor(_ url: String) throws -> FeedExtractor? {
        return nil
    }

    // MARK: - Extractors without link handler

    //    public func getSearchExtractor(
    //        _ query: String,
    //        _ contentFilter: List<String>,
    //        _ sortFilter: String) throws -> SearchExtractor {
    //        return getSearchExtractor(getSearchQHFactory())
    //                .fromQuery(query, contentFilter, sortFilter));
    //    }

    //    public func getChannelExtractor(
    //        _ id: String,
    //        _ contentFilter: List<String>,
    //        _ sortFilter: String) throws -> ChannelExtractor {
    //        return getChannelExtractor(getChannelLHFactory())
    //            .fromQuery(id, contentFilter, sortFilter));
    //    }

    //    public func getPlaylistExtractor(
    //        _ id: String,
    //        _ contentFilter: List<String>,
    //        _ sortFilter: String) throws -> PlaylistExtractor {
    //        return getPlaylistExtractor(getPlaylistLHFactory())
    ////            .fromQuery(id, contentFilter, sortFilter));
    //    }

    // MARK: - Short extractors overloads

//    public func getSearchExtractor<T: InfoItem>(_ query: String) throws -> SearchExtractor<T> {
//        return getSearchExtractor(getSearchQHFactory().fromQuery(query: query))
//    }

    public func getChannelExtractor(_ url: String) throws -> ChannelExtractor {
        fatalError()
//        try getChannelExtractor(try getChannelLHFactory().fromUrl(url))
    }

    public func getChannelTabExtractorFromId(_ id: String, _ tab: String) throws -> ChannelTabExtractor {
        fatalError()
//        let linkHandler = try getChannelTabLHFactory().fromQuery(
//            id: id,
//            contentFilters: [tab],
//            sortFilter: ""
//        )
//        return try getChannelTabExtractor(linkHandler)
    }

    public func getChannelTabExtractorFromIdAndBaseUrl(_ id: String, _ tab: String, _ baseUrl: String) throws -> ChannelTabExtractor {
        fatalError()
//        let linkHandler = try getChannelTabLHFactory().fromQuery(
//            id: id,
//            contentFilters: [tab],
//            sortFilter: "",
//            baseUrl: baseUrl
//        )
//        return try getChannelTabExtractor(linkHandler)
    }

    //    public ChannelTabExtractor getChannelTabExtractorFromIdAndBaseUrl(final String id,
    //                                                                      final String tab,
    //                                                                      final String baseUrl)
    //            throws ExtractionException {
    //        return getChannelTabExtractor(getChannelTabLHFactory().fromQuery(
    //                id, Collections.singletonList(tab), "", baseUrl));
    //    }

    public func getPlaylistExtractor(_ url: String) throws -> PlaylistExtractor {
        fatalError()
//        return try getPlaylistExtractor(try getPlaylistLHFactory().fromUrl(url))
    }

    public func getStreamExtractor(_ url: String) throws -> StreamExtractor {
        fatalError()
//        return try getStreamExtractor(try getStreamLHFactory().fromUrl(url))
    }

    public func getCommentsExtractor(_ url: String) throws -> CommentsExtractor? {
        guard let listLinkHandlerFactory = try? getCommentsLHFactory() else { return nil }
        return try getCommentsExtractor(try listLinkHandlerFactory.fromUrl(url))
    }

    // MARK: - Utils

    /**
     * Figures out where the link is pointing to (a channel, a video, a playlist, etc.)
     *
     * - Parameter url: The URL to determine the link type of.
     * - Returns: The link type of the URL.
     * - Throws: A `ParsingException` if an error occurs during processing.
     */
    public func getLinkTypeByUrl(_ url: String) throws -> StreamingService.LinkType {
        let polishedUrl = try Utils.followGoogleRedirectIfNeeded(url)

        let sH = try? getStreamLHFactory()
        let cH = try? getChannelLHFactory()
        let pH = try? getPlaylistLHFactory()

        if let sH = sH, try sH.acceptUrl(polishedUrl) {
            return .stream
        } else if let cH = cH, try cH.acceptUrl(polishedUrl) {
            return .channel
        } else if let pH = pH, try pH.acceptUrl(polishedUrl) {
            return .playlist
        } else {
            return .none
        }
    }

    // MARK: -  Localization

    /**
     * Returns a list of localizations that this service supports.
     */
    public func getSupportedLocalizations() -> List<Localization> {
        [Localization.DEFAULT]
    }

    /**
     * Returns a list of countries that this service supports.<br>
     */
    public func getSupportedCountries() -> List<ContentCountry> {
        [ContentCountry.DEFAULT]
    }

    /**
     * Returns the localization that should be used in this service. It will get the user's preferred localization,
     * then it will:
     * - Check if the exact localization is supported by this service.
     * - If not, check if a less specific localization is available, using only the language code.
     * - Fallback to the default localization.
     */
    public func getLocalization() -> Localization {
        let preferredLocalization = NewPipe.getPreferredLocalization()

        // Check if the exact localization is supported
        if getSupportedLocalizations().contains(preferredLocalization) {
            return preferredLocalization
        }

        // Fallback to the first supported language that matches the preferred language
        for supportedLanguage in getSupportedLocalizations() {
            if supportedLanguage.getLanguageCode() == preferredLocalization.getLanguageCode() {
                return supportedLanguage
            }
        }

        return Localization.DEFAULT
    }

    /**
     * Returns the country that should be used to fetch content in this service. It will get the user's preferred country,
     * then it will:
     * - Check if the country is supported by this service.
     * - If not, fallback to the default country.
     */
    public func getContentCountry() -> ContentCountry {
        let preferredContentCountry = NewPipe.getPreferredContentCountry()

        if getSupportedCountries().contains(preferredContentCountry) {
            return preferredContentCountry
        }

        return ContentCountry.DEFAULT
    }

    /// Retrieves an instance of the time ago parser using the patterns related to the specified localization.
    ///
    /// Similar to `getLocalization()`, it will attempt to fall back to a less specific localization
    /// if the exact one is not available or supported.
    ///
    /// - Throws: `IllegalArgumentException` if the localization is not supported (parsing patterns are unavailable).
    public func getTimeAgoParser(_ localization: Localization) throws -> TimeAgoParser {
        if let targetParser = TimeAgoPatternsManager.getTimeAgoParserFor(localization) {
            return targetParser
        }

        if !localization.getCountryCode().isEmpty {
            let lessSpecificLocalization = Localization(languageCode: localization.getLanguageCode())
            if let lessSpecificParser = TimeAgoPatternsManager.getTimeAgoParserFor(lessSpecificLocalization) {
                return lessSpecificParser
            }
        }

        throw IllegalArgumentException("Localization is not supported (\"\(localization)\")")
    }
}

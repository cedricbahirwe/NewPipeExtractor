//
//  StreamingService.swift
//  NewPipe
//
//  Created by Cédric Bahirwe on 15/11/2024.
//

import Foundation

/*
 * Copyright (C) 2018 Christian Schabesberger <chris.schabesberger@mailbox.org>
 * StreamingService.java is part of NewPipe Extractor.
 *
 * NewPipe Extractor is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * NewPipe Extractor is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with NewPipe Extractor.  If not, see <http://www.gnu.org/licenses/>.
 */


public typealias SearchQueryHandlerFactory = String
public typealias SubscriptionExtractor = String
public typealias SearchQueryExtractor = String
public typealias SuggestionExtractor = String
public typealias FeedExtractor = String
public typealias KioskList = String
public typealias ChannelExtractor = String
public typealias ChannelTabExtractor = String
public typealias PlaylistExtractor = String
public typealias CommentsExtractor = String
public typealias ItagItem = String

public typealias List<T> = Array<T>
public protocol StreamingService {
    associatedtype ResultInfoItem: InfoItem
    var serviceId: Int { get set }
    var serviceInfo: StreamingServiceInfo { get set }

    func getBaseUrl() -> String

    // MARK: - Url Id handler

    /**
     * Must return a new instance of an implementation of LinkHandlerFactory for streams.
     * @return an instance of a LinkHandlerFactory for streams
     */

    func getStreamLHFactory() throws -> LinkHandlerFactory

    /**
     * Must return a new instance of an implementation of ListLinkHandlerFactory for channels.
     * If support for channels is not given null must be returned.
     * @return an instance of a ListLinkHandlerFactory for channels or null
     */
    func getChannelLHFactory() throws -> ListLinkHandlerFactory

    /**
     * Must return a new instance of an implementation of ListLinkHandlerFactory for channel tabs.
     * If support for channel tabs is not given null must be returned.
     *
     * @return an instance of a ListLinkHandlerFactory for channels or null
     */
    func  getChannelTabLHFactory() throws -> ListLinkHandlerFactory

    /**
     * Must return a new instance of an implementation of ListLinkHandlerFactory for playlists.
     * If support for playlists is not given null must be returned.
     * @return an instance of a ListLinkHandlerFactory for playlists or null
     */
    func getPlaylistLHFactory() throws -> ListLinkHandlerFactory

    /**
     * Must return an instance of an implementation of SearchQueryHandlerFactory.
     * @return an instance of a SearchQueryHandlerFactory
     */
    func getSearchQHFactory() -> SearchQueryHandlerFactory
    func getCommentsLHFactory() -> ListLinkHandlerFactory

    ///////////////////////////////////////////////////////////////////////////
    // Extractors
    ///////////////////////////////////////////////////////////////////////////

    /**
     * Must create a new instance of a SearchExtractor implementation.
     * @param queryHandler specifies the keyword lock for, and the filters which should be applied.
     * @return a new SearchExtractor instance
     */
    func getSearchExtractor(_ queryHandler: SearchQueryHandler) -> SearchExtractor<ResultInfoItem>

    /**
     * Must create a new instance of a SuggestionExtractor implementation.
     * @return a new SuggestionExtractor instance
     */
    func getSuggestionExtractor() -> SuggestionExtractor

    /**
     * Outdated or obsolete. null can be returned.
     * @return just null
     */
    func getSubscriptionExtractor() -> SubscriptionExtractor?

    /**
     * Must create a new instance of a KioskList implementation.
     * @return a new KioskList instance
     */
    func getKioskList() throws -> KioskList

    /**
     * Must create a new instance of a ChannelExtractor implementation.
     * @param linkHandler is pointing to the channel which should be handled by this new instance.
     * @return a new ChannelExtractor
     */
    func getChannelExtractor(_ linkHandler: ListLinkHandler) throws -> ChannelExtractor

    /**
     * Must create a new instance of a ChannelTabExtractor implementation.
     *
     * @param linkHandler is pointing to the channel which should be handled by this new instance.
     * @return a new ChannelTabExtractor
     */
    func getChannelTabExtractor(_ linkHandler: ListLinkHandler) throws -> ChannelTabExtractor

    /**
     * Must crete a new instance of a PlaylistExtractor implementation.
     * @param linkHandler is pointing to the playlist which should be handled by this new instance.
     * @return a new PlaylistExtractor
     */
    func getPlaylistExtractor(_ linkHandler: ListLinkHandler) throws -> PlaylistExtractor

    /**
     * Must create a new instance of a StreamExtractor implementation.
     * @param linkHandler is pointing to the stream which should be handled by this new instance.
     * @return a new StreamExtractor
     */
    func getStreamExtractor(_ linkHandler: LinkHandler) throws -> StreamExtractor

    func getCommentsExtractor(_ linkHandler: ListLinkHandler) throws -> CommentsExtractor

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
    public func getServiceId() -> Int {
        return serviceId
    }

    public func getServiceInfo() -> StreamingServiceInfo {
        return serviceInfo
    }

    public var description: String {
        return String(serviceId) + ":" + serviceInfo.getName();
    }


    /**
     * This method decides which strategy will be chosen to fetch the feed. In YouTube, for example,
     * a separate feed exists which is lightweight and made specifically to be used like this.
     * <p>
     * In services which there's no other way to retrieve them, null should be returned.
     *
     * @return a {@link FeedExtractor} instance or null.
     */
    public func getFeedExtractor(_ url: String) throws -> FeedExtractor? {
        return nil;
    }

    ///////////////////////////////////////////////////////////////////////////
    // Extractors without link handler
    ///////////////////////////////////////////////////////////////////////////

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

    ///////////////////////////////////////////////////////////////////////////
    // Short extractors overloads
    ///////////////////////////////////////////////////////////////////////////

    //    public func getSearchExtractor(_ query: String) throws -> SearchExtractor {
    //        return getSearchExtractor(getSearchQHFactory().fromQuery(query));
    //    }
    //
    //    public func getChannelExtractor(_ url: String) throws -> ChannelExtractor {
    //        return getChannelExtractor(getChannelLHFactory().fromUrl(url));
    //    }

    //    public ChannelTabExtractor getChannelTabExtractorFromId(final String id, final String tab)
    //            throws ExtractionException {
    //        return getChannelTabExtractor(getChannelTabLHFactory().fromQuery(
    //                id, Collections.singletonList(tab), ""));
    //    }
    //
    //    public ChannelTabExtractor getChannelTabExtractorFromIdAndBaseUrl(final String id,
    //                                                                      final String tab,
    //                                                                      final String baseUrl)
    //            throws ExtractionException {
    //        return getChannelTabExtractor(getChannelTabLHFactory().fromQuery(
    //                id, Collections.singletonList(tab), "", baseUrl));
    //    }

    //    public PlaylistExtractor getPlaylistExtractor(final String url) throws ExtractionException {
    //        return getPlaylistExtractor(getPlaylistLHFactory().fromUrl(url));
    //    }

    //    public StreamExtractor getStreamExtractor(final String url) throws ExtractionException {
    //        return getStreamExtractor(getStreamLHFactory().fromUrl(url));
    //    }

    //    public CommentsExtractor getCommentsExtractor(final String url) throws ExtractionException {
    //        final ListLinkHandlerFactory listLinkHandlerFactory = getCommentsLHFactory();
    //        if (listLinkHandlerFactory == null) {
    //            return null;
    //        }
    //        return getCommentsExtractor(listLinkHandlerFactory.fromUrl(url));
    //    }

    // MARK: - Utils

    /**
     * Figures out where the link is pointing to (a channel, a video, a playlist, etc.)
     *
     * - Parameter url: The URL to determine the link type of.
     * - Returns: The link type of the URL.
     * - Throws: A `ParsingException` if an error occurs during processing.
     */
    public func getLinkTypeByUrl(_ url: String) throws -> StreamingServiceTypes.LinkType {
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
    public func getTimeAgoParser(for localization: Localization) throws -> TimeAgoParser {
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

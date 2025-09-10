//
//  PeertubeService.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 16/11/2024.
//

import Foundation

public class PeertubeService: StreamingService, @unchecked Sendable {
    private var shared: PeertubeInstance


    public convenience init(_ id: Int) {
        self.init(id: id, instance: PeertubeInstance.defaultInstance)
    }

    public init(id: Int, instance: PeertubeInstance) {
        self.shared = instance
        super.init(id, "PeerTube", [.video, .comments])
    }

    public override func getStreamLHFactory() throws -> LinkHandlerFactory {
        return PeertubeStreamLinkHandlerFactory.shared
    }

    public override func getChannelLHFactory() throws -> ListLinkHandlerFactory {
        return PeertubeChannelLinkHandlerFactory.shared
    }

    public override func getChannelTabLHFactory() throws -> ListLinkHandlerFactory {
        fatalError("getChannelTabLHFactory() not implemented")
//        return PeertubeChannelTabLinkHandlerFactory.getInstance()
    }

    public override func getPlaylistLHFactory() throws -> ListLinkHandlerFactory {
        throw Exception("getPlaylistLHFactory() not implemented")
//        fatalError("getPlaylistLHFactory() not implemented")
//        return PeertubePlaylistLinkHandlerFactory.getInstance()
    }

    public override func getSearchQHFactory() -> SearchQueryHandlerFactory {
        fatalError("getSearchQHFactory() not implemented")
//        return PeertubeSearchQueryHandlerFactory.getInstance()
    }

    public override func getCommentsLHFactory() -> ListLinkHandlerFactory {
        fatalError("getCommentsLHFactory() not implemented")
//        return PeertubeCommentsLinkHandlerFactory.getInstance()
    }

    public override func getSearchExtractor(_ queryHandler: SearchQueryHandler) -> SearchExtractor {
        fatalError()
//        let contentFilters = queryHandler.getContentFilters()
//        let hasSepiaFilter = !contentFilters.isEmpty && contentFilters[0].starts(with: "sepia_")
//        return PeertubeSearchExtractor(service: self, linkHandler: queryHandler, sepia: hasSepiaFilter)
    }

    public override func getSuggestionExtractor() -> SuggestionExtractor {
        fatalError("getSuggestionExtractor() not implemented")
//        return PeertubeSuggestionExtractor(service: self)
    }

    public override func getSubscriptionExtractor() -> SubscriptionExtractor? {
        return nil
    }

    public override func getChannelExtractor(_ linkHandler: ListLinkHandler) throws -> ChannelExtractor {
        fatalError("getChannelExtractor() not implemented")
//        if linkHandler.getUrl().contains("/video-channels/") {
//            return PeertubeChannelExtractor(service: self, linkHandler: linkHandler)
//        } else {
//            return PeertubeAccountExtractor(service: self, linkHandler: linkHandler)
//        }
    }

    public override func getChannelTabExtractor(_ linkHandler: ListLinkHandler) throws -> ChannelTabExtractor {
        fatalError("getChannelTabExtractor() not implemented")
//        return PeertubeChannelTabExtractor(service: self, linkHandler: linkHandler)
    }

    public override func getPlaylistExtractor(_ linkHandler: ListLinkHandler) throws -> PlaylistExtractor {
        fatalError("getPlaylistExtractor() not implemented")
//        return PeertubePlaylistExtractor(service: self, linkHandler: linkHandler)
    }

    public override func getStreamExtractor(_ linkHandler: LinkHandler) throws -> StreamExtractor {
        fatalError("getStreamExtractor() not implemented")
//        return PeertubeStreamExtractor(service: self, linkHandler: linkHandler)
    }

    public override func getCommentsExtractor(_ linkHandler: ListLinkHandler) throws -> CommentsExtractor {
        fatalError("getCommentsExtractor() not implemented")
//        return PeertubeCommentsExtractor(service: self, linkHandler: linkHandler)
    }

    public override func getBaseUrl() -> String {
        return shared.getUrl()
    }
    
    public func getInstance() -> PeertubeInstance {
        return shared
    }
    
    public override func getKioskList() throws -> KioskList {
        fatalError("getKioskList() not implemented")
//        let handlerFactory = PeertubeTrendingLinkHandlerFactory.getInstance()
//
//        let kioskFactory: KioskList.KioskExtractorFactory = { streamingService, url, id in
//            return PeertubeTrendingExtractor(
//                service: self,
//                linkHandler: handlerFactory.fromId(id),
//                kioskId: id
//            )
//        }
//
//        let list = KioskList(service: self)
//
//        // Add kiosks
//        do {
//            try list.addKioskEntry(factory: kioskFactory, handlerFactory: handlerFactory, id: PeertubeTrendingLinkHandlerFactory.kioskTrending)
//            try list.addKioskEntry(factory: kioskFactory, handlerFactory: handlerFactory, id: PeertubeTrendingLinkHandlerFactory.kioskMostLiked)
//            try list.addKioskEntry(factory: kioskFactory, handlerFactory: handlerFactory, id: PeertubeTrendingLinkHandlerFactory.kioskRecent)
//            try list.addKioskEntry(factory: kioskFactory, handlerFactory: handlerFactory, id: PeertubeTrendingLinkHandlerFactory.kioskLocal)
//            list.setDefaultKiosk(PeertubeTrendingLinkHandlerFactory.kioskTrending)
//        } catch {
//            throw ExtractionException(error)
//        }
//
//        return list
    }
}

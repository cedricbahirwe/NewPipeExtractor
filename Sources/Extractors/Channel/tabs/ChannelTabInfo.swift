//
//  ChannelTabInfo.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 18/11/2024.
//

import Foundation

public class ChannelTabInfo: ListInfo<InfoItem> {
    public init(serviceId: Int, linkHandler: ListLinkHandler) {
        super.init(serviceId: serviceId, listUrlIdHandler: linkHandler, name: linkHandler.getContentFilters().first ?? "")
    }
    
    required init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    /// Get a `ChannelTabInfo` instance from the given service and tab handler.
    public static func getInfo(service: any StreamingService, linkHandler: ListLinkHandler) throws -> ChannelTabInfo {
        let extractor = try service.getChannelTabExtractor(linkHandler)
        try extractor.fetchPage()
        return getInfo(extractor: extractor)
    }

    /// Get a `ChannelTabInfo` instance from a `ChannelTabExtractor`.
    public static func getInfo(extractor: ChannelTabExtractor) -> ChannelTabInfo {
        let info = ChannelTabInfo(serviceId: extractor.getServiceId(), linkHandler: extractor.getLinkHandler())

        do {
            info.setOriginalUrl(try extractor.getOriginalUrl())
        } catch {
            info.addError(error)
        }

        let page: InfoItemsPage<InfoItem> = ExtractorHelper.getItemsPageOrLogError(info: info, extractor: extractor)
        info.setRelatedItems(page.getItems())
        info.setNextPage(page.getNextPage())

        return info
    }

    public static func getMoreItems(service: any StreamingService, linkHandler: ListLinkHandler, page: Page) throws -> InfoItemsPage<InfoItem> {
        return try service.getChannelTabExtractor(linkHandler).getPage(page)
    }
}

//
//  FeedInfo.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 20/11/2024.
//


import Foundation;

public final class FeedInfo: ListInfo<StreamInfoItem> {

    public init(
        serviceId: Int,
        id: String,
        url: String,
        originalUrl: String,
        name: String,
        contentFilter: [String],
        sortFilter: String
    ) {
        super.init(
            serviceId: serviceId,
            id: id,
            url: url,
            originalUrl: originalUrl,
            name: name,
            contentFilters: contentFilter,
            sortFilter: sortFilter
        )
    }
    
    required init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    public static func getInfo(url: String) throws -> FeedInfo {
        guard let service = try? NewPipe.getServiceByUrl(url) else {
            throw ExtractionException("Service not found for the given URL")
        }
        return try getInfo(service: service, url: url)
    }

    public static func getInfo(service: any StreamingService, url: String) throws -> FeedInfo {
        guard let extractor = try service.getFeedExtractor(url) else {
            throw IllegalArgumentException(
                "Service \"\(service.getServiceInfo().getName())\" doesn't support FeedExtractor."
            )
        }

        try extractor.fetchPage()
        return try getInfo(extractor: extractor)
    }

    public static func getInfo(extractor: FeedExtractor) throws -> FeedInfo {
        try extractor.fetchPage()

        let serviceId = extractor.getServiceId()
        let id = try extractor.getId()
        let url = try extractor.getUrl()
        let originalUrl = try extractor.getOriginalUrl()
        let name = try extractor.getName()

        let info = FeedInfo(
            serviceId: serviceId,
            id: id,
            url: url,
            originalUrl: originalUrl,
            name: name,
            contentFilter: [],
            sortFilter: ""
        )

        let itemsPage = ExtractorHelper.getItemsPageOrLogError(info: info, extractor: extractor)
        info.setRelatedItems(itemsPage.getItems())
        info.setNextPage(itemsPage.getNextPage())

        return info
    }
}

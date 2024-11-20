//
//  KioskInfo.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 20/11/2024.
//


public final class KioskInfo: ListInfo<StreamInfoItem> {
    private init(serviceId: Int, linkHandler: ListLinkHandler, name: String) {
        super.init(serviceId: serviceId, listUrlIdHandler: linkHandler, name: name)
    }
    
    required init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    /// Fetches more items for a kiosk.
    public static func getMoreItems(
        service: any StreamingService,
        url: String,
        page: Page
    ) throws -> InfoItemsPage<StreamInfoItem> {
        return try service.getKioskList().getExtractorByUrl(url: url, nextPage: page).getPage(page)
    }

    /// Fetches `KioskInfo` for a given URL.
    public static func getInfo(url: String) throws -> KioskInfo {
        let service = try NewPipe.getServiceByUrl(url)
        return try getInfo(service: service, url: url)
    }

    /// Fetches `KioskInfo` for a specific service and URL.
    public static func getInfo(service: any StreamingService, url: String) throws -> KioskInfo {
        let extractor: KioskExtractor<StreamInfoItem> = try service.getKioskList().getExtractorByUrl(url: url, nextPage: nil)
        try extractor.fetchPage()
        return try getInfo(extractor: extractor)
    }

    /**
     Get `KioskInfo` from `KioskExtractor`.

     - Parameter extractor: An extractor where `fetchPage()` has already been called.
     */
    public static func getInfo(extractor: KioskExtractor<StreamInfoItem>) throws -> KioskInfo {
        let info = KioskInfo(
            serviceId: extractor.getServiceId(),
            linkHandler: extractor.getLinkHandler(),
            name: try extractor.getName()
        )

        let itemsPage = ExtractorHelper.getItemsPageOrLogError(info: info, extractor: extractor)
        info.setRelatedItems(itemsPage.getItems())
        info.setNextPage(itemsPage.getNextPage())

        return info
    }
}

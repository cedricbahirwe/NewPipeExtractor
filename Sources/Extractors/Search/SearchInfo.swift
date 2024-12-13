//
//  SearchInfo.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 13/12/2024.
//


public class SearchInfo: ListInfo<InfoItem> {
    private let searchString: String
    private var searchSuggestion: String?
    private var isCorrectedSearch: Bool = false
    private var metaInfo: List<MetaInfo> = List();

    public init(serviceId: Int,
                qIHandler: SearchQueryHandler,
                searchString: String) {
        self.searchString = searchString
        super.init(serviceId: serviceId, listUrlIdHandler: qIHandler, name: "Search")
    }
    required init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }

    public static func getInfo<T: StreamingService>(service: T, searchQuery: SearchQueryHandler) throws -> SearchInfo where T.ResultInfoItem == InfoItem {
        let extractor = service.getSearchExtractor(searchQuery)
        try extractor.fetchPage()
        return try getInfo(from: extractor)
    }

    public static func getInfo(from extractor: SearchExtractor<InfoItem>) throws -> SearchInfo {
        let info = SearchInfo(
            serviceId: extractor.getServiceId(),
            qIHandler: extractor.getLinkHandler(),
            searchString: extractor.getSearchString()
        )

        info.trySetValue {
            info.setOriginalUrl(try extractor.getOriginalUrl())
        }

        info.trySetValue {
            info.setSearchSuggestion(try extractor.getSearchSuggestion())
        }

        info.trySetValue {
            info.setIsCorrectedSearch(try extractor.isCorrectedSearch())
        }

        info.trySetValue {
            info.setMetaInfo(try extractor.getMetaInfo())
        }

        let  page = ExtractorHelper.getItemsPageOrLogError(info: info, extractor: extractor)
        info.setRelatedItems(page.getItems())
        info.setNextPage(page.getNextPage())

        return info;
    }

    public static func getMoreItems<S: StreamingService>(service: S, query: SearchQueryHandler, page: Page) throws -> InfoItemsPage<InfoItem> where S.ResultInfoItem == InfoItem {
        return try service.getSearchExtractor(query).getPage(page)
    }

    public func getSearchString() -> String {
        return searchString
    }

    public func getSearchSuggestion() -> String? {
        return searchSuggestion
    }

    public func setIsCorrectedSearch(_ isCorrectedSearch: Bool) {
        self.isCorrectedSearch = isCorrectedSearch
    }

    public func setSearchSuggestion(_ searchSuggestion: String) {
        self.searchSuggestion = searchSuggestion
    }

    public func getMetaInfo() -> List<MetaInfo> {
        return metaInfo
    }

    public func setMetaInfo(_ metaInfo: List<MetaInfo>) {
        self.metaInfo = metaInfo
    }
}

//
//  CommentsInfo.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 20/11/2024.
//


import Foundation

public final class CommentsInfo: ListInfo<CommentsInfoItem> {

    private var commentsExtractor: CommentsExtractor?
    private var commentsDisabled: Bool = false
    private var commentsCount: Int = 0

    private init(serviceId: Int, linkHandler: ListLinkHandler, name: String) {
        super.init(serviceId: serviceId, listUrlIdHandler: linkHandler, name: name)
    }
    
    required init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    public static func getInfo(url: String) throws -> CommentsInfo? {
        guard let service = try? NewPipe.getServiceByUrl(url) else {
            throw ExtractionException("Service not found for URL: \(url)")
        }
        return try getInfo(service: service, url: url)
    }

    public static func getInfo(service: any StreamingService, url: String) throws -> CommentsInfo? {
        guard let commentsExtractor = try? service.getCommentsExtractor(url) else {
            return nil // For services without a comments extractor
        }
        return try getInfo(commentsExtractor: commentsExtractor)
    }

    public static func getInfo(commentsExtractor: CommentsExtractor) throws -> CommentsInfo {
        try commentsExtractor.fetchPage()

        let name = try commentsExtractor.getName()
        let serviceId = commentsExtractor.getServiceId()
        let linkHandler = commentsExtractor.getLinkHandler()

        let commentsInfo = CommentsInfo(serviceId: serviceId, linkHandler: linkHandler, name: name)
        commentsInfo.setCommentsExtractor(commentsExtractor)

        let initialCommentsPage = ExtractorHelper.getItemsPageOrLogError(info: commentsInfo, extractor: commentsExtractor)
        commentsInfo.setCommentsDisabled(try commentsExtractor.isCommentsDisabled())
        commentsInfo.setRelatedItems(initialCommentsPage.getItems())
        do {
            commentsInfo.setCommentsCount(try commentsExtractor.getCommentsCount())
        } catch {
            commentsInfo.addError(error)
        }
        commentsInfo.setNextPage(initialCommentsPage.getNextPage())

        return commentsInfo
    }

    public static func getMoreItems(
        commentsInfo: CommentsInfo,
        page: Page
    ) throws -> InfoItemsPage<CommentsInfoItem> {
        guard let service = try? NewPipe.getService(commentsInfo.getServiceId()) else {
            throw ExtractionException("Service not found for serviceId: \(commentsInfo.getServiceId())")
        }
        return try getMoreItems(service: service, url: commentsInfo.getUrl(), page: page)
    }

    public static func getMoreItems(
        service: any StreamingService,
        commentsInfo: CommentsInfo,
        page: Page
    ) throws -> InfoItemsPage<CommentsInfoItem> {
        return try getMoreItems(service: service, url: commentsInfo.getUrl(), page: page)
    }

    public static func getMoreItems(
        service: any StreamingService,
        url: String,
        page: Page
    ) throws -> InfoItemsPage<CommentsInfoItem> {
        guard let commentsExtractor = try? service.getCommentsExtractor(url) else {
            throw ExtractionException("No CommentsExtractor for URL: \(url)")
        }
        return try commentsExtractor.getPage(page)
    }

    public func getCommentsExtractor() -> CommentsExtractor? {
        return commentsExtractor
    }

    public func setCommentsExtractor(_ extractor: CommentsExtractor?) {
        self.commentsExtractor = extractor
    }

    public func isCommentsDisabled() -> Bool {
        return commentsDisabled
    }

    public func setCommentsDisabled(_ disabled: Bool) {
        self.commentsDisabled = disabled
    }

    public func getCommentsCount() -> Int {
        return commentsCount
    }

    public func setCommentsCount(_ count: Int) {
        self.commentsCount = count
    }
}

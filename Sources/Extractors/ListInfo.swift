//
//  ListInfo.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 18/11/2024.
//


/**
 * Represents a list of items with related information like filters, sorting, and pagination.
 */
public class ListInfo<T: InfoItem>: Info {
    // MARK: - Properties
    private var relatedItems: [T] = []
    private var nextPage: Page? = nil
    private let contentFilters: [String]
    private let sortFilter: String

    // MARK: - Initializers
    public init(
        serviceId: Int,
        id: String,
        url: String,
        originalUrl: String,
        name: String,
        contentFilters: [String],
        sortFilter: String
    ) {
        self.contentFilters = contentFilters
        self.sortFilter = sortFilter
        super.init(serviceId: serviceId, id: id, url: url, originalUrl: originalUrl, name: name)
    }

    public init(serviceId: Int, listUrlIdHandler: ListLinkHandler, name: String) {
        self.contentFilters = listUrlIdHandler.getContentFilters()
        self.sortFilter = listUrlIdHandler.getSortFilter()
        super.init(serviceId: serviceId, linkHandler: listUrlIdHandler, name: name)
    }
    
    required init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    // MARK: - Methods
    public func getRelatedItems() -> [T] {
        return relatedItems
    }

    public func setRelatedItems(_ relatedItems: [T]) {
        self.relatedItems = relatedItems
    }

    public func hasNextPage() -> Bool {
        return Page.isValid(nextPage)
    }

    public func getNextPage() -> Page? {
        return nextPage
    }

    public func setNextPage(_ page: Page?) {
        self.nextPage = page
    }

    public func getContentFilters() -> [String] {
        return contentFilters
    }

    public func getSortFilter() -> String {
        return sortFilter
    }
}

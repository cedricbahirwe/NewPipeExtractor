//
//  ListExtractor.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 17/11/2024.
//

import Foundation

// MARK: - Constants

public enum ListExtractorConstants {
    /// Constant that should be returned whenever a list has an unknown number of items.
    public static let ITEM_COUNT_UNKNOWN: Int64 = -1

    /// Constant that should be returned whenever a list has an infinite number of items.
    /// For example, a YouTube mix.
    public static let ITEM_COUNT_INFINITE: Int64 = -2

    /// Constant that should be returned whenever a list has an unknown number of items bigger than 100.
    public static let ITEM_COUNT_MORE_THAN_100: Int64 = -3
}

public enum InfoItemsPageConstants {
    /// An empty representation of an `InfoItemsPage`.
    static let EMPTY = InfoItemsPage<InfoItem>(
        itemsList: [],
        nextPage: nil,
        errors: []
    )
}

/// Base class for extractors that have a list (e.g., playlists, users).
/// - Parameter R: The info item type this list extractor provides.
public class ListExtractor<R: InfoItem>: Extractor {
    // MARK: - Initializer

    /// Initializes the list extractor with the specified service and link handler.
    /// - Parameters:
    ///   - service: The streaming service.
    ///   - linkHandler: The link handler for the list.
    init(service: any StreamingService, linkHandler: ListLinkHandler) {
        super.init(service: service, linkHandler: linkHandler)
    }

    // MARK: - Abstract Methods

    /// A page corresponding to the initial page where the items are from the initial request
    /// and the nextPage relative to it.
    ///
    /// - Throws: `IOException` or `ExtractionException` if an error occurs during extraction.
    /// - Returns: An `InfoItemsPage` corresponding to the initial page.
    func getInitialPage() throws -> InfoItemsPage<R> {
        fatalError("getInitialPage() must be overridden by subclasses")
    }

    /// Gets a list of items corresponding to the specific requested page.
    ///
    /// - Parameter page: The page to retrieve.
    /// - Throws: `IOException` or `ExtractionException` if an error occurs during extraction.
    /// - Returns: An `InfoItemsPage` corresponding to the requested page.
    func getPage(_ page: Page) throws -> InfoItemsPage<R> {
        fatalError("getPage(_:) must be overridden by subclasses")
    }

    // MARK: - Overridden Methods

    /// Returns the link handler as a `ListLinkHandler`.
    /// - Returns: The `ListLinkHandler` for the list extractor.
    public override func getLinkHandler() -> ListLinkHandler {
        return super.getLinkHandler() as! ListLinkHandler
    }
}



// MARK: - Inner Class

/// A class that wraps a list of gathered items and eventual errors,
/// and contains a field pointing to the next available page.
/// - Parameter T: The info item type that this page stores and provides.
public class InfoItemsPage<T: InfoItem>: @unchecked Sendable {

    // MARK: - Static Properties

    /// A convenient method that returns an empty page.
    /// - Returns: A type-safe page with the list of items and errors empty, and the next page set to `nil`.
    static func emptyPage<U: InfoItem>() -> InfoItemsPage<U> {
        return InfoItemsPageConstants.EMPTY as! InfoItemsPage<U>
    }

    // MARK: - Properties

    /// The current list of items in this page.
    private let itemsList: [T]

    /// URL pointing to the next page relative to this one.
    private let nextPage: Page?

    /// Errors that occurred during the extraction.
    private let errors: [Error]

    // MARK: - Initializers

    /// Initializes an `InfoItemsPage` using a collector and the next page.
    /// - Parameters:
    ///   - collector: The collector containing items and errors.
    ///   - nextPage: The next page relative to this one.
    public convenience init<E: InfoItemExtractor>(collector: InfoItemsCollector<T, E>, nextPage: Page?) {
        self.init(itemsList: collector.getItems(), nextPage: nextPage, errors: collector.getErrors())
    }

    /// Initializes an `InfoItemsPage` with a list of items, a next page, and a list of errors.
    /// - Parameters:
    ///   - itemsList: The list of items.
    ///   - nextPage: The next page relative to this one.
    ///   - errors: The list of errors.
    init(itemsList: [T], nextPage: Page?, errors: [Error]) {
        self.itemsList = itemsList
        self.nextPage = nextPage
        self.errors = errors
    }

    // MARK: - Methods

    /// Checks whether there is a next page.
    /// - Returns: `true` if there is a next page; otherwise, `false`.
    func hasNextPage() -> Bool {
        return Page.isValid(nextPage)
    }

    /// Gets the list of items in this page.
    /// - Returns: The list of items.
    func getItems() -> [T] {
        return itemsList
    }

    /// Gets the next page relative to this one.
    /// - Returns: The next page, or `nil` if there is no next page.
    func getNextPage() -> Page? {
        return nextPage
    }

    /// Gets the list of errors that occurred during extraction.
    /// - Returns: The list of errors.
    func getErrors() -> [Error] {
        return errors
    }
}

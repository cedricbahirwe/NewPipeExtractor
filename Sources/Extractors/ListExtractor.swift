//
//  ListExtractor.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 17/11/2024.
//

import Foundation

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
    // TODO: - Review these constans as in swift we can use type safety

    /// Constant that should be returned whenever a list has an unknown number of items.
    public static var ITEM_COUNT_UNKNOWN: Int { -1 }
    /// Constant that should be returned whenever a list has an infinite number of items.
    /// For example, a YouTube mix.
    public static var ITEM_COUNT_INFINITE: Int { -2 }

    /// Constant that should be returned whenever a list has an unknown number of items bigger than 100.
//    public static var ITEM_COUNT_MORE_THAN_100: Int { -3 }

    // MARK: - Initializer

    public init(_ service: StreamingService, _ linkHandler: ListLinkHandler) {
        super.init(service, linkHandler)
    }

    // MARK: - Abstract Methods

    /// A ``InfoItemsPage`` corresponding to the initial page
    /// where the items are from the initial request and the nextPage relative to it.
    ///
    /// - Returns: An ``InfoItemsPage`` corresponding to the initial page.
    public func getInitialPage() throws(IOExtractionException) -> InfoItemsPage<R> {
        fatalError("getInitialPage() must be overridden by subclasses")
    }

    /// Gets a list of items corresponding to the specific requested page.
    ///
    /// - Parameter ``Page``:  any page got from the exclusive implementation of the list extractor
    /// - Throws: `IOException` or `ExtractionException` if an error occurs during extraction.
    /// - Returns: An ``InfoItemsPage`` corresponding to the requested page.
    /// - SeeAlso: ``InfoItemsPage/getNextPage()``
    public func getPage(_ page: Page) throws -> InfoItemsPage<R> {
        fatalError("getPage(_:) must be overridden by subclasses")
    }

    public override func getLinkHandler() -> ListLinkHandler {
        super.getLinkHandler() as! ListLinkHandler
    }
}

//extension ListExtractor {
//    public class InfoItemsPage<T: InfoItem> {
//        // Static EMPTY page for InfoItem
//        private static let EMPTY = InfoItemsPage<InfoItem>(
//            itemsList: [],
//            nextPage: nil,
//            errors: []
//        )
//
//        /// A convenient method that returns a representation of an empty page.
//        static func emptyPage<U: InfoItem>() -> InfoItemsPage<U> {
//            return EMPTY as! InfoItemsPage<U>
//        }
//
//        /// The current list of items of this page
//        private let itemsList: [T]
//
//        /// Url pointing to the next page relative to this one
//        private let nextPage: Page?
//
//        /// Errors that happened during the extraction
//        private let errors: [Error]
//
//        init(itemsList: [T], nextPage: Page?, errors: [Error]) {
//            self.itemsList = itemsList
//            self.nextPage = nextPage
//            self.errors = errors
//        }
//
//        convenience init(collector: InfoItemsCollector<T, Any>, nextPage: Page?) {
//            self.init(
//                itemsList: collector.getItems(),
//                nextPage: nextPage,
//                errors: collector.getErrors()
//            )
//        }
//
//        func hasNextPage() -> Bool {
//            return Page.isValid(nextPage)
//        }
//
//        func getItems() -> [T] {
//            return itemsList
//        }
//
//        func getNextPage() -> Page? {
//            return nextPage
//        }
//
//        func getErrors() -> [Error] {
//            return errors
//        }
//    }
//}



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
    public func getNextPage() -> Page? {
        return nextPage
    }

    /// Gets the list of errors that occurred during extraction.
    /// - Returns: The list of errors.
    func getErrors() -> [Error] {
        return errors
    }
}

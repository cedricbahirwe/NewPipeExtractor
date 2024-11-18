//
//  ExtractorHelper.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 18/11/2024.
//


import Foundation

/// A utility class for handling extractors and logging errors.
public enum ExtractorHelper {
    /// Get an `InfoItemsPage` or log an error if it fails.
    ///
    /// - Parameters:
    ///   - info: The `Info` object to associate errors with.
    ///   - extractor: The `ListExtractor` to use for fetching the initial page.
    /// - Returns: An `InfoItemsPage` of the specified type or an empty page if an error occurs.
    public static func getItemsPageOrLogError<T: InfoItem>(
        info: Info,
        extractor: ListExtractor<T>
    ) -> InfoItemsPage<T> {
        do {
            let page = try extractor.getInitialPage()
            info.addAllErrors(page.getErrors())
            return page
        } catch {
            info.addError(error)
            return InfoItemsPage<T>.emptyPage()
        }
    }

    /// Get related items or log an error if it fails.
    ///
    /// - Parameters:
    ///   - info: The `StreamInfo` object to associate errors with.
    ///   - extractor: The `StreamExtractor` to use for fetching related items.
    /// - Returns: A list of related `InfoItem` objects or an empty list if an error occurs.
    public static func getRelatedItemsOrLogError(
        info: StreamInfo,
        extractor: StreamExtractor
    ) -> [InfoItem] {
        do {
            guard let collector = try extractor.getRelatedItems() else {
                return []
            }
            info.addAllErrors(collector.getErrors())
            return collector.getItems() 
        } catch {
            info.addError(error)
            return []
        }
    }

    /// Get related videos or log an error. Deprecated in favor of `getRelatedItemsOrLogError`.
    ///
    /// - Parameters:
    ///   - info: The `StreamInfo` object to associate errors with.
    ///   - extractor: The `StreamExtractor` to use for fetching related videos.
    /// - Returns: A list of related `InfoItem` objects or an empty list if an error occurs.
    @available(*, deprecated, message: "Use getRelatedItemsOrLogError(_:_:)")
    public static func getRelatedVideosOrLogError(
        info: StreamInfo,
        extractor: StreamExtractor
    ) -> [InfoItem] {
        return getRelatedItemsOrLogError(info: info, extractor: extractor)
    }
}

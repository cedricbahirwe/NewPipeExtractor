//
//  Collector.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 16/11/2024.
//

import Foundation

/// Collectors are used to simplify the collection of information from extractors
/// - Item: The type of the item being collected
/// - Extractor: The type of the extractor used for collecting information
public protocol Collector {
    associatedtype I
    associatedtype E

    /// Try to add an extractor to the collection
    /// - Parameter extractor: The extractor to add
    func commit(extractor: E)

    /// Try to extract the item from an extractor without adding it to the collection
    /// - Parameter extractor: The extractor to use
    /// - Returns: The extracted item
    /// - Throws: ParsingError if there is an error extracting the required fields of the item
    func extract(extractor: E) throws -> I

    /// Get all items
    /// - Returns: The collected items
    func getItems() -> [I]

    /// Get all errors
    /// - Returns: The errors
    func getErrors() -> [Error]

    /// Reset all collected items and errors
    func reset()
}

//
//  ChannelExtractor.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 18/11/2024.
//

import Foundation

/// Abstract class representing a channel extractor.
open class ChannelExtractor: Extractor {
    public static let unknownSubscriberCount: Int64 = -1

    public init(service: any StreamingService, linkHandler: ListLinkHandler) {
        super.init(service: service, linkHandler: linkHandler)
    }

    /// Retrieves the avatars associated with the channel.
    /// - Throws: A `ParsingException` if the extraction fails.
    /// - Returns: A list of `Image` objects representing the avatars.
    open func getAvatars() throws -> [Image] {
        fatalError("This method must be overridden")
    }

    /// Retrieves the banners associated with the channel.
    /// - Throws: A `ParsingException` if the extraction fails.
    /// - Returns: A list of `Image` objects representing the banners.
    open func getBanners() throws -> [Image] {
        fatalError("This method must be overridden")
    }

    /// Retrieves the feed URL associated with the channel.
    /// - Throws: A `ParsingException` if the extraction fails.
    /// - Returns: A `String` representing the feed URL.
    open func getFeedUrl() throws -> String {
        fatalError("This method must be overridden")
    }

    /// Retrieves the subscriber count of the channel.
    /// - Throws: A `ParsingException` if the extraction fails.
    /// - Returns: A `Int64` representing the subscriber count.
    open func getSubscriberCount() throws -> Int64 {
        fatalError("This method must be overridden")
    }

    /// Retrieves the description of the channel.
    /// - Throws: A `ParsingException` if the extraction fails.
    /// - Returns: A `String` representing the description.
    open func getDescription() throws -> String {
        fatalError("This method must be overridden")
    }

    /// Retrieves the parent channel's name.
    /// - Throws: A `ParsingException` if the extraction fails.
    /// - Returns: A `String` representing the parent channel's name.
    open func getParentChannelName() throws -> String {
        fatalError("This method must be overridden")
    }

    /// Retrieves the parent channel's URL.
    /// - Throws: A `ParsingException` if the extraction fails.
    /// - Returns: A `String` representing the parent channel's URL.
    open func getParentChannelUrl() throws -> String {
        fatalError("This method must be overridden")
    }

    /// Retrieves the parent channel's avatars.
    /// - Throws: A `ParsingException` if the extraction fails.
    /// - Returns: A list of `Image` objects representing the parent channel's avatars.
    open func getParentChannelAvatars() throws -> [Image] {
        fatalError("This method must be overridden")
    }

    /// Checks if the channel is verified.
    /// - Throws: A `ParsingException` if the extraction fails.
    /// - Returns: A `Bool` indicating whether the channel is verified.
    open func isVerified() throws -> Bool {
        fatalError("This method must be overridden")
    }

    /// Retrieves the tabs associated with the channel.
    /// - Throws: A `ParsingException` if the extraction fails.
    /// - Returns: A list of `ListLinkHandler` objects representing the tabs.
    open func getTabs() throws -> [ListLinkHandler] {
        fatalError("This method must be overridden")
    }

    /// Retrieves the tags associated with the channel.
    /// - Throws: A `ParsingException` if the extraction fails.
    /// - Returns: A list of `String` objects representing the tags. Defaults to an empty list.
    open func getTags() throws -> [String] {
        return []
    }
}

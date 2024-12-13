//
//  ReadyChannelTabListLinkHandler.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 13/12/2024.
//

import Foundation

public class ReadyChannelTabListLinkHandler: ListLinkHandler {

    public typealias ChannelTabExtractorBuilder = (any StreamingService, ListLinkHandler) -> ChannelTabExtractor

    private let extractorBuilder: ChannelTabExtractorBuilder

    /// Initializes a new `ReadyChannelTabListLinkHandler`.
    ///
    /// - Parameters:
    ///   - url: The URL of the channel tab.
    ///   - channelId: The ID of the channel.
    ///   - channelTab: The specific tab of the channel.
    ///   - extractorBuilder: A closure to build a `ChannelTabExtractor`.
    public init(
        url: String,
        channelId: String,
        channelTab: String,
        extractorBuilder: @escaping ChannelTabExtractorBuilder
    ) {
        self.extractorBuilder = extractorBuilder
        super.init(url, url, channelId, [channelTab], "")
    }

    /// Builds and returns a `ChannelTabExtractor` for the given streaming service.
    ///
    /// - Parameter service: The streaming service for which to build the extractor.
    /// - Returns: A `ChannelTabExtractor` instance.
    public func getChannelTabExtractor(service: any StreamingService) -> ChannelTabExtractor {
        return extractorBuilder(service, ListLinkHandler(handler: self))
    }
}

//
//  PeertubeSepiaStreamInfoItemExtractor.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 16/11/2024.
//

import Foundation

/// A `StreamInfoItem` collected from SepiaSearch.
public class PeertubeSepiaStreamInfoItemExtractor: PeertubeStreamInfoItemExtractor {

    /// Initializes a new `PeertubeSepiaStreamInfoItemExtractor` with the given JSON item and base URL.
    ///
    /// - Parameters:
    ///   - item: The JSON object representing the stream info item.
    ///   - baseUrl: The base URL for the PeerTube instance.
    override init(item: JsonObject, baseUrl: String) {
        super.init(item: item, baseUrl: baseUrl)

        let embedUrl = super.item.getString("embedUrl") ?? ""
        let embedPath = super.item.getString("embedPath") ?? ""
        let itemBaseUrl = embedUrl.replacingOccurrences(of: embedPath, with: "")
        setBaseUrl(baseUrl: itemBaseUrl)

        // Usually, all videos, pictures, and other content are hosted on the instance,
        // or can be accessed by the same URL path if the instance with baseUrl federates the one
        // where the video is actually uploaded. But it can't be accessed with Sepiasearch, so we
        // use the item's instance as base URL.
    }
}

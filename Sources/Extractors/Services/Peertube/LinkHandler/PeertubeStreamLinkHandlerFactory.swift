//
//  PeertubeStreamLinkHandlerFactory.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 16/11/2024.
//

import Foundation

public final class PeertubeStreamLinkHandlerFactory: LinkHandlerFactory, Sendable {
    public static let shared: PeertubeStreamLinkHandlerFactory = PeertubeStreamLinkHandlerFactory()

    private static let ID_PATTERN: String = "(/w/|(/videos/(watch/|embed/)?))(?!p/)([^/?&#]*)"

    // we exclude p/ because /w/p/ is playlist, not video
    public static let VIDEO_API_ENDPOINT: String = "/api/v1/videos/";

    // From PeerTube 3.3.0, the default path is /w/.
    // We still use /videos/watch/ for compatibility reasons:
    // /videos/watch/ is still accepted by >=3.3.0 but /w/ isn't by <3.3.0
    private static let VIDEO_PATH: String = "/videos/watch/";

    private init() {}

    public func getUrl(_ id: String) throws -> String {
        try getUrl(id, ServiceList.PeerTube.getBaseUrl());
    }

    public func getUrl(_ id: String, _ baseUrl: String) throws -> String {
        return baseUrl + PeertubeStreamLinkHandlerFactory.VIDEO_PATH + id
    }

    public func getId(_ url: String) throws -> String {
        try Parser.matchGroup(pattern: PeertubeStreamLinkHandlerFactory.ID_PATTERN, input: url, group: 4)
    }

    public func onAcceptUrl(_ url: String) throws -> Bool {
        if url.contains("/playlist/") {
            return false
        }

        do {
            guard let urlType =  URL(string: url) else {
                throw URLError(.badURL)
            }
            _ = try getId(url)
            return true
        } catch is URLError {
            return false
        }
    }

}

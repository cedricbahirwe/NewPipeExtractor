//
//  PeertubeChannelLinkHandlerFactory.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 16/11/2024.
//

import Foundation

public final class PeertubeChannelLinkHandlerFactory: ListLinkHandlerFactory, Sendable {
    public static let shared = PeertubeChannelLinkHandlerFactory()

    private static let idPattern = "((accounts|a)|(video-channels|c))/([^/?&#]*)"
    private static let idUrlPattern = "/((accounts|a)|(video-channels|c))/([^/?&#]*)"
    public static let apiEndpoint = "/api/v1/"

    private init() {}

    public func getId(_ url: String) throws -> String {
        fixId(try Parser.matchGroup(pattern: Self.idUrlPattern, input: url, group: 0))
    }

    public func getUrl(id: String, contentFilters: [String], sortFilter: String) throws -> String {
        try getUrl(id: id, contentFilters: contentFilters, sortFilter: sortFilter, baseUrl: ServiceList.PeerTube.getBaseUrl())
    }

    public func getUrl(id: String, contentFilters: [String], sortFilter: String, baseUrl: String) throws -> String {
        if id.range(of: Self.idPattern, options: .regularExpression) != nil {
            return baseUrl + "/" + fixId(id)
        } else {
            // This is needed for compatibility with older versions were we didn't support
            // video channels yet
            return baseUrl + "/accounts/" + id
        }
    }

    public func onAcceptUrl(_ url: String) throws -> Bool {
        guard let _ = URL(string: url) else { return false }
        return url.contains("/accounts/") || url.contains("/a/")
            || url.contains("/video-channels/") || url.contains("/c/")
    }

    /**
     Fix id

     a/:accountName and c/:channelName ids are supported
     by the PeerTube web client (>= v3.3.0)
     but not by the API.
     * @param id the id to fix
     * @return the fixed id
     */
    private func fixId(_ id: String) -> String {
        let cleanedId = id.hasPrefix("/") ? String(id.dropFirst()) : id
        if cleanedId.hasPrefix("a/") {
            return "accounts" + cleanedId.dropFirst(1)
        } else if cleanedId.hasPrefix("c/") {
            return "video-channels" + cleanedId.dropFirst(1)
        }
        return cleanedId
    }
}

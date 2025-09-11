//
//  YoutubePlaylistLinkHandlerFactory.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 11/09/2025.
//

import Foundation

public class YoutubePlaylistLinkHandlerFactory: ListLinkHandlerFactory {
    public let shared = YoutubePlaylistLinkHandlerFactory()

    private init() {}

    public func getUrl(id: String, contentFilters: [String], sortFilter: String) throws(ParsingUnsupportedOperation) -> String {
        return "https://www.youtube.com/playlist?list=" + id
    }

    public func getId(_ url: String) throws(ParsingUnsupportedOperation) -> String {
        do {
            let urlObj = try Utils.stringToURL(url)
        } catch {

        }
    }


    public func onAcceptUrl(_ url: String) throws(ParsingException) -> Bool {
        do {
            _ = try getId(url)
            return true
        } catch {
            return false
        }
    }
}

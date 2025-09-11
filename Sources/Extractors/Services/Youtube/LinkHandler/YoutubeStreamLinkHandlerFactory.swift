//
//  YoutubeStreamLinkHandlerFactory.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 11/09/2025.
//

import Foundation

public final class YoutubeStreamLinkHandlerFactory: LinkHandlerFactory {
    nonisolated(unsafe) private static let YOUTUBE_VIDEO_ID_REGEX_PATTERN = /^([a-zA-Z0-9_-]{11})/
    @MainActor public static let shared = YoutubeStreamLinkHandlerFactory()

    private let SUBPATHS: [String] = ["embed/", "live/", "shorts/", "watch/", "v/", "w/"]

    private init() {}

    public static func extractId(_ id: String?) -> String? {
        guard let id else { return nil }

        if let match = try? YOUTUBE_VIDEO_ID_REGEX_PATTERN.firstMatch(in: id) {
            return String(match.1)
        }
        return nil
    }

    public static func assertIsId(_ id: String?) throws(ParsingException) -> String {
        guard let extractedId = extractId(id) else {
            throw ParsingException("The given string is not a YouTube video ID")
        }
        return extractedId
    }

    public func getUrl(_ id: String) throws(ParsingUnsupportedOperation) -> String {
        return "https://www.youtube.com/watch?v=" + id;
    }

    public func getId(_ url: String) throws(ParsingUnsupportedOperation) -> String {
        let urlString = url
        do {
//            guard
//                let url = URL(string: urlString) else {
//                throw ParsingError.invalidURL
//            }

            guard let components = URLComponents(string: urlString),
                     let scheme = components.scheme else {
                   throw ParsingError.invalidURL
               }

               if scheme == "vnd.youtube" || scheme == "vnd.youtube.launch" {
                   // In Java: getSchemeSpecificPart()
                   // In Swift: that’s basically everything after "<scheme>:"
                   let schemeSpecificPart = urlString.dropFirst(scheme.count + 1)

                   if schemeSpecificPart.hasPrefix("//") {
                       let trimmed = String(schemeSpecificPart.dropFirst(2))

                       if let extractedId = YoutubeStreamLinkHandlerFactory.extractId(trimmed) {
                           return extractedId
                       }

                       // fallback to https
                       return "https:" + schemeSpecificPart
                   } else {
                       return try YoutubeStreamLinkHandlerFactory.assertIsId(String(schemeSpecificPart))
                   }
               }

        } catch { }
fatalError()

    }

    public func onAcceptUrl(_ url: String) throws(ParsingException) -> Bool {
        fatalError()
    }

    public func getUrl(_ id: String, _ baseUrl: String) throws(ParsingUnsupportedOperation) -> String {
        fatalError()
    }

}

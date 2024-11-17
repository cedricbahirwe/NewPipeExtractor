//
//  PeertubeStreamInfoItemExtractor.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 16/11/2024.
//

import Foundation

/// A class that extracts stream information for PeerTube.
public class PeertubeStreamInfoItemExtractor: StreamInfoItemExtractor {
    // MARK: - Properties

    /// The JSON object representing the stream item.
    let item: JsonObject

    /// The base URL for constructing resource URLs.
    private var baseUrl: String

    // MARK: - Initializer

    /// Initializes the extractor with a JSON object and a base URL.
    /// - Parameters:
    ///   - item: The JSON object representing the stream item.
    ///   - baseUrl: The base URL for constructing resource URLs.
    init(item: JsonObject, baseUrl: String) {
        self.item = item
        self.baseUrl = baseUrl
    }

    // MARK: - StreamInfoItemExtractor Protocol Methods

    /// Gets the URL of the stream.
    /// - Throws: `ParsingException` if the URL cannot be parsed.
    /// - Returns: The URL of the stream.
    public func getUrl() throws -> String {
        let uuid = try JsonUtils.getString(json: item, path: "uuid")
        return try ServiceList.PeerTube.getStreamLHFactory().fromId(uuid, baseUrl).getUrl()
    }

    /// Gets the thumbnails associated with the stream.
    /// - Throws: `ParsingException` if thumbnails cannot be retrieved.
    /// - Returns: A list of `Image` objects representing thumbnails.
    public func getThumbnails() throws -> [Image] {
        return PeertubeParsingHelper.getThumbnailsFromPlaylistOrVideoItem(baseUrl, item)
    }

    /// Gets the name of the stream.
    /// - Throws: `ParsingException` if the name cannot be retrieved.
    /// - Returns: The name of the stream.
    public func getName() throws -> String {
        return try JsonUtils.getString(json: item, path: "name")
    }

    /// Determines if the stream is an ad.
    /// - Returns: `false` (ads are not supported).
    public func isAd() -> Bool {
        return false
    }

    /// Gets the view count of the stream.
    /// - Returns: The view count as a `Int64`.
    public func getViewCount() -> Int64 {
        return item.getLong("views")
    }

    /// Gets the URL of the uploader.
    /// - Throws: `ParsingException` if the uploader URL cannot be retrieved.
    /// - Returns: The uploader's URL.
    public func getUploaderUrl() throws -> String {
        let name = try JsonUtils.getString(json: item, path: "account.name")
        let host = try JsonUtils.getString(json: item, path: "account.host")
        return try ServiceList.PeerTube.getChannelLHFactory()
            .fromId("accounts/\(name)@\(host)", baseUrl)
            .getUrl()
    }

    /// Gets the uploader's avatars.
    /// - Returns: A list of `Image` objects representing the uploader's avatars.
    public func getUploaderAvatars() -> [Image] {
        return PeertubeParsingHelper.getAvatarsFromOwnerAccountOrVideoChannelObject(baseUrl, item.getObject("account"))
    }

    /// Determines if the uploader is verified.
    /// - Returns: `false` (verification is not supported).
    public func isUploaderVerified() -> Bool {
        return false
    }

    /// Gets the name of the uploader.
    /// - Throws: `ParsingException` if the uploader name cannot be retrieved.
    /// - Returns: The uploader's name.
    public func getUploaderName() throws -> String {
        return try JsonUtils.getString(json: item, path: "account.displayName")
    }

    /// Gets the textual upload date of the stream.
    /// - Throws: `ParsingException` if the upload date cannot be retrieved.
    /// - Returns: The textual representation of the upload date.
    public func getTextualUploadDate() throws -> String? {
        return try JsonUtils.getString(json: item, path: "publishedAt")
    }

    /// Gets the upload date of the stream as a `DateWrapper`.
    /// - Throws: `ParsingException` if the upload date cannot be retrieved.
    /// - Returns: A `DateWrapper` containing the upload date, or `nil` if not available.
    public func getUploadDate() throws -> DateWrapper? {
        guard let textualUploadDate = try? getTextualUploadDate() else {
            return nil
        }
        return DateWrapper(date: try PeertubeParsingHelper.parseDateFrom(textualUploadDate))
    }

    /// Gets the type of the stream.
    /// - Returns: The type of the stream (`.liveStream` or `.videoStream`).
    public func getStreamType() -> StreamType {
        return item.getBoolean("isLive") ? .liveStream : .videoStream
    }

    /// Gets the duration of the stream.
    /// - Returns: The duration in seconds.
    public func getDuration() -> Int64 {
        return item.getLong("duration")
    }

    // MARK: - Protected Methods

    /// Sets the base URL for constructing resource URLs.
    /// - Parameter baseUrl: The new base URL.
    func setBaseUrl(baseUrl: String) {
        self.baseUrl = baseUrl
    }
}

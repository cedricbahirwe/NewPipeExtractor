//
//  PeertubeParsingHelper.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 16/11/2024.
//

import Foundation

//final class PeertubeParsingHelper {
//    static let START_KEY = "start"
//    static let COUNT_KEY = "count"
//    static let ITEMS_PER_PAGE = 12
//    static let START_PATTERN = "start=(\\d*)"
//
//    private init() {}
//
//    static func validate(json: [String: Any]) throws {
//        if let error = json["error"] as? String, !error.isEmpty {
//            throw ContentNotAvailableException(error)
//        }
//    }
//
//    static func parseDate(from textualUploadDate: String) throws -> Date {
//        let dateFormatter = ISO8601DateFormatter()
//        if let date = dateFormatter.date(from: textualUploadDate) {
//            return date
//        } else {
//            throw ParsingException("Could not parse date: \"\(textualUploadDate)\"")
//        }
//    }
//
//    static func getNextPage(prevPageUrl: String, total: Int) -> Page? {
//        let prevStart: String
//        do {
//            prevStart = try Parser.matchGroup1(pattern: START_PATTERN, input: prevPageUrl)
//        } catch {
//            return nil
//        }
//
//        guard let prevStartInt = Int(prevStart) else {
//            return nil
//        }
//
//        let nextStart = prevStartInt + ITEMS_PER_PAGE
//        if nextStart >= total {
//            return nil
//        }
//
//        let newUrl = prevPageUrl.replacingOccurrences(of: "\(START_KEY)=\(prevStart)",
//                                                      with: "\(START_KEY)=\(nextStart)")
//        return Page(url: newUrl)
//    }
//
//    static func collectItems<I: InfoItem, E: InfoItemExtractor>(from collector: InfoItemsCollector<I, E>, json: [String: Any], baseUrl: String, sepia: Bool = false) throws {
//        guard let contents = json["data"] as? [[String: Any]] else {
//            throw ParsingException("Unable to extract list info")
//        }
//
//        for var item in contents {
//            if let video = item["video"] as? [String: Any] {
//                item = video
//            }
//
//            let isPlaylistInfoItem = item["videosLength"] != nil
//            let isChannelInfoItem = item["followersCount"] != nil
//
//            let extractor: InfoItemExtractor
//            if sepia {
//                extractor = PeertubeSepiaStreamInfoItemExtractor(item: item, baseUrl: baseUrl)
//            } else if isPlaylistInfoItem {
//                extractor = PeertubePlaylistInfoItemExtractor(item: item, baseUrl: baseUrl)
//            } else if isChannelInfoItem {
//                extractor = PeertubeChannelInfoItemExtractor(item: item, baseUrl: baseUrl)
//            } else {
//                extractor = PeertubeStreamInfoItemExtractor(item: item, baseUrl: baseUrl)
//            }
//
//            collector.commit(extractor: extractor)
//        }
//    }
//
//    static func getAvatars(from ownerAccountOrVideoChannelObject: [String: Any], baseUrl: String) -> [Image] {
//        return getImages(from: ownerAccountOrVideoChannelObject, baseUrl: baseUrl, jsonArrayName: "avatars", jsonObjectName: "avatar")
//    }
//
//    static func getBanners(from ownerAccountOrVideoChannelObject: [String: Any], baseUrl: String) -> [Image] {
//        return getImages(from: ownerAccountOrVideoChannelObject, baseUrl: baseUrl, jsonArrayName: "banners", jsonObjectName: "banner")
//    }
//
//    static func getThumbnails(from playlistOrVideoItemObject: [String: Any], baseUrl: String) -> [Image] {
//        var images = [Image]()
//
//        if let thumbnailPath = playlistOrVideoItemObject["thumbnailPath"] as? String, !thumbnailPath.isEmpty {
//            images.append(Image(url: baseUrl + thumbnailPath, height: nil, width: nil, resolutionLevel: .low))
//        }
//
//        if let previewPath = playlistOrVideoItemObject["previewPath"] as? String, !previewPath.isEmpty {
//            images.append(Image(url: baseUrl + previewPath, height: nil, width: nil, resolutionLevel: .medium))
//        }
//
//        return images
//    }
//
//    private static func getImages(from object: [String: Any], baseUrl: String, jsonArrayName: String, jsonObjectName: String) -> [Image] {
//        if let jsonArray = object[jsonArrayName] as? [[String: Any]] {
//            return jsonArray.compactMap { imageObject in
//                guard let path = imageObject["path"] as? String, !path.isEmpty else {
//                    return nil
//                }
//                return Image(url: baseUrl + path, height: nil, width: imageObject["width"] as? Int, resolutionLevel: .unknown)
//            }
//        }
//
//        if let jsonObject = object[jsonObjectName] as? [String: Any], let path = jsonObject["path"] as? String, !path.isEmpty {
//            return [Image(url: baseUrl + path, height: nil, width: jsonObject["width"] as? Int, resolutionLevel: .unknown)]
//        }
//
//        return []
//    }
//}


/// A helper class for parsing PeerTube-related data.
final class PeertubeParsingHelper {
    // MARK: - Constants

    public static let START_KEY = "start"
    public static let COUNT_KEY = "count"
    public static let ITEMS_PER_PAGE = 12
    public static let START_PATTERN = "start=(\\d*)"

    // MARK: - Initializer

    /// Private initializer to prevent instantiation.
    private init() {}

    // MARK: - Static Methods

    /// Validates the given JSON object.
    /// - Parameter json: The JSON object to validate.
    /// - Throws: `ContentNotAvailableException` if the JSON contains an error field.
    public static func validate(_ json: JsonObject) throws {
        guard let error = json.getString("error"),
        Utils.isBlank(error) else {
            return
        }
        throw ContentNotAvailableException(error)
    }

    /// Parses an `OffsetDateTime` from a textual upload date.
    /// - Parameter textualUploadDate: The string representation of the date.
    /// - Throws: `ParsingException` if the date cannot be parsed.
    /// - Returns: The parsed `OffsetDateTime`.
    public static func parseDateFrom(_ textualUploadDate: String) throws -> Date {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        guard let date = formatter.date(from: textualUploadDate) else {
            throw ParsingException("Could not parse date: \"\(textualUploadDate)\"")
        }
        return date
    }

    /// Gets the next page based on the previous page URL and the total number of items.
    /// - Parameters:
    ///   - prevPageUrl: The URL of the previous page.
    ///   - total: The total number of items.
    /// - Returns: A `Page` object for the next page, or `nil` if there are no more pages.
    public static func getNextPage(_ prevPageUrl: String, _ total: Int64) -> Page? {
        let prevStart: String
        do {
            prevStart = try Parser.matchGroup1(pattern: START_PATTERN, input: prevPageUrl)
        } catch {
            return nil
        }

        if Utils.isBlank(prevStart) {
            return nil
        }

        let nextStart: Int64
        if let parsedStart = Int64(prevStart) {
            nextStart = parsedStart + Int64(ITEMS_PER_PAGE)
        } else {
            return nil
        }

        if nextStart >= total {
            return nil
        } else {
            let nextPageUrl = prevPageUrl.replacingOccurrences(of: "\(START_KEY)=\(prevStart)", with: "\(START_KEY)=\(nextStart)")
            return Page(url: nextPageUrl)
        }
    }

    /// Collects items from the given JSON object.
    /// - Parameters:
    ///   - collector: The `InfoItemsCollector` used to collect items.
    ///   - json: The JSON object containing the items.
    ///   - baseUrl: The base URL for the items.
    /// - Throws: `ParsingException` if items cannot be extracted.
    public static func collectItemsFrom<I: InfoItem, E: InfoItemExtractor>(
        _ collector: InfoItemsCollector<I, E>,
        _ json: JsonObject,
        _ baseUrl: String
    ) throws {
        try collectItemsFrom(collector, json, baseUrl, false)
    }

    /// Collect items from the given JSON object with the given collector.
    ///
    /// <p>
    /// Supported info item types are streams with their Sepia variant, channels and playlists.
    /// </p>
    ///
    /// - Parameters:
    ///   - collector: The collector used to collect information.
    ///   - json: The JSON response to retrieve data from.
    ///   - baseUrl: The base URL of the instance.
    ///   - sepia: Whether to use `PeertubeSepiaStreamInfoItemExtractor` to extract streams or `PeertubeStreamInfoItemExtractor` otherwise.
    /// - Throws: `ParsingException` if items cannot be extracted.
    public static func collectItemsFrom<I: InfoItem, E: InfoItemExtractor>(
        _ collector: InfoItemsCollector<I, E>,
        _ json: JsonObject,
        _ baseUrl: String,
        _ sepia: Bool
    ) throws {
        guard let contents = try JsonUtils.getValue(json, path: "data") as? [JsonObject] else {
            throw ParsingException("Unable to extract list info")
        }

        for var item in contents {
            // PeerTube playlists have the stream info encapsulated in a "video" object
            if item.has("video") {
                item = item.getObject("video")
            }

            let isPlaylistInfoItem = item.has("videosLength")
            let isChannelInfoItem = item.has("followersCount")

            let extractor: InfoItemExtractor
            if sepia {
                extractor = PeertubeSepiaStreamInfoItemExtractor(item: item, baseUrl: baseUrl)
            } else if isPlaylistInfoItem {
                fatalError("PeertubePlaylistInfoItemExtractor not implemented")
                //                extractor = PeertubePlaylistInfoItemExtractor(item, baseUrl)
            } else if isChannelInfoItem {
                fatalError("PeertubeChannelInfoItemExtractor not implemented")
                //                extractor = PeertubeChannelInfoItemExtractor(item, baseUrl)
            } else {
                extractor = PeertubeStreamInfoItemExtractor(item: item, baseUrl: baseUrl)
            }

            collector.commit(extractor: extractor as! E)
        }
    }

    /// Get avatars from an `ownerAccount` or a `videoChannel` `JsonObject`.
    ///
    /// <p>
    /// If the `avatars` `JsonArray` is present and non null or empty, avatars will be
    /// extracted from this array using `getImagesFromAvatarOrBannerArray`.
    /// </p>
    ///
    /// - Parameters:
    ///   - baseUrl: The base URL of the PeerTube instance.
    ///   - ownerAccountOrVideoChannelObject: The `ownerAccount` or `videoChannel` `JsonObject`.
    /// - Returns: An unmodifiable list of `Image`s, which may be empty but never null.
    public static func getAvatarsFromOwnerAccountOrVideoChannelObject(_ baseUrl: String, _ ownerAccountOrVideoChannelObject: JsonObject) -> [Image] {
        return getImagesFromAvatarsOrBanners(baseUrl, ownerAccountOrVideoChannelObject, "avatars", "avatar")
    }

    /// Get banners from a `ownerAccount` or a `videoChannel` `JsonObject`.
    ///
    /// - Parameters:
    ///   - baseUrl: The base URL of the PeerTube instance.
    ///   - ownerAccountOrVideoChannelObject: The `ownerAccount` or `videoChannel` `JsonObject`.
    /// - Returns: An unmodifiable list of `Image`s, which may be empty but never null.
    public static func getBannersFromAccountOrVideoChannelObject(_ baseUrl: String, _ ownerAccountOrVideoChannelObject: JsonObject) -> [Image] {
        return getImagesFromAvatarsOrBanners(baseUrl, ownerAccountOrVideoChannelObject, "banners", "banner")
    }

    /// Get thumbnails from a playlist or a video item `JsonObject`.
    ///
    /// - Parameters:
    ///   - baseUrl: The base URL of the PeerTube instance.
    ///   - playlistOrVideoItemObject: The playlist or the video item `JsonObject`.
    /// - Returns: An unmodifiable list of `Image`s, which may be empty but never null.
    public static func getThumbnailsFromPlaylistOrVideoItem(_ baseUrl: String, _ playlistOrVideoItemObject: JsonObject) -> [Image] {
        var imageList = [Image]()

        if let thumbnailPath = playlistOrVideoItemObject.getString("thumbnailPath"), !Utils.isNullOrEmpty(thumbnailPath) {
            imageList.append(Image(url: baseUrl + thumbnailPath, height: Image.HEIGHT_UNKNOWN, width: Image.WIDTH_UNKNOWN, estimatedResolutionLevel: .low))
        }

        if let previewPath = playlistOrVideoItemObject.getString("previewPath"), !Utils.isNullOrEmpty(previewPath) {
            imageList.append(Image(url: baseUrl + previewPath, height: Image.HEIGHT_UNKNOWN, width: Image.WIDTH_UNKNOWN, estimatedResolutionLevel: .medium))
        }

        return imageList
    }

    /// Utility method to get avatars and banners from video channels and accounts from given name keys.
    ///
    /// - Parameters:
    ///   - baseUrl: The base URL of the PeerTube instance.
    ///   - ownerAccountOrVideoChannelObject: The `ownerAccount` or `videoChannel` `JsonObject`.
    ///   - jsonArrayName: The key name of the `JsonArray` to which extract all images available.
    ///   - jsonObjectName: The key name of the `JsonObject` to which extract a single image.
    /// - Returns: An unmodifiable list of `Image`s, which may be empty but never null.
    private static func getImagesFromAvatarsOrBanners(
        _ baseUrl: String,
        _ ownerAccountOrVideoChannelObject: JsonObject,
        _ jsonArrayName: String,
        _ jsonObjectName: String
    ) -> [Image] {
        let images = ownerAccountOrVideoChannelObject.getArray(jsonArrayName)

        if !Utils.isNullOrEmpty(images) {
            return getImagesFromAvatarOrBannerArray(baseUrl, images)
        }

        let image = ownerAccountOrVideoChannelObject.getObject(jsonObjectName)

        if let path = image.getString("path"), !Utils.isNullOrEmpty(path) {
            return [Image(
                url: baseUrl + path,
                height: Image.HEIGHT_UNKNOWN,
                width: image.getInt("width", defaultValue: Image.WIDTH_UNKNOWN),
                estimatedResolutionLevel: .unknown
            )]
        }

        return []
    }

    /// Get `Image`s from an `avatars` or a `banners` `JsonArray`.
    ///
    /// - Parameters:
    ///   - baseUrl: The base URL of the PeerTube instance from which the `avatarsOrBannersArray` comes from.
    ///   - avatarsOrBannersArray: An `avatars` or `banners` `JsonArray`.
    /// - Returns: An unmodifiable list of `Image`s, which may be empty but never null.
    private static func getImagesFromAvatarOrBannerArray(_ baseUrl: String, _ avatarsOrBannersArray: JsonArray) -> [Image] {
        return avatarsOrBannersArray
            .compactMap({ $0 as? JsonObject })
            .compactMap { image in
                guard let path = image.getString("path"), !Utils.isNullOrEmpty(path) else {
                    return nil
                }
                return Image(url: baseUrl + path, height: Image.HEIGHT_UNKNOWN, width: image.getInt("width", defaultValue: Image.WIDTH_UNKNOWN), estimatedResolutionLevel: .unknown)
            }
    }
}

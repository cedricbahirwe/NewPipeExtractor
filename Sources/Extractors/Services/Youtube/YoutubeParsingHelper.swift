//
//  YoutubeParsingHelper.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 11/09/2025.
//

import Foundation
import SwiftyJSON

public class YoutubeParsingHelper {
    private init() {}

    /// The base URL of requests of the `WEB` clients to the InnerTube internal API.
    public static let YOUTUBEI_V1_URL = "https://www.youtube.com/youtubei/v1/"

    /// The base `URL` of requests of non-web clients to the `InnerTube` internal API.
    public static let YOUTUBEI_V1_GAPIS_URL = "https://youtubei.googleapis.com/youtubei/v1/"

    /// The base URL of YouTube Music.
    private static let YOUTUBE_MUSIC_URL = "https://music.youtube.com"


    /// A parameter to disable pretty-printed response of InnerTube requests, to reduce response sizes.
    ///
    /// Sent in query parameters of the requests.
    public static let DISABLE_PRETTY_PRINT_PARAMETER = "prettyPrint=false"


    /// A parameter sent by official clients named `contentPlaybackNonce`.
    ///
    /// It is sent by official clients on videoplayback requests and InnerTube player requests in most cases.
    ///
    /// It is composed of 16 characters which are generated from
    /// [this alphabet](YoutubeParsingHelper/CONTENT_PLAYBACK_NONCE_ALPHABET), with the use of strong random values
    ///
    /// - SeeAlso: ``YoutubeParsingHelper/generateContentPlaybackNonce()``
    public static let CPN = "cpn"

    public static let VIDEO_ID = "videoId"

    /// A parameter sent by official clients named `contentCheckOk`.
    ///
    /// Setting it to `true` allows us to get streaming data on videos with a warning about what the sensible content they contain.
    public static let CONTENT_CHECK_OK = "contentCheckOk"

    /// A parameter which may be sent by official clients named `racyCheckOk`.
    ///
    /// What this parameter does is not really known, but it seems to be linked to sensitive
    /// contents such as age-restricted content.
    public static let  RACY_CHECK_OK = "racyCheckOk"

    nonisolated(unsafe) private static var clientVersion: String!

    nonisolated(unsafe) private static var youtubeMusicClientVersion: String!

    nonisolated(unsafe) private static var clientVersionExtracted = false

    nonisolated(unsafe) private static var hardcodedClientVersionValid: Bool? = nil


    private static let INNERTUBE_CONTEXT_CLIENT_VERSION_REGEXES: [String] = [
        #"INNERTUBE_CONTEXT_CLIENT_VERSION":"([0-9\.]+?)"#,
        #"innertube_context_client_version":"([0-9\.]+?)"#,
        #"client.version=([0-9\.]+)"#
    ]

    private static let INITIAL_DATA_REGEXES: [String] = [
        #"window\["ytInitialData"\]\s*=\s*(\{.*?\});"#,
        #"var\s*ytInitialData\s*=\s*(\{.*?\});"#
    ]

    private static let CONTENT_PLAYBACK_NONCE_ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"

    nonisolated(unsafe) private static var numberGenerator = SystemRandomNumberGenerator()


    private static let FEED_BASE_CHANNEL_ID = "https://www.youtube.com/feeds/videos.xml?channel_id="

    private static let FEED_BASE_USER = "https://www.youtube.com/feeds/videos.xml?user="

    // TODO: Should I use NSRegularExpression
    nonisolated(unsafe) private static let cWebPattern: Regex = /&c=WEB/
    nonisolated(unsafe) private static let cWebEmbeddedPlayerPattern: Regex = /&c=WEB_EMBEDDED_PLAYER/
    nonisolated(unsafe) private static let cTvHtml5PlayerPattern: Regex = /&c=TVHTML5/
    nonisolated(unsafe) private static let cAndroidPattern: Regex = /&c=ANDROID/
    nonisolated(unsafe) private static let cIosPattern: Regex = /&c=IOS/


    private static let GOOGLE_URLS: Set<String> = ["google.", "m.google.", "www.google."]

    private static let INVIDIOUS_URLS: Set<String> = [
        "invidio.us", "dev.invidio.us",
        "www.invidio.us", "redirect.invidious.io", "invidious.snopyta.org", "yewtu.be",
        "tube.connect.cafe", "tubus.eduvid.org", "invidious.kavin.rocks", "invidious.site",
        "invidious-us.kavin.rocks", "piped.kavin.rocks", "vid.mint.lgbt", "invidiou.site",
        "invidious.fdn.fr", "invidious.048596.xyz", "invidious.zee.li", "vid.puffyan.us",
        "ytprivate.com", "invidious.namazso.eu", "invidious.silkky.cloud", "ytb.trom.tf",
        "invidious.exonip.de", "inv.riverside.rocks", "invidious.blamefran.net", "y.com.cm",
        "invidious.moomoo.me", "yt.cyberhost.uk"]


    private static let YOUTUBE_URLS: Set<String> = ["youtube.com", "www.youtube.com",
               "m.youtube.com", "music.youtube.com"]


    nonisolated(unsafe) private static var consentAccepted: Bool = false

    /// Checks if a URL (possibly cached) is a Google URL.
    /// - Parameter url: The URL to check.
    /// - Returns: True if the URL points to a Google host, false otherwise.
    static func isGoogleURL(_ url: String?) -> Bool {
        guard let cachedUrl = extractCachedUrlIfNeeded(url),
              let u = URL(string: cachedUrl) else {
            return false
        }

        return GOOGLE_URLS.contains { u.host?.starts(with: $0) ?? false }
    }

    static func isYoutubeURL(_ url: URL) -> Bool {
        guard let host = url.host?.lowercased() else { return false }
        return YOUTUBE_URLS.contains(host)
    }

    /// Checks if a URL belongs to a YouTube service domain, such as "youtube-nocookie.com" or "youtu.be".
    /// - Parameter url: The URL to check (non-nil).
    /// - Returns: True if the host matches a known YouTube service host.
    static func isYoutubeServiceURL(_ url: URL) -> Bool {
        guard let host = url.host else { return false }
        return host.caseInsensitiveCompare("www.youtube-nocookie.com") == .orderedSame
            || host.caseInsensitiveCompare("youtu.be") == .orderedSame
    }

    /// Checks if a URL belongs to the Hooktube domain.
    /// - Parameter url: The URL to check (non-nil).
    /// - Returns: True if the host matches "hooktube.com".
    static func isHooktubeURL(_ url: URL) -> Bool {
        guard let host = url.host else { return false }
        return host.caseInsensitiveCompare("hooktube.com") == .orderedSame
    }

    /// Checks if a URL belongs to a known Invidious instance.
    /// - Parameter url: The URL to check (non-nil).
    /// - Returns: True if the host matches one of the known Invidious hosts.
    static func isInvidiousURL(_ url: URL) -> Bool {
        guard let host = url.host?.lowercased() else { return false }
        return INVIDIOUS_URLS.contains(host)
    }

    /// Checks if a URL belongs to the Y2ube service.
    /// - Parameter url: The URL to check (non-nil).
    /// - Returns: True if the host matches "y2u.be".
    static func isY2ubeURL(_ url: URL) -> Bool {
        guard let host = url.host else { return false }
        return host.caseInsensitiveCompare("y2u.be") == .orderedSame
    }

    /// Parses a video duration string, expecting ":" or "." as separators.
    /// - Parameter input: The duration string (non-nil), e.g. "01:23:45" or "01.23.45".
    /// - Throws: `ParsingError` if the string has more than 3 separators or unknown format, or `NumberFormatError` if a unit is not numeric.
    /// - Returns: The total duration in seconds.
    static func parseDurationString(_ input: String) throws(ParsingException) -> Int {
        let splitInput: [String]
        if input.contains(":") {
            splitInput = input.split(separator: ":").map(String.init)
        } else {
            splitInput = input.split(separator: ".").map(String.init)
        }

        let units = [24, 60, 60, 1]
        let offset = units.count - splitInput.count
        if offset < 0 {
            throw ParsingException("Error duration string with unknown format: \(input)")
        }

        var duration = 0
        for i in 0..<splitInput.count {
            let value = convertDurationToInt(splitInput[i])
            duration = units[i + offset] * (duration + value)
        }

        return duration
    }

    /// Tries to convert a duration string to an integer without throwing an exception.
    ///
    /// Helper method for `parseDurationString(_:)`.
    ///
    /// Note: This method is also used as a workaround for cases where YouTube shorts
    /// no longer display any duration in channels.
    ///
    /// - Parameter input: The string to process.
    /// - Returns: The converted integer, or 0 if the conversion failed.
    private static func convertDurationToInt(_ input: String?) -> Int {
        guard let input = input, !input.isEmpty else { return 0 }

        let clearedInput = Utils.removeNonDigitCharacters(input)
        return Int(clearedInput) ?? 0
    }


    public static func getFeedUrl(from channelIdOrUser: String) -> String {
        if channelIdOrUser.hasPrefix("user/") {
            return FEED_BASE_USER + channelIdOrUser.replacingOccurrences(of: "user/", with: "")
        } else if channelIdOrUser.hasPrefix("channel/") {
            return FEED_BASE_CHANNEL_ID + channelIdOrUser.replacingOccurrences(of: "channel/", with: "")
        } else {
            return FEED_BASE_CHANNEL_ID + channelIdOrUser
        }
    }

    /// Parses a textual upload date string into a `Date` with timezone information (UTC).
    /// - Parameter textualUploadDate: The date string to parse.
    /// - Throws: `ParsingError.invalidDate` if the string cannot be parsed.
    /// - Returns: A `Date` representing the parsed date in UTC.
    public static func parseDateFrom(_ textualUploadDate: String) throws(ParsingException) -> Date {
        // Try ISO8601 / full date-time first
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = isoFormatter.date(from: textualUploadDate) {
            return date
        }

        // Fallback: try parsing as just a local date (yyyy-MM-dd)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let date = dateFormatter.date(from: textualUploadDate) {
            return date
        }

        // If both fail, throw parsing error
        throw ParsingException("Could not parse date: \"\(textualUploadDate)\"")
    }

    /// Checks if the given playlist ID is a YouTube Mix (auto-generated playlist).
    /// IDs from a YouTube Mix start with "RD".
    /// - Parameter playlistId: The playlist ID to check.
    /// - Returns: True if the given ID belongs to a YouTube Mix.
    public static func isYoutubeMixId(_ playlistId: String) -> Bool {
        return playlistId.hasPrefix("RD")
    }

    /// Checks if the given playlist ID is a YouTube My Mix (auto-generated playlist).
    /// IDs from a YouTube My Mix start with "RDMM".
    /// - Parameter playlistId: The playlist ID to check.
    /// - Returns: True if the given ID belongs to a YouTube My Mix.
    public static func isYoutubeMyMixId(_ playlistId: String) -> Bool {
        return playlistId.hasPrefix("RDMM")
    }

    /// Checks if the given playlist ID is a YouTube Music Mix (auto-generated playlist).
    /// IDs from a YouTube Music Mix start with "RDAMVM" or "RDCLAK".
    /// - Parameter playlistId: The playlist ID to check.
    /// - Returns: True if the given ID belongs to a YouTube Music Mix.
    public static func isYoutubeMusicMixId(_ playlistId: String) -> Bool {
        return playlistId.hasPrefix("RDAMVM") || playlistId.hasPrefix("RDCLAK")
    }

    /// Checks if the given playlist ID is a YouTube Genre Mix (auto-generated playlist).
    /// IDs from a YouTube Genre Mix start with "RDGMEM".
    /// - Parameter playlistId: The playlist ID to check.
    /// - Returns: True if the given ID belongs to a YouTube Genre Mix.
    public static func isYoutubeGenreMixId(_ playlistId: String) -> Bool {
        return playlistId.hasPrefix("RDGMEM")
    }

    /// Extracts the video ID from a mix playlist ID.
    /// - Parameter playlistId: The playlist ID to parse.
    /// - Throws: `ParsingError.invalidPlaylistId` if the playlist ID is null, empty, not a mix, or cannot produce a video ID.
    /// - Returns: The extracted video ID string.
    public static func extractVideoIdFromMixId(_ playlistId: String?) throws(ParsingException) -> String {
        guard let playlistId = playlistId, !playlistId.isEmpty else {
            throw ParsingException("Video id could not be determined from empty playlist id")
        }

        if isYoutubeMyMixId(playlistId) {
            // My Mix IDs start with "RDMM", so the video ID starts from index 4
            return String(playlistId.dropFirst(4))

        } else if isYoutubeMusicMixId(playlistId) {
            // Music Mix IDs start with "RDAMVM" or "RDCLAK", drop first 6 characters
            return String(playlistId.dropFirst(6))

        } else if isYoutubeGenreMixId(playlistId) {
            // Genre mixes are of the form RDGMEM{garbage}, cannot determine video ID
            throw ParsingException("Video id could not be determined from genre mix id: \(playlistId)")

        } else if isYoutubeMixId(playlistId) {
            // Normal mixes: RD{videoId}, must be 13 characters (RD + 11-character videoId)
            if playlistId.count != 13 {
                throw ParsingException("Video id could not be determined from mix id: \(playlistId)")
            }
            return String(playlistId.dropFirst(2))

        } else {
            // Not a recognized mix
            throw ParsingException("Video id could not be determined from playlist id: \(playlistId)")
        }
    }

    /// Extracts the playlist type from a playlist ID (including mix playlist types).
    /// - Parameter playlistId: The playlist ID to parse.
    /// - Throws: `ParsingError.invalidPlaylistId` if the playlist ID is null or empty.
    /// - Returns: The extracted playlist type.
    public static func extractPlaylistTypeFromPlaylistId(_ playlistId: String?) throws(ParsingException) -> PlaylistInfo.PlaylistType {
        guard let playlistId = playlistId, !playlistId.isEmpty else {
            throw ParsingException("Could not extract playlist type from empty playlist id")
        }

        if isYoutubeMusicMixId(playlistId) {
            return .mixMusic
        } else if isYoutubeGenreMixId(playlistId) {
            return .mixGenre
        } else if isYoutubeMixId(playlistId) {
            // Normal mix: either based on a stream, or "my mix" based on a stream.
            // If YouTube introduces new RD-starting mixes, they will default here.
            return .mixStream
        } else {
            // Not a known mix: treat as normal playlist
            return .normal
        }
    }

    /// Extracts the playlist type from a playlist URL's `list` parameter (including mix playlist types).
    /// - Parameter playlistUrl: The playlist URL to parse.
    /// - Throws: `ParsingError.invalidPlaylistId` if the URL is malformed, has no `list` parameter, or the `list` is empty.
    /// - Returns: The extracted playlist type.
    public static func extractPlaylistTypeFromPlaylistUrl(_ playlistUrl: String) throws(ParsingException) -> PlaylistInfo.PlaylistType {
        do {
            let url = try Utils.stringToURL(playlistUrl)
            return try extractPlaylistTypeFromPlaylistId(Utils.getQueryValue(from: url, parameterName: "list"))
        } catch {
            throw ParsingException("Could not extract playlist type from malformed url", error)
        }
    }

    private static func getInitialData(from html: String) throws -> JsonObject? {
        do {
            let stringResult = try Utils.getStringResultFromRegexArray(html, regexStrings: INITIAL_DATA_REGEXES, group: 1)
            guard let jsonDict = JSON(parseJSON: stringResult).dictionaryObject else { return nil }
            return JsonObject(jsonDict)
        } catch {
            throw ParsingException("Could not get ytInitialData", error)
        }
    }


    /// Sometimes, YouTube provides URLs which use Google's cache. They look like
    /// `https://webcache.googleusercontent.com/search?q=cache:CACHED_URL`
    ///
    /// - Parameter url: The URL which might refer to Google's webcache
    /// - Returns: The URL referring to the original site
    static func extractCachedUrlIfNeeded(_ url: String?) -> String? {
        guard let url = url else { return nil }

        if url.contains("webcache.googleusercontent.com"),
           let cacheIndex = url.range(of: "cache:")?.upperBound {
            return String(url[cacheIndex...])
        }

        return url
    }


}

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

    private static func getInitialData(_ html: String) throws -> JsonObject? {
        do {
            let stringResult = try Utils.getStringResultFromRegexArray(html, regexStrings: INITIAL_DATA_REGEXES, group: 1)
            guard let jsonDict = JSON(parseJSON: stringResult).dictionaryObject else { return nil }
            return JsonObject(jsonDict)
        } catch {
            throw ParsingException("Could not get ytInitialData", error)
        }
    }

    public static func isHardcodedClientVersionValid() async throws -> Bool {
        if let cached = hardcodedClientVersionValid {
            return cached
        }

        // Build JSON body (similar to JsonWriter in Java)
        let json: [String: Any] = [
            "context": [
                "client": [
                    "hl": "en-GB",
                    "gl": "GB",
                    "clientName": ClientsConstants.WEB_CLIENT_NAME,
                    "clientVersion": ClientsConstants.WEB_HARDCODED_CLIENT_VERSION,
                    "platform": ClientsConstants.DESKTOP_CLIENT_PLATFORM,
                    "utcOffsetMinutes": 0
                ],
                "request": [
                    "internalExperimentFlags": [],
                    "useSsl": true
                ],
                "user": [
                    "lockedSafetyMode": false
                ]
            ],
            "fetchLiveState": true
        ]

        let body = try JSONSerialization.data(withJSONObject: json, options: [])

        let headers = getClientHeaders(ClientsConstants.WEB_CLIENT_ID,
                                       ClientsConstants.WEB_HARDCODED_CLIENT_VERSION)

        let response = try await NewPipe.getDownloader().postWithContentTypeJson(
            url: "\(YOUTUBEI_V1_URL)guide?\(DISABLE_PRETTY_PRINT_PARAMETER)",
            headers: headers,
            dataToSend: body
        )

        let responseBody = response.responseBody
        let responseCode = response.responseCode

        // Match the Java check: >5000 chars and HTTP 200
        let isValid = responseBody.count > 5000 && responseCode == 200
        hardcodedClientVersionValid = isValid
        return isValid
    }

    /// Extracts the YouTube WEB InnerTube client version from `sw.js`.
    /// - Throws: `ExtractionError` if the request fails or the client version cannot be extracted.
    public static func extractClientVersionFromSwJs() async throws {
        if clientVersionExtracted {
            return
        }

        let url = "https://www.youtube.com/sw.js"
        let headers = getOriginReferrerHeaders(url: "https://www.youtube.com")

        let response = try await NewPipe.getDownloader().get(url, headers: headers)
        let responseBody = response.responseBody

        do {
            clientVersion = try Utils.getStringResultFromRegexArray(
                responseBody,
                regexStrings: INNERTUBE_CONTEXT_CLIENT_VERSION_REGEXES,
                group: 1
            )
        } catch {
            throw ParsingException("Could not extract YouTube WEB InnerTube client version " + "from sw.js", error)
        }

        clientVersionExtracted = true
    }

    /// Extracts the YouTube WEB InnerTube client version from the HTML search results page.
    /// - Throws: `ExtractionError` if the client version cannot be extracted.
    private static func extractClientVersionFromHtmlSearchResultsPage() async throws {
        if clientVersionExtracted {
            return
        }

        // Don't provide a search term to minimize response size
        let url = "https://www.youtube.com/results?search_query=&ucbcb=1"
        let html = try await NewPipe.getDownloader().get(url, headers: getCookieHeader()).responseBody

        // Extract initial JSON data
        let initialData = try getInitialData(html)?.getDictionary() as? [String: Any]
        let responseContext = initialData?["responseContext"] as? [String: Any]
        let serviceTrackingParams = responseContext?["serviceTrackingParams"] as? [[String: Any]] ?? []

        // Try to get version from initial data first
        clientVersion = getClientVersionFromServiceTrackingParam(
            serviceTrackingParams: serviceTrackingParams,
            serviceName: "CSI",
            clientVersionKey: "cver"
        )

        // Fallback using regex on HTML
        if clientVersion == nil {
            do {
                clientVersion = try Utils.getStringResultFromRegexArray(
                    html,
                    regexStrings: INNERTUBE_CONTEXT_CLIENT_VERSION_REGEXES,
                    group: 1
                )
            } catch {
                // Ignore
            }
        }

        // Fallback to shortened client version
        if Utils.isNullOrEmpty(clientVersion) {
            clientVersion = getClientVersionFromServiceTrackingParam(
                serviceTrackingParams: serviceTrackingParams,
                serviceName: "ECATCHER",
                clientVersionKey: "client.version"
            )
        }

        guard clientVersion == nil else {
            throw ParsingException("Could not extract YouTube WEB InnerTube client version from HTML search results page")
        }

        clientVersionExtracted = true
    }


    /// Returns the client version from a stream of service tracking parameters.
    /// - Parameters:
    ///   - serviceTrackingParams: An array of JSON dictionaries representing the service tracking params.
    ///   - serviceName: The name of the service to look for.
    ///   - clientVersionKey: The key that stores the client version.
    /// - Returns: The first matching client version, or `nil` if not found.
    private static func getClientVersionFromServiceTrackingParam(
        serviceTrackingParams: [ [String: Any] ],
        serviceName: String,
        clientVersionKey: String
    ) -> String? {
        for serviceTrackingParam in serviceTrackingParams {
            if (serviceTrackingParam["service"] as? String ?? "") != serviceName {
                continue
            }

            guard let params = serviceTrackingParam["params"] as? [[String: Any]] else {
                continue
            }

            for param in params {
                if (param["key"] as? String ?? "") == clientVersionKey,
                   let value = param["value"] as? String,
                   !value.isEmpty {
                    return value
                }
            }
        }

        return nil
    }

    /// Gets the client version used by the YouTube website for InnerTube requests.
    /// - Throws: `IOException` or `ExtractionException` if the client version cannot be obtained.
    /// - Returns: The current YouTube client version.
    public static func getClientVersion() async throws -> String {
        if !Utils.isNullOrEmpty(clientVersion) {
            return clientVersion
        }

        // Always extract the latest client version, by trying first to extract it from the
        // JavaScript service worker, then from HTML search results page as a fallback, to prevent
        // fingerprinting based on the client version used
        do {
            try await extractClientVersionFromSwJs()
        } catch {
            try await extractClientVersionFromHtmlSearchResultsPage()
        }

        if clientVersionExtracted, let version = clientVersion {
            return version
        }

        // Fallback to the hardcoded one if it is valid
        if try await isHardcodedClientVersionValid() {
            clientVersion = ClientsConstants.WEB_HARDCODED_CLIENT_VERSION
            return clientVersion
        }

        throw ExtractionException("Could not get YouTube WEB client version")
    }

    /// - Note: **Only used in tests.**
    ///
    /// Quick-and-dirty solution to reset global state between test classes.
    ///
    /// This is needed for the mocks because in order to reach that state, a network request has to
    /// be made. If the global state is not reset and the `RecordingDownloader` is used,
    /// then only the first test class has that request recorded. Running other tests with mocks
    /// will fail because the mock is missing.
    public static func resetClientVersion() {
        clientVersion = nil
        clientVersionExtracted = false
    }


    /// Returns a dictionary containing the `Origin` and `Referer` headers
    /// both set to the given URL.
    /// - Parameter url: The URL to be used as the origin and referrer.
    /// - Returns: A dictionary suitable for HTTP headers.
    public static func getOriginReferrerHeaders(url: String) -> [String: [String]] {
        let urlList = [url]
        return [
            "Origin": urlList,
            "Referer": urlList
        ]
    }

    /// Only used in tests.
    public static func setNumberGenerator(_ random: SystemRandomNumberGenerator) {
        numberGenerator = random
    }

    public static func isHardcodedYoutubeMusicClientVersionValid() async throws -> Bool {
        let url = "https://music.youtube.com/youtubei/v1/music/get_search_suggestions?\(DISABLE_PRETTY_PRINT_PARAMETER)"

        // Build JSON body
        let jsonBody: [String: Any] = [
            "context": [
                "client": [
                    "clientName": ClientsConstants.WEB_REMIX_CLIENT_NAME,
                    "clientVersion": ClientsConstants.WEB_REMIX_HARDCODED_CLIENT_VERSION,
                    "hl": "en-GB",
                    "gl": "GB",
                    "platform": ClientsConstants.DESKTOP_CLIENT_PLATFORM,
                    "utcOffsetMinutes": 0
                ],
                "request": [
                    "internalExperimentFlags": [],
                    "useSsl": true
                ],
                "user": [
                    "lockedSafetyMode": false
                ]
            ],
            "input": ""
        ]

        let bodyData = try JSONSerialization.data(withJSONObject: jsonBody)

        // Build headers
        var headers = getOriginReferrerHeaders(url: YOUTUBE_MUSIC_URL)
        headers.merge(getClientHeaders(ClientsConstants.WEB_REMIX_CLIENT_ID,
                                       ClientsConstants.WEB_HARDCODED_CLIENT_VERSION)) { _, new in new }

        // Send POST request
        let response = try await NewPipe.getDownloader().postWithContentTypeJson(url: url,
                                                                          headers: headers,
                                                                          dataToSend: bodyData)
        // Ensure valid response
        return response.responseBody.count > 500 && response.responseCode == 200
    }

    public static func getYoutubeMusicClientVersion() async throws -> String {
        if !Utils.isNullOrEmpty(youtubeMusicClientVersion) {
            return youtubeMusicClientVersion
        }

        // First, try the hardcoded client version
        if try await isHardcodedYoutubeMusicClientVersionValid() {
            youtubeMusicClientVersion = ClientsConstants.WEB_REMIX_HARDCODED_CLIENT_VERSION
            return youtubeMusicClientVersion
        }

        do {
            // Try to extract from sw.js
            let url = "https://music.youtube.com/sw.js"
            let headers = getOriginReferrerHeaders(url: YOUTUBE_MUSIC_URL)
            let response = try await NewPipe.getDownloader().get(url, headers: headers).responseBody

            youtubeMusicClientVersion = try Utils.getStringResultFromRegexArray(
                response,
                regexStrings: INNERTUBE_CONTEXT_CLIENT_VERSION_REGEXES,
                group: 1)
        } catch {
            // Fallback to HTML search results page
            let url = "https://music.youtube.com/?ucbcb=1"
            let html = try await NewPipe.getDownloader().get(url, headers: getCookieHeader()).responseBody

            youtubeMusicClientVersion = try Utils.getStringResultFromRegexArray(
                html,
                regexStrings: INNERTUBE_CONTEXT_CLIENT_VERSION_REGEXES,
                group: 1)
        }

        return youtubeMusicClientVersion
    }

    public static  func getUrlFromNavigationEndpoint(_ navigationEndpoint: [String: Any]) -> String? {
        if let urlEndpoint = navigationEndpoint["urlEndpoint"] as? [String: Any],
           var internUrl = urlEndpoint["url"] as? String {

            if internUrl.hasPrefix("https://www.youtube.com/redirect?") {
                // remove https://www.youtube.com part to fall in the next if block
                internUrl = String(internUrl.dropFirst(23))
            }

            if internUrl.hasPrefix("/redirect?") {
                internUrl = String(internUrl.dropFirst(10))
                let params = internUrl.split(separator: "&")
                for param in params {
                    let keyValue = param.split(separator: "=")
                    if keyValue.count == 2, keyValue[0] == "q" {
                        return keyValue[1].removingPercentEncoding
                    }
                }
            } else if internUrl.hasPrefix("http") {
                return internUrl
            } else if internUrl.hasPrefix("/channel") || internUrl.hasPrefix("/user") || internUrl.hasPrefix("/watch") {
                return "https://www.youtube.com" + internUrl
            }
        }

        if let browseEndpoint = navigationEndpoint["browseEndpoint"] as? [String: Any] {
            let canonicalBaseUrl = browseEndpoint["canonicalBaseUrl"] as? String
            if let browseId = browseEndpoint["browseId"] as? String {
                if browseId.hasPrefix("UC") {
                    return "https://www.youtube.com/channel/" + browseId
                } else if browseId.hasPrefix("VL") {
                    return "https://www.youtube.com/playlist?list=" + browseId.dropFirst(2)
                }
            }

            if let canonicalBaseUrl = canonicalBaseUrl, !canonicalBaseUrl.isEmpty {
                return "https://www.youtube.com" + canonicalBaseUrl
            }
        }

        if let watchEndpoint = navigationEndpoint["watchEndpoint"] as? [String: Any],
           let videoId = watchEndpoint["videoId"] as? String {
            var url = "https://www.youtube.com/watch?v=" + videoId
            if let playlistId = watchEndpoint["playlistId"] as? String {
                url += "&list=" + playlistId
            }
            if let startTime = watchEndpoint["startTimeSeconds"] as? Int {
                url += "&t=" + String(startTime)
            }
            return url
        }

        if let watchPlaylistEndpoint = navigationEndpoint["watchPlaylistEndpoint"] as? [String: Any],
           let playlistId = watchPlaylistEndpoint["playlistId"] as? String {
            return "https://www.youtube.com/playlist?list=" + playlistId
        }

        if let commandMetadata = navigationEndpoint["commandMetadata"] as? [String: Any],
           let webCommandMetadata = commandMetadata["webCommandMetadata"] as? [String: Any],
           let url = webCommandMetadata["url"] as? String {
            return "https://www.youtube.com" + url
        }

        return nil
    }

    public static func getTextFromObject(_ textObject: [String: Any]?, html: Bool) -> String? {
        guard let textObject = textObject, !textObject.isEmpty else {
            return nil
        }

        if let simpleText = textObject["simpleText"] as? String {
            return simpleText
        }

        guard let runs = textObject["runs"] as? [[String: Any]], !runs.isEmpty else {
            return nil
        }

        var textBuilder = ""

        for run in runs {
            var text = run["text"] as? String ?? ""

            if html {
                if let navigationEndpoint = run["navigationEndpoint"] as? [String: Any],
                   let url = getUrlFromNavigationEndpoint(navigationEndpoint) {
                    text = "<a href=\"\(Entities.escape(url))\">\(Entities.escape(text))</a>"
                }

                let bold = run["bold"] as? Bool ?? false
                let italic = run["italics"] as? Bool ?? false
                let strikethrough = run["strikethrough"] as? Bool ?? false

                if bold { textBuilder += "<b>" }
                if italic { textBuilder += "<i>" }
                if strikethrough { textBuilder += "<s>" }

                textBuilder += text

                if strikethrough { textBuilder += "</s>" }
                if italic { textBuilder += "</i>" }
                if bold { textBuilder += "</b>" }
            } else {
                textBuilder += text
            }
        }

        var finalText = textBuilder

        if html {
            finalText = finalText.replacingOccurrences(of: "\n", with: "<br>")
            finalText = finalText.replacingOccurrences(of: "  ", with: " &nbsp;")
        }

        return finalText
    }


    public static func getTextFromObjectOrThrow(_ textObject: [String: Any]?, error: String) throws -> String {
        if let result = getTextFromObject(textObject, html: false) {
            return result
        } else {
            throw ParsingException("Could not extract text: \(error)")
        }
    }

    public static func getTextFromObject(from textObject: [String: Any]) -> String? {
        return getTextFromObject(textObject, html: false)
    }

    public static func getUrlFromObject(_ textObject: [String: Any]?) -> String? {
        guard let textObject = textObject else {
            return nil
        }

        guard let runs = textObject["runs"] as? [[String: Any]], !runs.isEmpty else {
            return nil
        }

        for textPart in runs {
            if let navigationEndpoint = textPart["navigationEndpoint"] as? [String: Any],
               let url = getUrlFromNavigationEndpoint(navigationEndpoint),
               !url.isEmpty {
                return url
            }
        }

        return nil
    }

    public static func getTextAtKey(_ jsonObject: [String: Any], theKey: String) -> String? {
        if let value = jsonObject[theKey] as? String {
            return value
        } else if let nestedObject = jsonObject[theKey] as? [String: Any] {
            return getTextFromObject(from: nestedObject)
        } else {
            return nil
        }
    }

    public static func fixThumbnailUrl(_ thumbnailUrl: String) -> String {
        var result = thumbnailUrl

        if result.hasPrefix("//") {
            result.removeFirst(2)
        }

        if result.hasPrefix("http://") {
            result = Utils.replaceHttpWithHttps(result)
        } else if !result.hasPrefix("https://") {
            result = "https://" + result
        }

        return result
    }

    /// Get thumbnails from a `JsonObject` representing a YouTube `InfoItem`.
    ///
    /// Thumbnails are got from the `thumbnails` array inside the `thumbnail` object of the YouTube `InfoItem`,
    /// using `getImagesFromThumbnailsArray`.
    ///
    /// - Parameter infoItem: a YouTube `InfoItem` represented as a `JsonObject`
    /// - Returns: an array of `Image`s found in the `thumbnails` array
    /// - Throws: `ParsingException` if an error occurs when extracting thumbnails
    public static func getThumbnailsFromInfoItem(_ infoItem: [String: Any]) throws -> [Image] {
        do {
            guard let thumbnailObject = infoItem["thumbnail"] as? [String: Any],
                  let thumbnailsArray = thumbnailObject["thumbnails"] as? [[String: Any]] else {
                throw ParsingException("Could not get thumbnails from InfoItem")
            }
            return getImagesFromThumbnailsArray(thumbnailsArray)
        } catch let error {
            throw ParsingException("Could not get thumbnails from InfoItem", error)
        }
    }


    /// Get images from a YouTube `thumbnails` array.
    ///
    /// The properties of the `Image`s created will be set using the corresponding ones of
    /// thumbnail items.
    ///
    /// - Parameter thumbnails: a YouTube `thumbnails` array
    /// - Returns: an array of `Image`s extracted from the given array
    public static func getImagesFromThumbnailsArray(_ thumbnails: [[String: Any]]) -> [Image] {
        thumbnails.compactMap { thumbnail -> Image? in
            guard let url = thumbnail["url"] as? String, !url.isEmpty else {
                return nil
            }

            let height = thumbnail["height"] as? Int ?? Image.HEIGHT_UNKNOWN
            let width = thumbnail["width"] as? Int ?? Image.WIDTH_UNKNOWN
            let fixedUrl = fixThumbnailUrl(url)
            let resolution = ResolutionLevel.fromHeight(height)

            return Image(fixedUrl, height, width, resolution)
        }
    }

    /// Get a valid JSON response body from a `Response`.
    ///
    /// - Parameter response: the `Response` object
    /// - Returns: the response body as a `String`
    /// - Throws: `ParsingException`, `MalformedURLException`, or `ContentNotAvailableException`
    public static func getValidJsonResponseBody(_ response: Response) throws -> String {
        if response.responseCode == 404 {
            throw ContentNotAvailableException(
                "Not found (\"\(response.responseCode) \(response.responseMessage)\")"
            )
        }

        let responseBody = response.responseBody
        if responseBody.count < 50 { // Ensure to have a valid response
            throw ParsingException("JSON response is too short")
        }

        // Check if the request was redirected to the error page
        if let latestUrl = URL(string: response.latestUrl), latestUrl.host?.lowercased() == "www.youtube.com" {
            let path = latestUrl.path.lowercased()
            if path == "/oops" || path == "/error" {
                throw ContentNotAvailableException("Content unavailable")
            }
        }

        if let contentType = response.getHeader("Content-Type")?.lowercased(),
           contentType.contains("text/html") {
            throw ParsingException(
                "Got HTML document, expected JSON response (latest url was: \"\(response.latestUrl)\")"
            )
        }

        return responseBody
    }

    /// Get a JSON response from a POST request to a YouTube endpoint.
    ///
    /// - Parameters:
    ///   - endpoint: the YouTube endpoint path
    ///   - body: the POST body data
    ///   - localization: the localization object
    /// - Returns: a `JsonObject` representing the response
    /// - Throws: `IOException`, `ExtractionException`, or parsing errors
    public static func getJsonPostResponse(endpoint: String, body: Data, localization: Localization) async throws -> [String: Any] {
        let headers = try await getYouTubeHeaders()

        let urlString = "\(YOUTUBEI_V1_URL)\(endpoint)?\(DISABLE_PRETTY_PRINT_PARAMETER)"
        let response = try await NewPipe.getDownloader().postWithContentTypeJson(url: urlString, headers: headers, dataToSend: body, localization: localization)

        let validResponseBody = try getValidJsonResponseBody(response)
        return try JsonUtils.toJsonObject(validResponseBody)
    }

    /// Returns a dictionary containing the required YouTube headers, including the
    /// `CONSENT` cookie to prevent redirects to `consent.youtube.com`.
    ///
    /// - Throws: `ExtractionException` or `IOException` if the client version cannot be retrieved.
    /// - Returns: a dictionary of HTTP headers.
    public static func getYouTubeHeaders() async throws -> [String: [String]] {
        var headers = try await getClientInfoHeaders()
        headers["Cookie"] = [generateConsentCookie()]
        return headers
    }

    public static func getJsonPostResponse(
        endpoint: String,
        queryParameters: [String],
        body: Data,
        localization: Localization
    ) async throws -> [String: Any] {

        let headers = try await getYouTubeHeaders()

        let queryParametersString: String
        if queryParameters.isEmpty {
            queryParametersString = "?\(DISABLE_PRETTY_PRINT_PARAMETER)"
        } else {
            queryParametersString = "?" + queryParameters.joined(separator: "&") + "&" + DISABLE_PRETTY_PRINT_PARAMETER
        }

        let urlString = "\(YOUTUBEI_V1_URL)\(endpoint)\(queryParametersString)"

        let response = try await NewPipe.getDownloader().postWithContentTypeJson(
            url: urlString,
            headers: headers,
            dataToSend: body,
            localization: localization
        )

        let responseBody = try getValidJsonResponseBody(response)

        return try JsonUtils.toJsonObject(responseBody)
    }


    /// Returns a dictionary containing the `X-YouTube-Client-Name` and
    /// `X-YouTube-Client-Version` headers.
    /// - Parameters:
    ///   - name: The X-YouTube-Client-Name value.
    ///   - version: The X-YouTube-Client-Version value.
    /// - Returns: A dictionary suitable for HTTP headers.
    public static func getClientHeaders(_ name: String, _ version: String) -> [String: [String]] {
        return [
            "X-YouTube-Client-Name": [name],
            "X-YouTube-Client-Version": [version]
        ]
    }

    /// Creates a dictionary with the required cookie header.
    /// - Returns: A dictionary containing the "Cookie" header.
    public static func getCookieHeader() -> [String: [String]] {
        return ["Cookie": [generateConsentCookie()]]
    }

    /// Generates the YouTube consent cookie.
    /// - Returns: The "SOCS" cookie string based on whether consent was accepted.
    public static func generateConsentCookie() -> String {
        let cookieValue: String
        if isConsentAccepted() {
            // CAISAiAD means that the user configured manually cookies on YouTube,
            // regardless of the consent values.
            // This value surprisingly allows extraction of mixes and some YouTube Music
            // playlists in the same way as when a user allows all cookies.
            cookieValue = "CAISAiAD"
        } else {
            // CAE= means that the user rejected all non-necessary cookies with the
            // "Reject all" button on the consent page.
            cookieValue = "CAE="
        }

        return "SOCS=" + cookieValue
    }

    /// Returns a dictionary containing the `X-YouTube-Client-Name`,
    /// `X-YouTube-Client-Version`, `Origin`, and `Referer` headers.
    ///
    /// - Throws: `ExtractionException` or `IOException` if the client version cannot be retrieved.
    /// - Returns: a dictionary of HTTP headers.
    public static func getClientInfoHeaders() async throws -> [String: [String]] {
        var headers = getOriginReferrerHeaders(url: "https://www.youtube.com")
        await headers.merge(getClientHeaders(ClientsConstants.WEB_CLIENT_ID, try getClientVersion())) { _, new in new }
        return headers
    }


    /// Gets the value of the consent's acceptance.
    /// - Returns: The current consent acceptance value.
    /// - SeeAlso: `setConsentAccepted(_:)`
    public static func isConsentAccepted() -> Bool {
        return consentAccepted
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

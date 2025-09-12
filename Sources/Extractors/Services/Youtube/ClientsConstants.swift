//
//  ClientsConstants.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 12/09/2025.
//

public enum ClientsConstants {

    // MARK: - Common client fields

    static let DESKTOP_CLIENT_PLATFORM = "DESKTOP"
    static let MOBILE_CLIENT_PLATFORM = "MOBILE"
    static let WATCH_CLIENT_SCREEN = "WATCH"
    static let EMBED_CLIENT_SCREEN = "EMBED"

    // MARK: - WEB (YouTube desktop) client fields

    static let WEB_CLIENT_ID = "1"
    static let WEB_CLIENT_NAME = "WEB"
    /**
     * The client version for InnerTube requests with the `WEB` client,
     * used as the last fallback if the extraction of the real one failed.
     */
    static let WEB_HARDCODED_CLIENT_VERSION = "2.20250122.04.00"

    // MARK: - WEB_REMIX (YouTube Music) client fields

    static let WEB_REMIX_CLIENT_ID = "67"
    static let WEB_REMIX_CLIENT_NAME = "WEB_REMIX"
    static let WEB_REMIX_HARDCODED_CLIENT_VERSION = "1.20250122.01.00"

    // MARK: - TVHTML5 (YouTube on TVs and consoles using HTML5) client fields

    static let TVHTML5_CLIENT_ID = "7"
    static let TVHTML5_CLIENT_NAME = "TVHTML5"
    static let TVHTML5_CLIENT_VERSION = "7.20250122.15.00"
    static let TVHTML5_CLIENT_PLATFORM = "GAME_CONSOLE"
    static let TVHTML5_DEVICE_MAKE = "Sony"
    static let TVHTML5_DEVICE_MODEL_AND_OS_NAME = "PlayStation 4"
    // CHECKSTYLE:OFF
    static let TVHTML5_USER_AGENT =
        "Mozilla/5.0 (PlayStation; PlayStation 4/12.00) " +
        "AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.4 Safari/605.1.15"
    // CHECKSTYLE:ON

    // MARK: - WEB_EMBEDDED_PLAYER (YouTube embeds)

    static let WEB_EMBEDDED_CLIENT_ID = "56"
    static let WEB_EMBEDDED_CLIENT_NAME = "WEB_EMBEDDED_PLAYER"
    static let WEB_EMBEDDED_CLIENT_VERSION = "1.20250121.00.00"

    // MARK: - WEB_MUSIC_ANALYTICS (YouTube charts)

    static let WEB_MUSIC_ANALYTICS_CLIENT_ID = "31"
    static let WEB_MUSIC_ANALYTICS_CLIENT_NAME = "WEB_MUSIC_ANALYTICS"
    static let WEB_MUSIC_ANALYTICS_CLIENT_VERSION = "2.0"

    // MARK: - IOS (iOS YouTube app) client fields

    static let IOS_CLIENT_ID = "5"
    static let IOS_CLIENT_NAME = "IOS"

    /**
     * The hardcoded client version of the iOS app used for InnerTube requests with this client.
     *
     * It can be extracted by getting the latest release version of the app on
     * the App Store page of the YouTube app, in the “What’s New” section.
     */
    static let IOS_CLIENT_VERSION = "20.03.02"

    /**
     * The device machine id for the iPhone 15 Pro Max, used to get 60fps with the `iOS` client.
     *
     * See: https://gist.github.com/adamawolf/3048717
     */
    static let IOS_DEVICE_MODEL = "iPhone16,2"

    /**
     * The iOS version to be used in JSON POST requests, the one of an iPhone 15 Pro Max running
     * iOS 18.2.1 with the hardcoded version of the iOS app (for the `"osVersion"` field).
     *
     * Structure: "iOS major.minor.patch.build"
     * - patch = 0 if not set
     * The build version can be found at:
     * https://theapplewiki.com/wiki/Firmware/iPhone/18.x#iPhone_15_Pro_Max
     *
     * @see IOS_USER_AGENT_VERSION
     */
    static let IOS_OS_VERSION = "18.2.1.22C161"

    /**
     * The iOS version to be used in the HTTP user agent for requests.
     *
     * This should be the same as `IOS_OS_VERSION`.
     *
     * @see IOS_OS_VERSION
     */
    static let IOS_USER_AGENT_VERSION = "18_2_1"

    // MARK: - ANDROID (Android YouTube app) client fields

    static let ANDROID_CLIENT_ID = "3"
    static let ANDROID_CLIENT_NAME = "ANDROID"

    /**
     * The hardcoded client version of the Android app used for InnerTube requests with this client.
     *
     * It can be extracted by getting the latest release version of the app
     * from an APK repository such as APKMirror.
     */
    static let ANDROID_CLIENT_VERSION = "19.28.35"
}


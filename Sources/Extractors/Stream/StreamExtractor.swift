//
//  StreamExtractor.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 18/11/2024.
//

import Foundation

/// Base class for extracting information from a video/audio streaming service (e.g., YouTube).
open class StreamExtractor: Extractor {

    public static let noAgeLimit = 0
    public static let unknownSubscriberCount: Int64 = -1

    public override init(service: any StreamingService, linkHandler: LinkHandler) {
        super.init(service: service, linkHandler: linkHandler)
    }

    /// The original textual date provided by the service. Returns `nil` for live streams.
    open func getTextualUploadDate() throws -> String? {
        return nil
    }

    /// The upload date as a `DateWrapper`, parsed from the textual upload date.
    open func getUploadDate() throws -> DateWrapper? {
        return nil
    }

    /// Returns the thumbnails of the stream.
    open func getThumbnails() throws -> [Image] {
        fatalError("Subclasses must override this method.")
    }

    /// Returns the stream's description or an empty description if unavailable.
    open func getDescription() throws -> Description {
        return Description.EMPTY
    }

    /// Returns the age limit for the stream or `noAgeLimit` if unrestricted.
    open func getAgeLimit() throws -> Int {
        return StreamExtractor.noAgeLimit
    }

    /// Returns the stream length in seconds or `0` for live streams.
    open func getLength() throws -> Int64 {
        return 0
    }

    /// Returns the timestamp/seek position in seconds, or `0` if unavailable.
    open func getTimeStamp() throws -> Int64 {
        return 0
    }

    /// Returns the view count or `-1` if unavailable.
    open func getViewCount() throws -> Int64 {
        return -1
    }

    /// Returns the like count or `-1` if unavailable.
    open func getLikeCount() throws -> Int64 {
        return -1
    }

    /// Returns the dislike count or `-1` if unavailable.
    open func getDislikeCount() throws -> Int64 {
        return -1
    }

    /// Returns the uploader's page URL or an empty string if unavailable.
    open func getUploaderUrl() throws -> String {
        fatalError("Subclasses must override this method.")
    }

    /// Returns the uploader's name or an empty string if unavailable.
    open func getUploaderName() throws -> String {
        fatalError("Subclasses must override this method.")
    }

    /// Returns whether the uploader is verified by the service.
    open func isUploaderVerified() throws -> Bool {
        return false
    }

    /// Returns the uploader's subscriber count or `unknownSubscriberCount` if unavailable.
    open func getUploaderSubscriberCount() throws -> Int64 {
        return StreamExtractor.unknownSubscriberCount
    }

    /// Returns the uploader's avatars or an empty list if unavailable.
    open func getUploaderAvatars() throws -> [Image] {
        return []
    }

    /// Returns the sub-channel's URL or an empty string if unavailable.
    open func getSubChannelUrl() throws -> String {
        return ""
    }

    /// Returns the sub-channel's name or an empty string if unavailable.
    open func getSubChannelName() throws -> String {
        return ""
    }

    /// Returns the sub-channel's avatars or an empty list if unavailable.
    open func getSubChannelAvatars() throws -> [Image] {
        return []
    }

    /// Returns the Dash MPD URL or an empty string if unavailable.
    open func getDashMpdUrl() throws -> String {
        return ""
    }

    /// Returns the HLS URL or an empty string if unavailable.
    open func getHlsUrl() throws -> String {
        return ""
    }

    /// Returns a list of audio-only streams.
//    open func getAudioStreams() throws -> [AudioStream] {
//        fatalError("Subclasses must override this method.")
//    }

    /// Returns a list of combined video and audio streams.
//    open func getVideoStreams() throws -> [VideoStream] {
//        fatalError("Subclasses must override this method.")
//    }

    /// Returns a list of video-only streams.
//    open func getVideoOnlyStreams() throws -> [VideoStream] {
//        fatalError("Subclasses must override this method.")
//    }

    /// Returns a list of default subtitle streams.
//    open func getSubtitlesDefault() throws -> [SubtitlesStream] {
//        return []
//    }

    /// Returns a list of subtitle streams for a specific format.
//    open func getSubtitles(format: MediaFormat) throws -> [SubtitlesStream] {
//        return []
//    }

    /// Returns the stream type.
    open func getStreamType() throws -> StreamType {
        fatalError("Subclasses must override this method.")
    }

    /// Returns related items for the current stream.
    open func getRelatedItems() throws -> InfoItemsCollector<InfoItem, AnyInfoItemExtractor>? {
        return nil
    }

    /// Returns a list of frames for the stream or an empty list if unsupported.
    open func getFrames() throws -> [Frameset] {
        return []
    }

    /// Returns an error message if present on the webpage.
    open func getErrorMessage() -> String? {
        return nil
    }

    /// Parses and returns the timestamp in seconds from the given URL pattern.
    open func getTimestampSeconds(regexPattern: String) throws -> Int64 {
        fatalError("Subclasses must override this method if needed.")
    }

    /// Returns the host of the stream or an empty string if unavailable.
    open func getHost() throws -> String {
        return ""
    }

    /// Returns the privacy setting of the stream.
    open func getPrivacy() throws -> Privacy {
        return .public
    }

    /// Returns the category of the stream or an empty string if unavailable.
    open func getCategory() throws -> String {
        return ""
    }

    /// Returns the license of the stream or an empty string if unavailable.
    open func getLicence() throws -> String {
        return ""
    }

    /// Returns the language information of the stream or `nil` if unavailable.
    open func getLanguageInfo() throws -> Locale? {
        return nil
    }

    /// Returns the tags associated with the stream or an empty list if unavailable.
    open func getTags() throws -> [String] {
        return []
    }

    /// Returns support information for the stream or an empty string if unavailable.
    open func getSupportInfo() throws -> String {
        return ""
    }

    /// Returns a list of segments for the stream or an empty list if unavailable.
    open func getStreamSegments() throws -> [StreamSegment] {
        return []
    }

    /// Returns meta information about the stream or an empty list if unavailable.
    open func getMetaInfo() throws -> [MetaInfo] {
        return []
    }

    /// Returns whether the stream is short-form content.
    open func isShortFormContent() throws -> Bool {
        return false
    }

    /// Privacy settings for the stream.
    public enum Privacy {
        case `public`
        case unlisted
        case `private`
        case internalUse
        case other
    }
}

public class AnyInfoItemExtractor: InfoItemExtractor {
    public func getName() throws -> String {
        fatalError("getName() has not been implemented")
    }
    
    public func getUrl() throws -> String {
        fatalError("getUrl() has not been implemented")
    }
    
    public func getThumbnails() throws -> List<Image> {
        fatalError("getThumbnails() has not been implemented")
    }
}

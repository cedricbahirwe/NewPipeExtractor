//
//  StreamInfoItem.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 17/11/2024.
//


import Foundation

/// Represents a preview of unopened videos, such as search results or related videos.
public class StreamInfoItem: InfoItem {

    // MARK: - Properties

    private let streamType: StreamType

    private var uploaderName: String = "-"
    private var shortDescription: String?
    private var textualUploadDate: String? = nil
    private var uploadDate: DateWrapper? = nil
    private var viewCount: Int64 = -1
    private var duration: Int64 = -1
    private var uploaderUrl: String? = nil
    private var uploaderAvatars: [Image] = []
    private var uploaderVerified: Bool = false
    private var shortFormContent: Bool = false

    // MARK: - Initializer

    /// Initializes a `StreamInfoItem` instance.
    ///
    /// - Parameters:
    ///   - serviceId: The service ID associated with the stream.
    ///   - url: The URL of the stream.
    ///   - name: The name of the stream.
    ///   - streamType: The type of the stream (e.g., video, live stream).
    public required init(serviceId: Int, url: String, name: String, streamType: StreamType) {
        self.streamType = streamType
        super.init(infoType: .stream, serviceId: serviceId, url: url, name: name)
    }

    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }

    // MARK: - Getters and Setters
    public func getStreamType() -> StreamType {
        return streamType
    }

    public func getUploaderName() -> String {
        return uploaderName
    }

    public func setUploaderName(_ uploaderName: String) {
        self.uploaderName = uploaderName
    }

    public func getViewCount() -> Int64 {
        return viewCount
    }

    public func setViewCount(_ viewCount: Int64) {
        self.viewCount = viewCount
    }

    public func getDuration() -> Int64 {
        return duration
    }

    public func setDuration(_ duration: Int64) {
        self.duration = duration
    }

    public func getUploaderUrl() -> String? {
        return uploaderUrl
    }

    public func setUploaderUrl(_ uploaderUrl: String?) {
        self.uploaderUrl = uploaderUrl
    }

    public func getUploaderAvatars() -> [Image] {
        return uploaderAvatars
    }

    public func setUploaderAvatars(_ uploaderAvatars: [Image]) {
        self.uploaderAvatars = uploaderAvatars
    }

    public func getShortDescription() -> String? {
        return shortDescription
    }

    public func setShortDescription(_ shortDescription: String?) {
        self.shortDescription = shortDescription
    }

    public func getTextualUploadDate() -> String? {
        return textualUploadDate
    }

    public func setTextualUploadDate(_ textualUploadDate: String?) {
        self.textualUploadDate = textualUploadDate
    }

    public func getUploadDate() -> DateWrapper? {
        return uploadDate
    }

    public func setUploadDate(_ uploadDate: DateWrapper?) {
        self.uploadDate = uploadDate
    }

    public func isUploaderVerified() -> Bool {
        return uploaderVerified
    }

    public func setUploaderVerified(_ uploaderVerified: Bool) {
        self.uploaderVerified = uploaderVerified
    }

    public func isShortFormContent() -> Bool {
        return shortFormContent
    }

    public func setShortFormContent(_ shortFormContent: Bool) {
        self.shortFormContent = shortFormContent
    }

    /// Returns a string representation of the `StreamInfoItem`.
    public override var description: String {
        """
        StreamInfoItem {
            streamType: \(streamType),
            uploaderName: '\(uploaderName)',
            textualUploadDate: '\(textualUploadDate ?? "nil")',
            viewCount: \(viewCount),
            duration: \(duration),
            uploaderUrl: '\(uploaderUrl ?? "nil")',
            infoType: \(infoType),
            serviceId: \(serviceId),
            url: '\(url)',
            name: '\(name)',
            thumbnails: '\(getThumbnails())',
            uploaderVerified: \(uploaderVerified)
        }
        """
    }
}

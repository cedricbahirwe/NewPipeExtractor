//
//  Stream.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 18/11/2024.
//


/// Abstract class representing streams in the extractor.
public class Stream: Codable {
    public static let formatIdUnknown = -1
    public static let idUnknown = " "
    public static let itagNotAvailableOrNotApplicable = -1

    private let id: String
    private let mediaFormat: MediaFormat?
    private let content: String
    private let isUrl: Bool
    private let deliveryMethod: DeliveryMethod
    private let manifestUrl: String?

    /// Initializes a new `Stream` object.
    public init(
        id: String,
        content: String,
        isUrl: Bool,
        format: MediaFormat?,
        deliveryMethod: DeliveryMethod,
        manifestUrl: String?
    ) {
        self.id = id
        self.content = content
        self.isUrl = isUrl
        self.mediaFormat = format
        self.deliveryMethod = deliveryMethod
        self.manifestUrl = manifestUrl
    }

    /// Checks if the list already contains a stream with the same statistics.
    public static func containSimilarStream(
        stream: Stream,
        streamList: [Stream]?
    ) -> Bool {
        guard let streamList = streamList, !streamList.isEmpty else { return false }
        return streamList.contains(where: { $0.areStatsEqual(to: stream) })
    }

    /// Reveals whether two streams have the same statistics (media format and delivery method).
    public func areStatsEqual(to other: Stream?) -> Bool {
        guard let other = other,
              let mediaFormat = self.mediaFormat,
              let otherMediaFormat = other.mediaFormat else { return false }
        return mediaFormat.id == otherMediaFormat.id &&
               deliveryMethod == other.deliveryMethod &&
               isUrl == other.isUrl
    }

    /// Gets the identifier of this stream.
    public func getId() -> String {
        return id
    }

    /// Gets the URL of this stream if the content is a URL, or `nil` otherwise.
    @available(*, deprecated, message: "Use `getContent()` instead.")
    public func getUrl() -> String? {
        return isUrl ? content : nil
    }

    /// Gets the content or URL.
    public func getContent() -> String {
        return content
    }

    /// Returns whether the content is a URL or not.
    public func isContentUrl() -> Bool {
        return isUrl
    }

    /// Gets the `MediaFormat`, which can be `nil`.
    public func getFormat() -> MediaFormat? {
        return mediaFormat
    }

    /// Gets the format ID, which can be unknown.
    public func getFormatId() -> Int {
        return mediaFormat?.id ?? Stream.formatIdUnknown
    }

    /// Gets the `DeliveryMethod`.
    public func getDeliveryMethod() -> DeliveryMethod {
        return deliveryMethod
    }

    /// Gets the URL of the manifest this stream comes from (if applicable, otherwise `nil`).
    public func getManifestUrl() -> String? {
        return manifestUrl
    }

    /// Gets the `ItagItem` of a stream.
    ///
    /// If the stream is not from YouTube, this value will always be `nil`.
    public func getItagItem() -> ItagItem? {
        fatalError("getItagItem() is not implemented for \(type(of: self))")
    }
}

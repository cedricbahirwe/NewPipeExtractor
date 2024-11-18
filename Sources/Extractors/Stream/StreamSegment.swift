//
//  StreamSegment.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 18/11/2024.
//


import Foundation

/// Represents a segment of a stream, including title, channel, timestamp, and URLs.
public class StreamSegment: Codable {
    /// Title of this segment.
    private var title: String

    /// The channel or creator linked to this segment.
    private var channelName: String?

    /// Timestamp of the starting point in seconds.
    private var startTimeSeconds: Int

    /// Direct URL to this segment. This can be `nil` if the service doesn't provide such a function.
    public var url: String?

    /// Preview URL for this segment. This can be `nil` if the service doesn't provide such a function or there is no resource found.
    private var previewUrl: String?

    /// Initializes a new `StreamSegment` with the specified title and start time.
    /// - Parameters:
    ///   - title: The title of the segment.
    ///   - startTimeSeconds: The starting timestamp in seconds.
    public init(title: String, startTimeSeconds: Int) {
        self.title = title
        self.startTimeSeconds = startTimeSeconds
    }

    /// The title of the segment.
    public var getTitle: String {
        get { title }
        set { title = newValue }
    }

    /// The starting timestamp of the segment in seconds.
    public var getStartTimeSeconds: Int {
        get { startTimeSeconds }
        set { startTimeSeconds = newValue }
    }

    /// The name of the channel or creator associated with this segment.
    public var getChannelName: String? {
        get { channelName }
        set { channelName = newValue }
    }

    /// The preview URL for this segment.
    public var getPreviewUrl: String? {
        get { previewUrl }
        set { previewUrl = newValue }
    }
}
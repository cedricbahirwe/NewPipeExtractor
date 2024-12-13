
//
//  File.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 16/11/2024.
//

import Foundation

/// An enum representing the stream type of a `StreamInfo` extracted by a `StreamExtractor`.
public enum StreamType: Codable {

    /// Placeholder to check if the stream type was checked or not. It doesn't make sense to use this
    /// enum case outside of the extractor as it will never be returned by an `Extractor` and is only used internally.
    case none

    /// A normal video stream, usually with audio. Note that the `StreamInfo` **can also
    /// provide audio-only `AudioStream`s** in addition to video or video-only `VideoStream`s.
    case videoStream

    /// An audio-only stream. There should be no `VideoStream`s available! In order to prevent
    /// unexpected behaviors, when `StreamExtractor`s return this stream type, they should
    /// ensure that no video stream is returned in `StreamExtractor.getVideoStreams()` and
    /// `StreamExtractor.getVideoOnlyStreams()`.
    case audioStream

    /// A video live stream, usually with audio. Note that the `StreamInfo` **can also
    /// provide audio-only `AudioStream`s** in addition to video or video-only `VideoStream`s.
    case liveStream

    /// An audio-only live stream. There should be no `VideoStream`s available! In order to
    /// prevent unexpected behaviors, when `StreamExtractor`s return this stream type, they
    /// should ensure that no video stream is returned in `StreamExtractor.getVideoStreams()`
    /// and `StreamExtractor.getVideoOnlyStreams()`.
    case audioLiveStream

    /// A video live stream that has just ended but has not yet been encoded into a normal video
    /// stream. Note that the `StreamInfo` **can also provide audio-only `AudioStream`s** in addition
    /// to video or video-only `VideoStream`s.
    ///
    /// Most of the content of an ended live video (or audio) may be extracted as `videoStream`
    /// (or `audioStream`) later, because the service may encode them again later as normal
    /// video/audio streams. For example, that's the case on YouTube.
    case postLiveStream

    /// An audio live stream that has just ended but has not yet been encoded into a normal audio
    /// stream. There should be no `VideoStream`s available! In order to prevent unexpected
    /// behaviors, when `StreamExtractor`s return this stream type, they should ensure that no
    /// video stream is returned in `StreamExtractor.getVideoStreams()` and `StreamExtractor.getVideoOnlyStreams()`.
    ///
    /// Most of the ended live audio streams extracted with this value are processed as
    /// `audioStream` later, because the service may encode them again later.
    case postLiveAudioStream
}

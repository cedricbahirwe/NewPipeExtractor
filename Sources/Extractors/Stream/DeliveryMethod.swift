//
//  DeliveryMethod.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 18/11/2024.
//


/// An enum to represent the different delivery methods of `Stream`s which are returned by the extractor.
public enum DeliveryMethod: Codable {

    /// Used for `Stream`s served using the progressive HTTP streaming method.
    case progressiveHTTP

    /// Used for `Stream`s served using the DASH (Dynamic Adaptive Streaming over HTTP) adaptive streaming method.
    ///
    /// See: [Dynamic Adaptive Streaming over HTTP](https://en.wikipedia.org/wiki/Dynamic_Adaptive_Streaming_over_HTTP)
    /// and [DASH Industry Forum](https://dashif.org/)
    case dash

    /// Used for `Stream`s served using the HLS (HTTP Live Streaming) adaptive streaming method.
    ///
    /// See: [HTTP Live Streaming](https://en.wikipedia.org/wiki/HTTP_Live_Streaming)
    /// and [Apple's developers website about HTTP Live Streaming](https://developer.apple.com/streaming)
    case hls

    /// Used for `Stream`s served using the SmoothStreaming adaptive streaming method.
    ///
    /// See: [Adaptive bitrate streaming: Microsoft Smooth Streaming (MSS)](https://en.wikipedia.org/wiki/Adaptive_bitrate_streaming#Microsoft_Smooth_Streaming_(MSS))
    case smoothStreaming

    /// Used for `Stream`s served via a torrent file.
    ///
    /// See: [BitTorrent](https://en.wikipedia.org/wiki/BitTorrent), [Torrent Files](https://en.wikipedia.org/wiki/Torrent_file),
    /// and [BitTorrent Protocol](https://www.bittorrent.org)
    case torrent
}

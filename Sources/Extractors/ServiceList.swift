//
//  ServiceList.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 16/11/2024.
//

import Foundation

/// A list of supported services.
public enum ServiceList {

//    public static let YouTube = YoutubeService(0)
//    public static let SoundCloud = SoundcloudService(1)
//    public static let MediaCCC = MediaCCCService(2)
    public static let PeerTube = PeertubeService(3)
//    public static let Bandcamp = BandcampService(4)

    /**
     * When creating a new service, put this service at the end of this list,
     * and give it the next free id.
     */
    nonisolated(unsafe) private static let SERVICES: [any StreamingService] = [
        /*YouTube, SoundCloud, MediaCCC, */PeerTube/*, Bandcamp*/
    ]

    /// Get all the supported services.
    ///
    /// - Returns: An immutable list of all supported services.
    public static func all() -> [any StreamingService] {
        return SERVICES
    }
}

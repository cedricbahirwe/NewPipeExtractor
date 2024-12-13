//
//  PlaylistInfoItem.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 13/12/2024.
//

public class PlaylistInfoItem: InfoItem {
    public var uploaderName: String?
    public var uploaderUrl: String?
    public var uploaderVerified: Bool = false
    /// How many streams this playlist have
    public var streamCount: Int64 = 0
    public var description: Description = .EMPTY
    public var playlistType: PlaylistInfo.PlaylistType = .normal

    public init(serviceId: Int, url: String, name: String) {
        super.init(infoType: .playlist, serviceId: serviceId, url: url, name: name)
    }

    required init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }

    public func getUploaderName() -> String? {
        uploaderName
    }

    public func setUploaderName(_ uploaderName: String) {
        self.uploaderName = uploaderName
    }

    public func getUploaderUrl() -> String? {
        uploaderUrl
    }

    public func setUploaderUrl(_ uploaderUrl: String) {
        self.uploaderUrl = uploaderUrl
    }

    public func isUploaderVerified() -> Bool {
        uploaderVerified
    }

    public func setUploaderVerified(_ uploaderVerified: Bool) {
        self.uploaderVerified = uploaderVerified
    }

    public func getStreamCount() -> Int64 {
        streamCount
    }

    public func setStreamCount(_ streamCount: Int64) {
        self.streamCount = streamCount
    }

    public func getDescription() -> Description {
        description
    }

    public func setDescription(_ description: Description) {
        self.description = description
    }

    public func getPlaylistType() -> PlaylistInfo.PlaylistType {
        playlistType
    }

    public func setPlaylistType(_ playlistType: PlaylistInfo.PlaylistType) {
        self.playlistType = playlistType
    }
}

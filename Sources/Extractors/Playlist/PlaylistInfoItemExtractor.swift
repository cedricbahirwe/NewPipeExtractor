//
//  PlaylistInfoItemExtractor.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 13/12/2024.
//


import Foundation

/// A protocol to extract information about a playlist.
public protocol PlaylistInfoItemExtractor: InfoItemExtractor {

    /// Get the uploader name.
    /// - Returns: the uploader name.
    func getUploaderName() throws -> String

    /// Get the uploader URL.
    /// - Returns: the uploader URL.
    func getUploaderUrl() throws -> String

    /// Get whether the uploader is verified.
    /// - Returns: `true` if the uploader is verified, otherwise `false`.
    func isUploaderVerified() throws -> Bool

    /// Get the number of streams.
    /// - Returns: the number of streams.
    func getStreamCount() throws -> Int64
}


public extension PlaylistInfoItemExtractor {
    /// Get the description of the playlist, if there is any.
    /// Otherwise, an empty description is returned.
    /// - Returns: the playlist's description.
    func getDescription() throws -> Description {
        Description.EMPTY
    }

    /// Get the type of this playlist.
    /// - Returns: the type of this playlist, which could be a value of `PlaylistType`.
    /// If not overridden, always returns `.normal`.
    func getPlaylistType() throws -> PlaylistInfo.PlaylistType {
        return .normal
    }
}


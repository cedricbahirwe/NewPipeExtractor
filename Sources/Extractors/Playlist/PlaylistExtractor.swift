//
//  PlaylistExtractor.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 13/12/2024.
//


import Foundation

public class PlaylistExtractor: ListExtractor<StreamInfoItem> {
    // MARK: - Abstract Methods

    func getUploaderUrl() throws -> String {
        fatalError("Must be overridden in a subclass")
    }

    func getUploaderName() throws -> String {
        fatalError("Must be overridden in a subclass")
    }

    func getUploaderAvatars() throws -> [Image] {
        fatalError("Must be overridden in a subclass")
    }

    func isUploaderVerified() throws -> Bool {
        fatalError("Must be overridden in a subclass")
    }

    func getStreamCount() throws -> Int {
        fatalError("Must be overridden in a subclass")
    }

    func getDescription() throws -> Description {
        fatalError("Must be overridden in a subclass")
    }

    func getThumbnails() throws -> [Image] {
        return []
    }

    func getBanners() throws -> [Image] {
        return []
    }

    func getSubChannelName() throws -> String {
        return ""
    }

    func getSubChannelUrl() throws -> String {
        return ""
    }

    func getSubChannelAvatars() throws -> [Image] {
        return []
    }

    func getPlaylistType() throws -> PlaylistInfo.PlaylistType {
        return .normal
    }
}

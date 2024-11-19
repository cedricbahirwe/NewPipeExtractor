//
//  CommentsInfoItemExtractor.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 19/11/2024.
//


import Foundation

public protocol CommentsInfoItemExtractor: InfoItemExtractor {
    func getLikeCount() throws -> Int
    func getTextualLikeCount() throws -> String
    func getCommentText() throws -> Description
    func getTextualUploadDate() throws -> String
    func getUploadDate() throws -> DateWrapper?
    func getCommentId() throws -> String
    func getUploaderUrl() throws -> String
    func getUploaderName() throws -> String
    func getUploaderAvatars() throws -> [Image]
    func isHeartedByUploader() throws -> Bool
    func isPinned() throws -> Bool
    func isUploaderVerified() throws -> Bool
    func getStreamPosition() throws -> Int
    func getReplyCount() throws -> Int
    func getReplies() throws -> Page?
    func isChannelOwner() throws -> Bool
    func hasCreatorReply() throws -> Bool
}


public extension CommentsInfoItemExtractor {
    
    func getLikeCount() throws -> Int {
        return CommentsInfoItem.noLikeCount
    }
    
    func getTextualLikeCount() throws -> String {
        return ""
    }
    
    func getCommentText() throws -> Description {
        return .EMPTY
    }
    
    func getTextualUploadDate() throws -> String {
        return ""
    }
    
    func getUploadDate() throws -> DateWrapper? {
        return nil
    }
    
    func getCommentId() throws -> String {
        return ""
    }
    
    func getUploaderUrl() throws -> String {
        return ""
    }
    
    func getUploaderName() throws -> String {
        return ""
    }
    
    func getUploaderAvatars() throws -> [Image] {
        return []
    }
    
    func isHeartedByUploader() throws -> Bool {
        return false
    }
    
    func isPinned() throws -> Bool {
        return false
    }
    
    func isUploaderVerified() throws -> Bool {
        return false
    }
    
    func getStreamPosition() throws -> Int {
        return CommentsInfoItem.noStreamPosition
    }
    
    func getReplyCount() throws -> Int {
        return CommentsInfoItem.unknownReplyCount
    }
    
    func getReplies() throws -> Page? {
        return nil
    }
    
    func isChannelOwner() throws -> Bool {
        return false
    }
    
    func hasCreatorReply() throws -> Bool {
        return false
    }
}

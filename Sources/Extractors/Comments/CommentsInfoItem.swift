//
//  CommentsInfoItem.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 19/11/2024.
//


import Foundation

public final class CommentsInfoItem: InfoItem {
    public static let noLikeCount = -1
    public static let noStreamPosition = -1
    public static let unknownReplyCount = -1

    private var commentId: String = ""
    private var commentText: Description = .EMPTY
    private var uploaderName: String = ""
    private var uploaderAvatars: [Image] = []
    private var uploaderUrl: String = ""
    private var uploaderVerified: Bool = false
    private var textualUploadDate: String = ""
    private var uploadDate: DateWrapper?
    private var likeCount: Int = noLikeCount
    private var textualLikeCount: String = ""
    private var heartedByUploader: Bool = false
    private var pinned: Bool = false
    private var streamPosition: Int = noStreamPosition
    private var replyCount: Int = unknownReplyCount
    private var replies: Page?
    private var isChannelOwner: Bool = false
    private var creatorReply: Bool = false

    public init(serviceId: Int, url: String, name: String) {
        super.init(infoType: .comment, serviceId: serviceId, url: url, name: name)
    }
    
    required init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    public func getCommentId() -> String {
        return commentId
    }

    public func setCommentId(_ commentId: String) {
        self.commentId = commentId
    }

    public func getCommentText() -> Description {
        return commentText
    }

    public func setCommentText(_ commentText: Description) {
        self.commentText = commentText
    }

    public func getUploaderName() -> String {
        return uploaderName
    }

    public func setUploaderName(_ uploaderName: String) {
        self.uploaderName = uploaderName
    }

    public func getUploaderAvatars() -> [Image] {
        return uploaderAvatars
    }

    public func setUploaderAvatars(_ uploaderAvatars: [Image]) {
        self.uploaderAvatars = uploaderAvatars
    }

    public func getUploaderUrl() -> String {
        return uploaderUrl
    }

    public func setUploaderUrl(_ uploaderUrl: String) {
        self.uploaderUrl = uploaderUrl
    }

    public func getTextualUploadDate() -> String {
        return textualUploadDate
    }

    public func setTextualUploadDate(_ textualUploadDate: String) {
        self.textualUploadDate = textualUploadDate
    }

    public func getUploadDate() -> DateWrapper? {
        return uploadDate
    }

    public func setUploadDate(_ uploadDate: DateWrapper?) {
        self.uploadDate = uploadDate
    }

    public func getLikeCount() -> Int {
        return likeCount
    }

    public func setLikeCount(_ likeCount: Int) {
        self.likeCount = likeCount
    }

    public func getTextualLikeCount() -> String {
        return textualLikeCount
    }

    public func setTextualLikeCount(_ textualLikeCount: String) {
        self.textualLikeCount = textualLikeCount
    }

    public func isHeartedByUploader() -> Bool {
        return heartedByUploader
    }

    public func setHeartedByUploader(_ isHeartedByUploader: Bool) {
        self.heartedByUploader = isHeartedByUploader
    }

    public func isPinned() -> Bool {
        return pinned
    }

    public func setPinned(_ pinned: Bool) {
        self.pinned = pinned
    }

    public func isUploaderVerified() -> Bool {
        return uploaderVerified
    }

    public func setUploaderVerified(_ uploaderVerified: Bool) {
        self.uploaderVerified = uploaderVerified
    }

    public func getStreamPosition() -> Int {
        return streamPosition
    }

    public func setStreamPosition(_ streamPosition: Int) {
        self.streamPosition = streamPosition
    }

    public func getReplyCount() -> Int {
        return replyCount
    }

    public func setReplyCount(_ replyCount: Int) {
        self.replyCount = replyCount
    }

    public func getReplies() -> Page? {
        return replies
    }

    public func setReplies(_ replies: Page?) {
        self.replies = replies
    }

    public func getIsChannelOwner() -> Bool {
        return isChannelOwner
    }

    public func setChannelOwner(_ channelOwner: Bool) {
        self.isChannelOwner = channelOwner
    }

    public func hasCreatorReply() -> Bool {
        return creatorReply
    }

    public func setCreatorReply(_ creatorReply: Bool) {
        self.creatorReply = creatorReply
    }
}

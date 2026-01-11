//
//  CommentsExtractor.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 19/11/2024.
//


import Foundation

public class CommentsExtractor: ListExtractor<CommentsInfoItem> {

    public override init(_ service: StreamingService, _ linkHandler: ListLinkHandler) {
        super.init(service, linkHandler)
    }

    /// Warning: This method is experimental and may get removed in a future release.
    /// - Returns: `true` if the comments are disabled, otherwise `false` (default).
    public func isCommentsDisabled() throws -> Bool {
        return false
    }

    /// - Returns: the total number of comments.
    public func getCommentsCount() throws -> Int {
        return -1
    }

    public override func getName() throws(ParsingException) -> String {
        return "Comments"
    }
}

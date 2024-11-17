//
//  StreamInfoItemExtractor.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 16/11/2024.
//

import Foundation

public protocol StreamInfoItemExtractor: InfoItemExtractor {
    /**
     * Get the stream type
     * @throws ParsingException if there is an error in the extraction
     */
    func getStreamType() throws -> StreamType

    /**
     * Check if the stream is an ad
     * @throws ParsingException if there is an error in the extraction
     */
    func isAd() throws -> Bool

    /**
     * Get the stream duration in seconds
     * @throws ParsingException if there is an error in the extraction
     */
    func getDuration() throws -> Int64

    /**
     * Parses the number of views
     * @throws ParsingException if there is an error in the extraction
     */
    func getViewCount() throws -> Int64

    /**
     * Get the uploader name
     * @throws ParsingException if there is an error in the extraction
     */
    func getUploaderName() throws -> String

    /**
     * Get the uploader URL
     * @throws ParsingException if there is an error in the extraction
     */
    func getUploaderUrl() throws -> String

    /**
     * Get the uploader avatars
     * @throws ParsingException if there is an error in the extraction
     */
    func getUploaderAvatars() throws -> [Image]

    /**
     * Whether the uploader has been verified by the service's provider
     * @throws ParsingException if there is an error in the extraction
     */
    func isUploaderVerified() throws -> Bool

    /**
     * Get the original textual date provided by the service
     * @throws ParsingException if there is an error in the extraction
     */
    func getTextualUploadDate() throws -> String?

    /**
     * Extracts the upload date and time of this item and parses it
     * @throws ParsingException if there is an error in the extraction or parsing
     */
    func getUploadDate() throws -> DateWrapper?

    /**
     * Get the video's short description
     * @throws ParsingException if there is an error in the extraction
     */
    func getShortDescription() throws -> String?

    /**
     * Whether the stream is a short-form content
     * @throws ParsingException if there is an error in the extraction
     */
    func isShortFormContent() throws -> Bool
}

// Default Implementations for optional methods
public extension StreamInfoItemExtractor {
    /**
     * Default implementation: uploader avatars
     */
    func getUploaderAvatars() throws -> [Image] {
        return []
    }

    /**
     * Default implementation: short description
     */
    func getShortDescription() throws -> String? {
        return nil
    }

    /**
     * Default implementation: short-form content
     */
    func isShortFormContent() throws -> Bool {
        return false
    }
}

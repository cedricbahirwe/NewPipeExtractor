//
//  Frameset.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 18/11/2024.
//


/// Class to handle framesets / storyboards which summarize the stream content.
public final class Frameset: Codable {
    private let urls: [String]
    private let frameWidth: Int
    private let frameHeight: Int
    private let totalCount: Int
    private let durationPerFrame: Int
    private let framesPerPageX: Int
    private let framesPerPageY: Int

    /// Creates a new Frameset or set of storyboards.
    /// - Parameters:
    ///   - urls: The URLs to the images with frames / storyboards.
    ///   - frameWidth: The width of a single frame, in pixels.
    ///   - frameHeight: The height of a single frame, in pixels.
    ///   - totalCount: The total count of frames.
    ///   - durationPerFrame: The duration per frame in milliseconds.
    ///   - framesPerPageX: The maximum count of frames per page by x / over the width of the image.
    ///   - framesPerPageY: The maximum count of frames per page by y / over the height of the image.
    public init(urls: [String],
                frameWidth: Int,
                frameHeight: Int,
                totalCount: Int,
                durationPerFrame: Int,
                framesPerPageX: Int,
                framesPerPageY: Int) {
        self.urls = urls
        self.frameWidth = frameWidth
        self.frameHeight = frameHeight
        self.totalCount = totalCount
        self.durationPerFrame = durationPerFrame
        self.framesPerPageX = framesPerPageX
        self.framesPerPageY = framesPerPageY
    }

    /// List of URLs to images with frames.
    public var getUrls: [String] {
        return urls
    }

    /// Total count of frames.
    public var getTotalCount: Int {
        return totalCount
    }

    /// Maximum frames count by x.
    public var getFramesPerPageX: Int {
        return framesPerPageX
    }

    /// Maximum frames count by y.
    public var getFramesPerPageY: Int {
        return framesPerPageY
    }

    /// Width of a single frame, in pixels.
    public var getFrameWidth: Int {
        return frameWidth
    }

    /// Height of a single frame, in pixels.
    public var getFrameHeight: Int {
        return frameHeight
    }

    /// Duration per frame in milliseconds.
    public var getDurationPerFrame: Int {
        return durationPerFrame
    }

    /// Returns the information for the frame at the given stream position.
    ///
    /// - Parameter position: Position in milliseconds.
    /// - Returns: An array containing the bounds and URL where:
    ///   - `0`: Index of the URL
    ///   - `1`: Left bound
    ///   - `2`: Top bound
    ///   - `3`: Right bound
    ///   - `4`: Bottom bound
    public func getFrameBoundsAt(position: Int64) -> [Int] {
        if position < 0 || position > Int64(totalCount + 1) * Int64(durationPerFrame) {
            // Return the first frame as fallback.
            return [0, 0, 0, frameWidth, frameHeight]
        }

        let framesPerStoryboard = framesPerPageX * framesPerPageY
        let absoluteFrameNumber = min(Int(position / Int64(durationPerFrame)), totalCount)

        let relativeFrameNumber = absoluteFrameNumber % framesPerStoryboard

        let rowIndex = relativeFrameNumber / framesPerPageX
        let columnIndex = relativeFrameNumber % framesPerPageX

        return [
            /* storyboardIndex */ absoluteFrameNumber / framesPerStoryboard,
                                  /* left */ columnIndex * frameWidth,
                                  /* top */ rowIndex * frameHeight,
                                  /* right */ columnIndex * frameWidth + frameWidth,
                                  /* bottom */ rowIndex * frameHeight + frameHeight
        ]
    }
}

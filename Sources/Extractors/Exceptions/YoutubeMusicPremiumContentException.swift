//
//  YoutubeMusicPremiumContentException.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 20/11/2024.
//

import Foundation

public final class YoutubeMusicPremiumContentException: ContentNotAvailableException, @unchecked Sendable {
    public init() {
        super.init("This video is a YouTube Music Premium video")
    }

    public init(cause: Error) {
        super.init("This video is a YouTube Music Premium video", cause: cause)
    }
}

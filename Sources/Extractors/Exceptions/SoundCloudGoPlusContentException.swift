//
//  SoundCloudGoPlusContentException.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 20/11/2024.
//

import Foundation

public class SoundCloudGoPlusContentException: ContentNotAvailableException, @unchecked Sendable {
    public init() {
        super.init("This track is a SoundCloud Go+ track")
    }

    public init(cause: Error) {
        super.init("This track is a SoundCloud Go+ track", cause: cause)
    }
}

//
//  YoutubeService.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 10/09/2025.
//

public class YoutubeService: StreamingService, @unchecked Sendable {

    public init(_ id: Int) {
        super.init(id, "Youtube", [.audio, .video, .live, .comments])
    }

    public override func getBaseUrl() -> String {
        return "https://youtube.com"
    }


    public override func getStreamLHFactory() throws -> any LinkHandlerFactory {
        fatalError()
    }

}

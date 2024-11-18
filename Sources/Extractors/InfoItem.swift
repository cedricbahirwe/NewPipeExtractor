//
//  InfoItem.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 16/11/2024.
//

import Foundation

open class InfoItem: Codable {
    public enum InfoType: String, Codable {
        case stream
        case playlist
        case channel
        case comment
    }

    public let infoType: InfoType
    public let serviceId: Int
    public let url: String
    public let name: String

    private var thumbnails: [Image] = []

    public init(infoType: InfoType, serviceId: Int, url: String, name: String) {
        self.infoType = infoType
        self.serviceId = serviceId
        self.url = url
        self.name = name
    }

    public func getThumbnails() -> [Image] {
        return thumbnails
    }

    public func setThumbnails(_ thumbnails: [Image]) {
        self.thumbnails = thumbnails
    }

    public var toString: String {
        return "\(type(of: self))[url=\"\(url)\", name=\"\(name)\"]"
    }
}

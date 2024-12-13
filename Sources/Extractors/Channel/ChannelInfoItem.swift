//
//  ChannelInfoItem.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 18/11/2024.
//

import Foundation

public class ChannelInfoItem: InfoItem {
    private var description: String?
    private var subscriberCount: Int64 = -1
    private var streamCount: Int64 = -1
    private var verified: Bool = false

    public init(serviceId: Int, url: String, name: String) {
        super.init(infoType: .channel, serviceId: serviceId, url: url, name: name)
    }

    required init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }

    public func getDescription() -> String? {
        return description
    }

    public func setDescription(_ description: String?) {
        self.description = description
    }

    public func getSubscriberCount() -> Int64 {
        return subscriberCount
    }

    public func setSubscriberCount(_ subscriberCount: Int64) {
        self.subscriberCount = subscriberCount
    }

    public func getStreamCount() -> Int64 {
        return streamCount
    }

    public func setStreamCount(_ streamCount: Int64) {
        self.streamCount = streamCount
    }

    public func isVerified() -> Bool {
        return verified
    }

    public func setVerified(_ verified: Bool) {
        self.verified = verified
    }
}

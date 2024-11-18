//
//  ChannelInfo.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 18/11/2024.
//

import Foundation

/// A class representing channel information.
public class ChannelInfo: Info {
    private var parentChannelName: String?
    private var parentChannelUrl: String?
    private var feedUrl: String?
    private var subscriberCount: Int64 = -1
    private var description: String?
    private var donationLinks: [String] = []
    private var avatars: [Image] = []
    private var banners: [Image] = []
    private var parentChannelAvatars: [Image] = []
    private var verified: Bool = false
    private var tabs: [ListLinkHandler] = []
    private var tags: [String] = []

    public override init(
        serviceId: Int,
        id: String,
        url: String,
        originalUrl: String,
        name: String
    ) {
        super.init(serviceId: serviceId, id: id, url: url, originalUrl: originalUrl, name: name)
    }

    required init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }

    /// Factory method to fetch `ChannelInfo` from a URL.
    public static func getInfo(from url: String) throws -> ChannelInfo {
        let service = try NewPipe.getServiceByUrl(url)
        return try getInfo(from: service, url: url)
    }

    /// Factory method to fetch `ChannelInfo` for a given service and URL.
    public static func getInfo(from service: any StreamingService, url: String) throws -> ChannelInfo {
        let extractor = try service.getChannelExtractor(url)
        try extractor.fetchPage()
        return try getInfo(from: extractor)
    }

    /// Factory method to fetch `ChannelInfo` from a `ChannelExtractor`.
    public static func getInfo(from extractor: ChannelExtractor) throws -> ChannelInfo {
        let serviceId = extractor.getServiceId()
        let id = try extractor.getId()
        let url = try extractor.getUrl()
        let originalUrl = try extractor.getOriginalUrl()
        let name = try extractor.getName()

        let info = ChannelInfo(
            serviceId: serviceId,
            id: id,
            url: url,
            originalUrl: originalUrl,
            name: name
        )

        do { info.avatars = try extractor.getAvatars() } catch { info.addError(error) }
        do { info.banners = try extractor.getBanners() } catch { info.addError(error) }
        do { info.feedUrl = try extractor.getFeedUrl() } catch { info.addError(error) }
        do { info.subscriberCount = try extractor.getSubscriberCount() } catch { info.addError(error) }
        do { info.description = try extractor.getDescription() } catch { info.addError(error) }
        do { info.parentChannelName = try extractor.getParentChannelName() } catch { info.addError(error) }
        do { info.parentChannelUrl = try extractor.getParentChannelUrl() } catch { info.addError(error) }
        do { info.parentChannelAvatars = try extractor.getParentChannelAvatars() } catch { info.addError(error) }
        do { info.verified = try extractor.isVerified() } catch { info.addError(error) }
        do { info.tabs = try extractor.getTabs() } catch { info.addError(error) }
        do { info.tags = try extractor.getTags() } catch { info.addError(error) }

        return info
    }

    public func getParentChannelName() -> String? { return parentChannelName }
    public func setParentChannelName(_ name: String?) { self.parentChannelName = name }

    public func getParentChannelUrl() -> String? { return parentChannelUrl }
    public func setParentChannelUrl(_ url: String?) { self.parentChannelUrl = url }

    public func getFeedUrl() -> String? { return feedUrl }
    public func setFeedUrl(_ url: String?) { self.feedUrl = url }

    public func getSubscriberCount() -> Int64 { return subscriberCount }
    public func setSubscriberCount(_ count: Int64) { self.subscriberCount = count }

    public func getDescription() -> String? { return description }
    public func setDescription(_ desc: String?) { self.description = desc }

    public func getDonationLinks() -> [String] { return donationLinks }
    public func setDonationLinks(_ links: [String]) { self.donationLinks = links }

    public func getAvatars() -> [Image] { return avatars }
    public func setAvatars(_ images: [Image]) { self.avatars = images }

    public func getBanners() -> [Image] { return banners }
    public func setBanners(_ images: [Image]) { self.banners = images }

    public func getParentChannelAvatars() -> [Image] { return parentChannelAvatars }
    public func setParentChannelAvatars(_ images: [Image]) { self.parentChannelAvatars = images }

    public func isVerified() -> Bool { return verified }
    public func setVerified(_ verified: Bool) { self.verified = verified }

    public func getTabs() -> [ListLinkHandler] { return tabs }
    public func setTabs(_ tabs: [ListLinkHandler]) { self.tabs = tabs }

    public func getTags() -> [String] { return tags }
    public func setTags(_ tags: [String]) { self.tags = tags }
}

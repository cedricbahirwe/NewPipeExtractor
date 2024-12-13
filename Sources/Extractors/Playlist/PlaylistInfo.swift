//
//  PlaylistInfo.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 13/12/2024.
//


import Foundation

public class PlaylistInfo: ListInfo<StreamInfoItem> {

    public enum PlaylistType {
        /// A normal playlist (not a mix).
        case normal
        /// A mix made of streams related to a particular stream.
        case mixStream
        /// A mix made of music streams related to a particular stream.
        case mixMusic
        /// A mix made of streams from (or related to) the same channel.
        case mixChannel
        /// A mix made of streams related to a particular genre.
        case mixGenre
    }

    // MARK: - Properties

    private(set) var uploaderUrl: String = ""
    private(set) var uploaderName: String = ""
    private(set) var subChannelUrl: String?
    private(set) var subChannelName: String?
    private(set) var description: Description?
    private(set) var banners: [Image] = []
    private(set) var subChannelAvatars: [Image] = []
    private(set) var thumbnails: [Image] = []
    private(set) var uploaderAvatars: [Image] = []
    private(set) var streamCount: Int = 0
    private(set) var playlistType: PlaylistType = .normal

    // MARK: - Initializer

    private init(serviceId: Int, linkHandler: ListLinkHandler, name: String) {
        super.init(serviceId: serviceId, listUrlIdHandler: linkHandler, name: name)
    }

    required init(from decoder: any Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }

    // MARK: - Static Methods

    public static func getInfo(from url: String) throws -> PlaylistInfo {
        return try getInfo(service: try NewPipe.getServiceByUrl(url), url: url)
    }

    public static func getInfo(service: AnyStreamingService, url: String) throws -> PlaylistInfo {
        let extractor = try service.getPlaylistExtractor(url)
        try extractor.fetchPage()
        return try getInfo(from: extractor)
    }

    public static func getMoreItems(service: AnyStreamingService, url: String, page: Page) throws -> InfoItemsPage<StreamInfoItem> {
        return try service.getPlaylistExtractor(url).getPage(page)
    }

    /// Get PlaylistInfo from PlaylistExtractor
    /// - Parameter extractor:  an extractor where fetchPage() was already got called on.
    public static func getInfo(from extractor: PlaylistExtractor) throws -> PlaylistInfo {
        let info = try PlaylistInfo(
            serviceId: extractor.getServiceId(),
            linkHandler: extractor.getLinkHandler(),
            name: extractor.getName()
        )

        // collect uploader extraction failures until we are sure this is not
        // just a playlist without an uploader
        var uploaderParsingErrors: [Error] = []

        do {
            info.setOriginalUrl(try extractor.getOriginalUrl())
        } catch {
            info.addError(error)
        }

        // Additional property settings
        info.trySetValue { info.streamCount = try extractor.getStreamCount() }
        info.trySetValue { info.description = try extractor.getDescription() }
        info.trySetValue { info.thumbnails = try extractor.getThumbnails() }
        do {
            info.uploaderUrl = try extractor.getUploaderUrl()
        } catch {
            uploaderParsingErrors.append(error)
        }
        do {
            info.uploaderName = try extractor.getUploaderName()
        } catch {
            uploaderParsingErrors.append(error)
        }
        do {
            info.uploaderAvatars = try extractor.getUploaderAvatars()
        } catch {
            uploaderParsingErrors.append(error)
        }
        do {
            info.subChannelUrl = try extractor.getSubChannelUrl()
        } catch {
            uploaderParsingErrors.append(error)
        }
        do {
            info.subChannelName = try extractor.getSubChannelName()
        } catch {
            uploaderParsingErrors.append(error)
        }
        do {
            info.subChannelAvatars = try extractor.getSubChannelAvatars()
        } catch {
            uploaderParsingErrors.append(error)
        }
        info.trySetValue { info.banners = try extractor.getBanners() }
        info.trySetValue { info.playlistType = try extractor.getPlaylistType() }

        // do not fail if everything but the uploader infos could be collecte
        // TODO: - Better comment
        if (!uploaderParsingErrors.isEmpty && (!info.getErrors().isEmpty || uploaderParsingErrors.count < 3)) {
            info.addAllErrors(uploaderParsingErrors);
        }

        let itemsPage = ExtractorHelper.getItemsPageOrLogError(info: info, extractor: extractor)
        info.setRelatedItems(itemsPage.getItems())
        info.setNextPage(itemsPage.getNextPage())

        return info
    }
}

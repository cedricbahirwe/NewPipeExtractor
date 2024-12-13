//
//  PlaylistInfoItemsCollector.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 13/12/2024.
//

import Foundation

public class PlaylistInfoItemsCollector<E: PlaylistInfoItemExtractor>: InfoItemsCollector<PlaylistInfoItem, E> {

    public override func extract(extractor: E) throws -> PlaylistInfoItem {
        let resultItem = PlaylistInfoItem(
            serviceId: getServiceId(),
            url: try extractor.getUrl(),
            name: try extractor.getName()
        )

        trySetValue {
            resultItem.setUploaderName(try extractor.getUploaderName())
        }

        trySetValue {
            resultItem.setUploaderUrl(try extractor.getUploaderUrl())
        }

        trySetValue {
            resultItem.setUploaderVerified(try extractor.isUploaderVerified())
        }

        trySetValue {
            resultItem.setThumbnails(try extractor.getThumbnails())
        }

        trySetValue {
            resultItem.setStreamCount(try extractor.getStreamCount())
        }

        trySetValue {
            resultItem.setDescription(try extractor.getDescription())
        }

        trySetValue {
            resultItem.setPlaylistType(try extractor.getPlaylistType())
        }

        trySetValue {
            resultItem.setPlaylistType(try extractor.getPlaylistType())
        }

        return resultItem
    }

    private func trySetValue(_ block: () throws -> Void) {
        do {
            try block()
        } catch {
            self.addError(error)
        }
    }
}

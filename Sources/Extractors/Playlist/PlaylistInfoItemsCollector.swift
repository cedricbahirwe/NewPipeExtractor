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

        do {
            resultItem.setUploaderName(try extractor.getUploaderName())
        } catch {
            addError(error)
        }

        do {
            resultItem.setUploaderUrl(try extractor.getUploaderUrl())
        } catch {
            addError(error)
        }

        do {
            resultItem.setUploaderVerified(try extractor.isUploaderVerified())
        } catch {
            addError(error)
        }

        do {
            resultItem.setThumbnails(try extractor.getThumbnails())
        } catch {
            addError(error)
        }

        do {
            resultItem.setStreamCount(try extractor.getStreamCount())
        } catch {
            addError(error)
        }

        do {
            resultItem.setDescription(try extractor.getDescription())
        } catch {
            addError(error)
        }

        do {
            resultItem.setPlaylistType(try extractor.getPlaylistType())
        } catch {
            addError(error)
        }

        return resultItem
    }
}

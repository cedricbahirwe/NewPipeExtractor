//
//  ChannelInfoItemsCollector.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 18/11/2024.
//

import Foundation

public final class ChannelInfoItemsCollector<R: ChannelInfoItemExtractor>: InfoItemsCollector<ChannelInfoItem, R> {
    public override init(serviceId: Int) {
        super.init(serviceId: serviceId)
    }

    public override func extract(extractor: R) throws -> ChannelInfoItem {
        let resultItem = ChannelInfoItem(serviceId: getServiceId(), url: try extractor.getUrl(), name: try extractor.getName())

        // optional information
        do {
            resultItem.setSubscriberCount(try extractor.getSubscriberCount())
        } catch {
            addError(error)
        }
        do {
            resultItem.setStreamCount(try extractor.getStreamCount())
        } catch {
            addError(error)
        }
        do {
            resultItem.setThumbnails(try extractor.getThumbnails())
        } catch {
            addError(error)
        }
        do {
            resultItem.setDescription(try extractor.getDescription())
        } catch {
            addError(error)
        }
        do {
            resultItem.setVerified(try extractor.isVerified())
        } catch {
            addError(error)
        }

        return resultItem
    }
}

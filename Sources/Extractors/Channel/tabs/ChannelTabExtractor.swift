//
//  ChannelTabExtractor.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 18/11/2024.
//

import Foundation

/// A `ListExtractor` of `InfoItem`s for tabs of channels.
public class ChannelTabExtractor: ListExtractor<InfoItem> {

    override init(_ service: StreamingService, _ linkHandler: ListLinkHandler) {
        super.init(service, linkHandler)
    }

    override open func getName() -> String {
        return getLinkHandler().getContentFilters().first ?? ""
    }
}

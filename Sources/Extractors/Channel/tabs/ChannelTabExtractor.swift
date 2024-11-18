//
//  ChannelTabExtractor.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 18/11/2024.
//

import Foundation

/// A `ListExtractor` of `InfoItem`s for tabs of channels.
open class ChannelTabExtractor: ListExtractor<InfoItem> {

    override init(service: any StreamingService, linkHandler: ListLinkHandler) {
        super.init(service: service, linkHandler: linkHandler)
    }

    override open func getName() -> String {
        return getLinkHandler().getContentFilters().first ?? ""
    }
}

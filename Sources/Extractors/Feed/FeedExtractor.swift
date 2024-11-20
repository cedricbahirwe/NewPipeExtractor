//
//  FeedExtractor.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 20/11/2024.
//


/// This class helps to extract items from lightweight feeds that the services may provide.
/// 
/// YouTube is an example of a service that has this alternative available.
public class FeedExtractor: ListExtractor<StreamInfoItem> {
    
    public init(service: any StreamingService, listLinkHandler: ListLinkHandler) {
        super.init(service: service, linkHandler: listLinkHandler)
    }
}

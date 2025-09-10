//
//  KioskExtractor.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 20/11/2024.
//


/// Abstract class for extracting kiosk items.
public class KioskExtractor<T: InfoItem>: ListExtractor<T> {
    private let id: String

    public init(streamingService: StreamingService, linkHandler: ListLinkHandler, kioskId: String) {
        self.id = kioskId
        super.init(streamingService, linkHandler)
    }

    open override func getId() -> String {
        return self.id
    }
}

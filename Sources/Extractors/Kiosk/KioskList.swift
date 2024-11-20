//
//  KioskList.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 20/11/2024.
//


import Foundation

/// Represents a list of kiosks for a streaming service.
public class KioskList {

    /// Protocol for a factory that creates `KioskExtractor` instances.
    public protocol KioskExtractorFactory {
        func createNewKiosk<T: InfoItem>(
            streamingService: any StreamingService,
            url: String,
            kioskId: String
        ) throws -> KioskExtractor<T>
    }

    private let service: any StreamingService
    private var kioskList: [String: KioskEntry] = [:]
    private var defaultKiosk: String?
    private var forcedLocalization: Localization?
    private var forcedContentCountry: ContentCountry?

    private class KioskEntry {
        let extractorFactory: KioskExtractorFactory
        let handlerFactory: ListLinkHandlerFactory

        init(extractorFactory: KioskExtractorFactory, handlerFactory: ListLinkHandlerFactory) {
            self.extractorFactory = extractorFactory
            self.handlerFactory = handlerFactory
        }
    }

    /// Initializes the kiosk list for a given streaming service.
    public init(service: any StreamingService) {
        self.service = service
    }

    /// Adds a new kiosk entry to the list.
    public func addKioskEntry(
        extractorFactory: KioskExtractorFactory,
        handlerFactory: ListLinkHandlerFactory,
        id: String
    ) throws {
        guard kioskList[id] == nil else {
            throw NSError(domain: "KioskListError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Kiosk with type \(id) already exists."])
        }
        kioskList[id] = KioskEntry(extractorFactory: extractorFactory, handlerFactory: handlerFactory)
    }

    /// Sets the default kiosk type.
    public func setDefaultKiosk(_ kioskType: String) {
        defaultKiosk = kioskType
    }

    public func getDefaultKioskExtractor() throws -> KioskExtractor<InfoItem> {
        try getDefaultKioskExtractor(nextPage: nil)
    }

    public func getDefaultKioskExtractor(nextPage: Page?) throws -> KioskExtractor<InfoItem> {
        try getDefaultKioskExtractor(nextPage: nextPage, localization: NewPipe.getPreferredLocalization())
    }

    public func getDefaultKioskExtractor(nextPage: Page?, localization: Localization) throws -> KioskExtractor<InfoItem> {
        if !Utils.isNullOrEmpty(defaultKiosk) {
            return try getExtractorById(kioskId: defaultKiosk!, nextPage: nextPage, localization: localization)
        } else if let first = kioskList.keys.first {
            return try getExtractorById(kioskId: first, nextPage: nextPage, localization: localization)
        } else {
            throw ExtractionException("No kiosk extractor found")
        }
    }

    public func getExtractorById<T: InfoItem>(kioskId: String, nextPage: Page?, localization: Localization) throws -> KioskExtractor<T> {
        guard let entry = kioskList[kioskId] else {
            throw ExtractionException("No kiosk found with the type: \(kioskId)")
        }

        let handler = try entry.handlerFactory.fromId(kioskId)
        let extractor: KioskExtractor<T> = try entry.extractorFactory.createNewKiosk(streamingService: service, url: handler.getUrl(), kioskId: kioskId)

        if let forcedLocalization = forcedLocalization {
            extractor.forceLocalization(forcedLocalization)
        }
        if let forcedContentCountry = forcedContentCountry {
            extractor.forceContentCountry(forcedContentCountry)
        }

        return extractor
    }

    /// Gets the list of available kiosk IDs.
    public func getAvailableKiosks() -> [String] {
        return Array(kioskList.keys)
    }

    public func getExtractorByUrl<T: InfoItem>(url: String, nextPage: Page?) throws -> KioskExtractor<T> {
        return try getExtractorByUrl(url: url, nextPage: nextPage, localization: NewPipe.getPreferredLocalization());
    }

    public func getExtractorByUrl<T: InfoItem>(url: String, nextPage: Page?, localization: Localization) throws -> KioskExtractor<T> {
        for (id, entry) in kioskList {
            if try entry.handlerFactory.acceptUrl(url) {
                return try getExtractorById(kioskId: id, nextPage: nextPage, localization: localization)
            }
        }
        throw ExtractionException("Could not find a kiosk that fits the URL: \(url)")
    }

    /// Gets the handler factory for a specific kiosk type.
    public func getListLinkHandlerFactoryByType(type: String) -> ListLinkHandlerFactory? {
        return kioskList[type]?.handlerFactory
    }

    /// Forces a specific localization for kiosk extractors.
    public func forceLocalization(_ localization: Localization?) {
        self.forcedLocalization = localization
    }
    
    /// Forces a specific content country for kiosk extractors.
    public func forceContentCountry(_ contentCountry: ContentCountry?) {
        self.forcedContentCountry = contentCountry
    }
}

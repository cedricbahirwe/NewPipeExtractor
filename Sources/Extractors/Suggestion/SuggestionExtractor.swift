//
//  StreamingService.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 13/12/2024.
//


import Foundation

public class SuggestionExtractor {
    private let service: AnyStreamingService
    private var forcedLocalization: Localization?
    private var forcedContentCountry: ContentCountry?

    public init(service: AnyStreamingService) {
        self.service = service
    }

    public func suggestionList(query: String) throws -> [String] {
        fatalError("This method must be overridden in a subclass")
    }

    public func getServiceId() -> Int {
        service.getServiceId()
    }

    public func getService() -> AnyStreamingService {
        service
    }

    public func forceLocalization(_ localization: Localization?) {
        self.forcedLocalization = localization
    }

    public func forceContentCountry(_ contentCountry: ContentCountry?) {
        self.forcedContentCountry = contentCountry
    }

    public func getExtractorLocalization() -> Localization {
        if let forcedLocalization {
            return forcedLocalization
        } else {
            return service.getLocalization()
        }
    }

    public func getExtractorContentCountry() -> ContentCountry {
        if let forcedContentCountry {
            return forcedContentCountry
        } else {
            return service.getContentCountry()
        }
    }
}

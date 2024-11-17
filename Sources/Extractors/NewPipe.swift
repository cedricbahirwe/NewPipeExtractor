//
//  NewPipe.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 16/11/2024.
//

import Foundation

public final class NewPipe {
    nonisolated(unsafe) private static var downloader: Downloader!
    nonisolated(unsafe) private static var preferredLocalization: Localization!// = Localization.DEFAULT
    nonisolated(unsafe) private static var preferredContentCountry: ContentCountry!// = ContentCountry.DEFAULT

    private init() {}

    public static func `init`(_ d: Downloader) {
        `init`(d, Localization.DEFAULT)
    }

    public static func `init`(_ d: Downloader, _ l: Localization) {
        let contentCountry = l.getCountryCode().isEmpty
        ? ContentCountry.DEFAULT
        : ContentCountry(l.getCountryCode())
        `init`(d, l, contentCountry)
    }

    public static func `init`(_ d: Downloader, _ l: Localization, _ c: ContentCountry) {
        downloader = d
        preferredLocalization = l
        preferredContentCountry = c
    }

    public static func getDownloader() -> Downloader? {
        return downloader
    }

    // MARK: - Utils

    public static func getServices() -> [any StreamingService] {
        return ServiceList.all()
    }

    public static func getService(_ serviceId: Int) throws -> any StreamingService {
        if let service = ServiceList.all().first(where: { $0.getServiceId() == serviceId }) {
            return service
        }
        throw ExtractionException("There's no service with the id = \"\(serviceId)\"")
    }

    public static func getService(_ serviceName: String) throws -> any StreamingService {
        if let service = ServiceList.all().first(where: { $0.getServiceInfo().getName() == serviceName }) {
            return service
        }
        throw ExtractionException("There's no service with the name = \"\(serviceName)\"")
    }

    public static func getServiceByUrl(_ url: String) throws -> any StreamingService {
        for service in ServiceList.all() {
            if try service.getLinkTypeByUrl(url) != .none {
                return service
            }
        }
        throw ExtractionException("No service can handle the url = \"\(url)\"")
    }

    // MARK: - Localization

    public static func setupLocalization(_ thePreferredLocalization: Localization) {
        setupLocalization(thePreferredLocalization, nil)
    }

    public static func setupLocalization(_ thePreferredLocalization: Localization,
                                         _ thePreferredContentCountry: ContentCountry?) {
        preferredLocalization = thePreferredLocalization

        if let thePreferredContentCountry = thePreferredContentCountry {
            preferredContentCountry = thePreferredContentCountry
        } else {
            preferredContentCountry = thePreferredLocalization.getCountryCode().isEmpty
            ? ContentCountry.DEFAULT
                : ContentCountry(thePreferredLocalization.getCountryCode())
        }
    }

    public static func getPreferredLocalization() -> Localization {
        return preferredLocalization
    }

    public static func setPreferredLocalization(_ localization: Localization) {
        preferredLocalization = localization
    }

    public static func getPreferredContentCountry() -> ContentCountry {
        return preferredContentCountry
    }

    public static func setPreferredContentCountry(_ contentCountry: ContentCountry) {
        preferredContentCountry = contentCountry
    }
}

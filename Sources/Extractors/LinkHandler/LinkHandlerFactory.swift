//
//  LinkHandlerFactory.swift
//  NewPipe
//
//  Created by Cédric Bahirwe on 15/11/2024.
//

import Foundation

public protocol LinkHandlerFactory {
    // MARK: - To Override

    func getId(_ url: String) throws -> String
    func getUrl(_ id: String) throws -> String
    func onAcceptUrl(_ url: String) throws -> Bool
    func getUrl(_ id: String, _ baseUrl: String) throws -> String


    func fromUrl(_ url: String) throws -> LinkHandler
    func fromUrl(_ url: String, _ baseUrl: String) throws -> LinkHandler
    func fromId(_ id: String) throws -> LinkHandler
    func fromId(_ id: String, _ baseUrl: String) throws -> LinkHandler
}

extension LinkHandlerFactory {
    // MARK: - Logic
    /**
     * Builds a {@link LinkHandler} from a url.<br>
     * Be sure to call {@link Utils#followGoogleRedirectIfNeeded(String)} on the url if overriding
     * this function.
     *
     * @param url the url to extract path and id from
     * @return a {@link LinkHandler} complete with information
     */
    public func fromUrl(_ url: String) throws -> LinkHandler {
        let polishedUrl = try Utils.followGoogleRedirectIfNeeded(url);
        let baseUrl = try Utils.getBaseUrl(polishedUrl);
        return try fromUrl(polishedUrl, baseUrl);
    }

    /**
     * Builds a {@link LinkHandler} from an URL and a base URL. The URL is expected to be already
     * polished from Google search redirects (otherwise how could {@code baseUrl} have been
     * extracted?).<br>
     * So do not call {@link Utils#followGoogleRedirectIfNeeded(String)} on the URL if overriding
     * this function, since that should be done in {@link #fromUrl(String)}.
     *
     * @param url     the URL without Google search redirects to extract id from
     * @param baseUrl the base URL
     * @return a {@link LinkHandler} complete with information
     */
    public func fromUrl(_ url: String, _ baseUrl: String) throws -> LinkHandler {
        if (try !acceptUrl(url)) {
            throw ParsingException("URL not accepted: " + url)
        }

        let id: String = try getId(url)
        return LinkHandler(url, try getUrl(id, baseUrl), id)
    }

    public func fromId(_ id: String) throws -> LinkHandler {
        let url = try getUrl(id);
        return LinkHandler(url, url, id)
    }

    public func fromId(_ id: String, _ baseUrl: String) throws -> LinkHandler {
        let url = try getUrl(id, baseUrl)
        return LinkHandler(url, url, id)
    }

    /**
     * When a VIEW_ACTION is caught this function will test if the url delivered within the calling
     * Intent was meant to be watched with this Service.
     * Return false if this service shall not allow to be called through ACTIONs.
     */
    public func acceptUrl(_ url: String) throws -> Bool {
        try onAcceptUrl(url);
    }
}

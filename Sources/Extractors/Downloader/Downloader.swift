//
//  Downloader.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 16/11/2024.
//

import Foundation

/// A base for downloader implementations that NewPipe will use
/// to download needed resources during extraction.
open class Downloader {

    /// Do a GET request to get the resource that the URL is pointing to.
    ///
    /// This method calls `get(url:headers:localization:)` with the default preferred
    /// localization. It should only be used when the resource that will be fetched won't be affected
    /// by the localization.
    ///
    /// - Parameter url: The URL that is pointing to the wanted resource.
    /// - Returns: The result of the GET request.
    /// - Throws: An error if the request fails or reCAPTCHA is encountered.
    open func get(_ url: String) throws -> Response {
        return try get(url, headers: nil, localization: NewPipe.getPreferredLocalization())
    }

    /// Do a GET request to get the resource that the URL is pointing to.
    ///
    /// It will set the `Accept-Language` header to the language of the localization parameter.
    ///
    /// - Parameters:
    ///   - url: The URL that is pointing to the wanted resource.
    ///   - localization: The source of the value of the `Accept-Language` header.
    /// - Returns: The result of the GET request.
    /// - Throws: An error if the request fails or reCAPTCHA is encountered.
    open func get(_ url: String, localization: Localization) throws -> Response {
        return try get(url, headers: nil, localization: localization)
    }

    /// Do a GET request with the specified headers.
    ///
    /// - Parameters:
    ///   - url: The URL that is pointing to the wanted resource.
    ///   - headers: A list of headers that will be used in the request.
    ///     Any default headers **should** be overridden by these.
    /// - Returns: The result of the GET request.
    /// - Throws: An error if the request fails or reCAPTCHA is encountered.
    open func get(_ url: String, headers: [String: List<String>]?) throws -> Response {
        return try get(url, headers: headers, localization: NewPipe.getPreferredLocalization())
    }

    /// Do a GET request with the specified headers.
    ///
    /// It will set the `Accept-Language` header to the language of the localization parameter.
    ///
    /// - Parameters:
    ///   - url: The URL that is pointing to the wanted resource.
    ///   - headers: A list of headers that will be used in the request.
    ///     Any default headers **should** be overridden by these.
    ///   - localization: The source of the value of the `Accept-Language` header.
    /// - Returns: The result of the GET request.
    /// - Throws: An error if the request fails or reCAPTCHA is encountered.
    open func get(_ url: String, headers: Dictionary<String, List<String>>?, localization: Localization) throws -> Response {
        let request = Request.newBuilder()
            .get(url)
            .headers(headers)
            .localization(localization)
            .build()
        return try execute(request)
    }

    /// Do a HEAD request.
    ///
    /// - Parameter url: The URL that is pointing to the wanted resource.
    /// - Returns: The result of the HEAD request.
    /// - Throws: An error if the request fails or reCAPTCHA is encountered.
    open func head(_ url: String) throws -> Response {
        return try head(url, headers: nil)
    }

    /// Do a HEAD request with the specified headers.
    ///
    /// - Parameters:
    ///   - url: The URL that is pointing to the wanted resource.
    ///   - headers: A list of headers that will be used in the request.
    ///     Any default headers **should** be overridden by these.
    /// - Returns: The result of the HEAD request.
    /// - Throws: An error if the request fails or reCAPTCHA is encountered.
    open func head(_ url: String, headers: [String: [String]]?) throws -> Response {
        let request = Request.newBuilder()
            .head(url)
            .headers(headers)
            .build()
        return try execute(request)
    }

    /// Do a POST request with the specified headers, sending the data array.
    ///
    /// - Parameters:
    ///   - url: The URL that is pointing to the wanted resource.
    ///   - headers: A list of headers that will be used in the request.
    ///     Any default headers **should** be overridden by these.
    ///   - dataToSend: Byte array that will be sent when doing the request.
    /// - Returns: The result of the POST request.
    /// - Throws: An error if the request fails or reCAPTCHA is encountered.
    open func post(_ url: String, headers: [String: [String]]?, dataToSend: Data?) throws -> Response {
        return try post(url, headers: headers, dataToSend: dataToSend, localization: NewPipe.getPreferredLocalization())
    }

    /// Do a POST request with the specified headers, sending the data array.
    ///
    /// It will set the `Accept-Language` header to the language of the localization parameter.
    ///
    /// - Parameters:
    ///   - url: The URL that is pointing to the wanted resource.
    ///   - headers: A list of headers that will be used in the request.
    ///     Any default headers **should** be overridden by these.
    ///   - dataToSend: Byte array that will be sent when doing the request.
    ///   - localization: The source of the value of the `Accept-Language` header.
    /// - Returns: The result of the POST request.
    /// - Throws: An error if the request fails or reCAPTCHA is encountered.
    open func post(_ url: String, headers: [String: [String]]?, dataToSend: Data?, localization: Localization) throws -> Response {
        let request = Request.newBuilder()
            .post(url, dataToSendToSet: dataToSend)
            .headers(headers)
            .localization(localization)
            .build()
        return try execute(request)
    }

    /// Do a request using the specified `Request` object.
    ///
    /// - Parameter request: The `Request` object containing all request details.
    /// - Returns: The result of the request.
    /// - Throws: An error if the request fails or reCAPTCHA is encountered.
    open func execute(_ request: Request) throws -> Response {
        fatalError("This method must be overridden by subclasses")
    }
}

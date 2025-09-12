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
    open func get(_ url: String) async throws -> Response {
        return try await get(url, headers: nil, localization: NewPipe.getPreferredLocalization())
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
    open func get(_ url: String, localization: Localization) async throws -> Response {
        return try await get(url, headers: nil, localization: localization)
    }

    /// Do a GET request with the specified headers.
    ///
    /// - Parameters:
    ///   - url: The URL that is pointing to the wanted resource.
    ///   - headers: A list of headers that will be used in the request.
    ///     Any default headers **should** be overridden by these.
    /// - Returns: The result of the GET request.
    /// - Throws: An error if the request fails or reCAPTCHA is encountered.
    open func get(_ url: String, headers: [String: List<String>]?) async throws -> Response {
        return try await get(url, headers: headers, localization: NewPipe.getPreferredLocalization())
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
    open func get(_ url: String, headers: Dictionary<String, List<String>>?, localization: Localization) async throws -> Response {
        let request = Request.newBuilder()
            .get(url)
            .headers(headers)
            .localization(localization)
            .build()
        return try await execute(request)
    }

    /// Do a HEAD request.
    ///
    /// - Parameter url: The URL that is pointing to the wanted resource.
    /// - Returns: The result of the HEAD request.
    /// - Throws: An error if the request fails or reCAPTCHA is encountered.
    open func head(_ url: String) async throws -> Response {
        return try await head(url, headers: nil)
    }

    /// Do a HEAD request with the specified headers.
    ///
    /// - Parameters:
    ///   - url: The URL that is pointing to the wanted resource.
    ///   - headers: A list of headers that will be used in the request.
    ///     Any default headers **should** be overridden by these.
    /// - Returns: The result of the HEAD request.
    /// - Throws: An error if the request fails or reCAPTCHA is encountered.
    open func head(_ url: String, headers: [String: [String]]?) async throws -> Response {
        let request = Request.newBuilder()
            .head(url)
            .headers(headers)
            .build()
        return try await execute(request)
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
    open func post(_ url: String, headers: [String: [String]]?, dataToSend: Data?) async throws -> Response {
        return try await post(url, headers: headers, dataToSend: dataToSend, localization: NewPipe.getPreferredLocalization())
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
    open func post(_ url: String, headers: [String: [String]]?, dataToSend: Data?, localization: Localization) async throws -> Response {
        let request = Request.newBuilder()
            .post(url, dataToSendToSet: dataToSend)
            .headers(headers)
            .localization(localization)
            .build()
        return try await execute(request)
    }

    /// Sends a POST request with a specific Content-Type and optional headers and body.
    /// - Parameters:
    ///   - url: The URL pointing to the resource.
    ///   - headers: Optional dictionary of headers; these override any default headers.
    ///   - dataToSend: Optional data to send in the request body.
    ///   - localization: Localization object providing the Accept-Language value.
    ///   - contentType: The MIME type of the request body.
    /// - Throws: `URLError` for network errors or custom `ReCaptchaError`.
    /// - Returns: A `Response` object representing the result of the POST request.
    public func postWithContentType(_ url: String, headers: [String: [String]]?, dataToSend: Data?,
    localization: Localization, contentType: String) async throws -> Response {
        var actualHeaders = headers ?? [:]
        actualHeaders["Content-Type"] = [contentType]
        return try await post(url, headers: headers, dataToSend: dataToSend, localization: localization)
    }

    /// Sends a POST request with `application/json` as the Content-Type.
    /// - Parameters:
    ///   - url: The URL pointing to the resource.
    ///   - headers: Optional dictionary of headers; these override any default headers.
    ///   - dataToSend: Optional data to send in the request body.
    ///   - localization: Localization object providing the Accept-Language value.
    /// - Throws: `URLError` for network errors or custom `ReCaptchaError`.
    /// - Returns: A `Response` object representing the result of the POST request.
    public func postWithContentTypeJson(
        url: String,
        headers: [String: [String]]? = nil,
        dataToSend: Data? = nil,
        localization: Localization
    ) async throws -> Response {
        return try await postWithContentType(
            url,
            headers: headers,
            dataToSend: dataToSend,
            localization: localization,
            contentType: "application/json"
        )
    }

    /// Sends a POST request with `application/json` as the Content-Type,
    /// using the preferred localization.
    /// - Parameters:
    ///   - url: The URL pointing to the resource.
    ///   - headers: Optional dictionary of headers.
    ///   - dataToSend: Optional request body data.
    /// - Throws: `URLError` for network errors or custom `ReCaptchaError`.
    /// - Returns: A `Response` object representing the result of the POST request.
    public func postWithContentTypeJson(
        url: String,
        headers: [String: [String]]? = nil,
        dataToSend: Data? = nil
    ) async throws -> Response {
        return try await postWithContentTypeJson(
            url: url,
            headers: headers,
            dataToSend: dataToSend,
            localization: NewPipe.getPreferredLocalization()
        )
    }

    /// Do a request using the specified `Request` object.
    ///
    /// - Returns: The result of the request.
    open func execute(_ request: Request) async throws -> Response {
        fatalError("This method must be overridden by subclasses")
    }
}

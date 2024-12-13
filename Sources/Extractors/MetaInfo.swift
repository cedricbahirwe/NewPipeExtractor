//
//  MetaInfo.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 17/11/2024.
//

import Foundation

/// Represents meta information, including a title, description, URLs, and URL texts.
public class MetaInfo: Codable {

    // MARK: - Properties

    /// Title of the meta info. Can be empty.
    private var title: String = ""

    /// Content description.
    private var content: Description?

    /// List of associated URLs.
    private var urls: [URL] = []

    /// List of associated URL texts.
    private var urlTexts: [String] = []

    // MARK: - Initializers

    /// Initializes a `MetaInfo` instance with the given parameters.
    ///
    /// - Parameters:
    ///   - title: The title of the meta info.
    ///   - content: The description content.
    ///   - urls: A list of associated URLs.
    ///   - urlTexts: A list of associated URL texts.
    public  init(title: String, content: Description?, urls: [URL], urlTexts: [String]) {
        self.title = title
        self.content = content
        self.urls = urls
        self.urlTexts = urlTexts
    }

    /// Default initializer for creating an empty `MetaInfo` instance.
    public init() {}

    // MARK: - Accessors

    /// Gets the title of the meta info.
    ///
    /// - Returns: The title as a `String`.
    public func getTitle() -> String {
        return title
    }

    /// Sets the title of the meta info.
    ///
    /// - Parameter title: The new title.
    public func setTitle(_ title: String) {
        self.title = title
    }

    /// Gets the description content.
    ///
    /// - Returns: The `Description` object.
    public func getContent() -> Description? {
        return content
    }

    /// Sets the description content.
    ///
    /// - Parameter content: The new description content.
    public  func setContent(_ content: Description) {
        self.content = content
    }

    /// Gets the list of associated URLs.
    ///
    /// - Returns: A list of `URL` objects.
    public func getUrls() -> [URL] {
        return urls
    }

    /// Sets the list of associated URLs.
    ///
    /// - Parameter urls: The new list of URLs.
    public func setUrls(_ urls: [URL]) {
        self.urls = urls
    }

    /// Adds a URL to the list of associated URLs.
    ///
    /// - Parameter url: The URL to add.
    public func addUrl(_ url: URL) {
        urls.append(url)
    }

    /// Gets the list of associated URL texts.
    ///
    /// - Returns: A list of `String` objects.
    public  func getUrlTexts() -> [String] {
        return urlTexts
    }

    /// Sets the list of associated URL texts.
    ///
    /// - Parameter urlTexts: The new list of URL texts.
    public func setUrlTexts(_ urlTexts: [String]) {
        self.urlTexts = urlTexts
    }

    /// Adds a URL text to the list of associated URL texts.
    ///
    /// - Parameter urlText: The URL text to add.
    public func addUrlText(_ urlText: String) {
        urlTexts.append(urlText)
    }
}

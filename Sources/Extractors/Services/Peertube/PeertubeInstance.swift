//
//  PeertubeInstance.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 16/11/2024.
//

import Foundation

public final class PeertubeInstance: Sendable {
    private let url: String
    @MainActor private var name: String

    public static let defaultInstance = PeertubeInstance("https://framatube.org", "FramaTube")

    public init(_ url: String) {
        self.url = url
        self.name = "PeerTube"
    }

    public init(_ url: String, _ name: String) {
        self.url = url
        self.name = name
    }

    public func getUrl() -> String {
        return url
    }

    @MainActor
    public func fetchInstanceMetaData() throws {
        let response: Response
        do {
            guard let downloader = NewPipe.getDownloader() else {
                throw Exception("No downloader is configured for NewPipe.")
            }
            response = try downloader.get(url + "/api/v1/config")
        } catch let error as ReCaptchaException {
            throw Exception("Unable to configure instance \(url)", error)
        } catch let error {
            throw Exception("Unable to configure instance \(url)", error)
        }

        guard !Utils.isBlank(response.responseBody) else {
            throw Exception("Unable to configure instance \(url)")
        }

        print("I receive body", response.responseBody)

        do {
            guard let jsonData = response.responseBody.data(using: .utf8) else {
                throw Exception("Invalid json body")
            }

            let jsonString = try JSONSerialization.jsonObject(with: jsonData)

            guard let instanceName = ((jsonString as? [String: Any])?["instance"] as? [String: String])?["name"] else {
                throw ParsingException("Invalid json body structure")
            }

            self.name = instanceName
        } catch let error as ParsingException {
            throw Exception("Unable to parse instance config", error)
        } catch let error {
            throw Exception("Unable to parse instance config", error)
        }
    }

    @MainActor
    public func getName() -> String {
        return name
    }
}

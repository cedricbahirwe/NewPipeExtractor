//
//  Image.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 16/11/2024.
//

import Foundation

/// A class representing images in the extractor.
///
/// An image has four properties: its URL, its height, its width, and its estimated quality level.
/// Depending on the service, the height, the width, or both properties may be unknown.
/// In such cases, use the relevant unknown constants (`HEIGHT_UNKNOWN` and `WIDTH_UNKNOWN`) to indicate the lack of knowledge.
public final class Image: Codable {

    /// Constant representing that the height of an `Image` is unknown.
    public static let HEIGHT_UNKNOWN = -1

    /// Constant representing that the width of an `Image` is unknown.
    public static let WIDTH_UNKNOWN = -1

    /// The URL of the image. Always non-nil.
    public let url: String

    /// The height of the image. Defaults to `HEIGHT_UNKNOWN` if unknown.
    public let height: Int

    /// The width of the image. Defaults to `WIDTH_UNKNOWN` if unknown.
    public let width: Int

    /// The estimated resolution level of the image. Always non-nil.
    public let estimatedResolutionLevel: ResolutionLevel

    /// Initializes an `Image` instance.
    ///
    /// - Parameters:
    ///   - url: The URL of the image. Must not be empty.
    ///   - height: The height of the image.
    ///   - width: The width of the image.
    ///   - estimatedResolutionLevel: The estimated resolution level of the image. Must not be nil.
    public init(url: String, height: Int, width: Int, estimatedResolutionLevel: ResolutionLevel) {
        guard !url.isEmpty else {
            fatalError("URL must not be empty")
        }

        self.url = url
        self.height = height
        self.width = width
        self.estimatedResolutionLevel = estimatedResolutionLevel
    }

    /// Returns a string representation of this `Image` instance.
    public var description: String {
        return "Image {url=\(url), height=\(height), width=\(width), estimatedResolutionLevel=\(estimatedResolutionLevel)}"
    }
}

/// An enum representing the estimated resolution level of an `Image`.
///
/// Some services don't return the size of their images, but we may know an approximation of the resolution level.
public enum ResolutionLevel: String, Codable {
    /// High resolution level (height >= 720px).
    case high = "HIGH"
    /// Medium resolution level (175px <= height < 720px).
    case medium = "MEDIUM"
    /// Low resolution level (1px <= height < 175px).
    case low = "LOW"
    /// Unknown resolution level (height is unknown or invalid).
    case unknown = "UNKNOWN"

    /// Returns the appropriate `ResolutionLevel` based on the given height.
    ///
    /// - Parameter heightPx: The height of the image in pixels.
    /// - Returns: The `ResolutionLevel` corresponding to the provided height.
    public static func from(height heightPx: Int) -> ResolutionLevel {
        switch heightPx {
        case ..<1:
            return .unknown
        case 1..<175:
            return .low
        case 175..<720:
            return .medium
        default:
            return .high
        }
    }
}

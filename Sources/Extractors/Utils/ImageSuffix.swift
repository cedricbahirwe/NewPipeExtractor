//
//  ImageSuffix.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 18/11/2024.
//


import Foundation

/// Serializable class representing a suffix (which may include its format extension, such as `.jpg`) 
/// which needs to be added to get an image/thumbnail URL with its corresponding height, width, 
/// and estimated resolution level.
///
/// This class is used to construct `Image` instances from a single base URL/path, in order to get all 
/// or most image resolutions provided, depending on the service and the resolutions provided.
///
/// Note that this class is not intended to be used externally and so should only be used when 
/// interfacing with the extractor.
public final class ImageSuffix: CustomStringConvertible {
    public let suffix: String
    public let height: Int
    public let width: Int
    public let resolutionLevel: ResolutionLevel

    /// Create a new `ImageSuffix` instance.
    ///
    /// - Parameters:
    ///   - suffix: The suffix string.
    ///   - height: The height corresponding to the image suffix.
    ///   - width: The width corresponding to the image suffix.
    ///   - resolutionLevel: The `ResolutionLevel` of the image suffix.
    /// - Throws: A `fatalError` if `resolutionLevel` is `nil`.
    public init(suffix: String, height: Int, width: Int, resolutionLevel: ResolutionLevel) {
        self.suffix = suffix
        self.height = height
        self.width = width
        self.resolutionLevel = resolutionLevel
    }

    /// The suffix which needs to be appended to get the full image URL.
    public func getSuffix() -> String {
        return suffix
    }

    /// The height corresponding to the image suffix, which may be unknown.
    public func getHeight() -> Int {
        return height
    }

    /// The width corresponding to the image suffix, which may be unknown.
    public func getWidth() -> Int {
        return width
    }

    /// The estimated `ResolutionLevel` of the suffix, which is never `nil`.
    public func getResolutionLevel() -> ResolutionLevel {
        return resolutionLevel
    }

    /// Get a string representation of this `ImageSuffix` instance.
    ///
    /// The representation will be in the following format:
    /// `ImageSuffix {suffix=suffix, height=height, width=width, resolutionLevel=resolutionLevel}`
    public var description: String {
        return "ImageSuffix {suffix=\(suffix), height=\(height), width=\(width), resolutionLevel=\(resolutionLevel)}"
    }
}

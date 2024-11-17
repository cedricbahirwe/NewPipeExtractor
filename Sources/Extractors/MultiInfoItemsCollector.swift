//
//  MultiInfoItemsCollector.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 17/11/2024.
//

import Foundation

/// A collector that can handle multiple extractor types, to be used when a list contains items of different types (e.g., search).
///
/// This collector can handle the following extractor types:
/// - `StreamInfoItemExtractor`
/// - `ChannelInfoItemExtractor`
/// - `PlaylistInfoItemExtractor`
///
/// Calling `extract(_:)` or `commit(_:)` with any other extractor type will raise an exception.
public class MultiInfoItemsCollector<I: StreamInfoItem, E: InfoItemExtractor>: InfoItemsCollector<I, E> where E: StreamInfoItemExtractor {
//    <InfoItem, InfoItemExtractor>
    // MARK: - Properties
    
    private let streamCollector: StreamInfoItemsCollector<I, E>
//    private let userCollector: ChannelInfoItemsCollector
//    private let playlistCollector: PlaylistInfoItemsCollector
    
    // MARK: - Initializer
    
    /// Initializes a `MultiInfoItemsCollector` with the given service ID.
    ///
    /// - Parameter serviceId: The ID of the service associated with the collector.
    public override init(serviceId: Int) {
        self.streamCollector = StreamInfoItemsCollector(serviceId: serviceId)
//        self.userCollector = ChannelInfoItemsCollector(serviceId: serviceId)
//        self.playlistCollector = PlaylistInfoItemsCollector(serviceId: serviceId)
        super.init(serviceId: serviceId)
    }
    
    // MARK: - Methods
    
    /// Retrieves a combined list of errors from all collectors.
    ///
    /// - Returns: An array of errors encountered during collection.
    public override func getErrors() -> [Error] {
        var errors = super.getErrors()
        errors.append(contentsOf: streamCollector.getErrors())
//        errors.append(contentsOf: userCollector.getErrors())
//        errors.append(contentsOf: playlistCollector.getErrors())
        return errors
    }
    
    /// Resets all collectors, clearing their state.
    public override func reset() {
        super.reset()
        streamCollector.reset()
//        userCollector.reset()
//        playlistCollector.reset()
    }
    
    /// Extracts an `InfoItem` using the corresponding collector for the provided extractor type.
    ///
    /// - Parameter extractor: The `InfoItemExtractor` to process.
    /// - Throws: `ParsingException` if extraction fails or `IllegalArgumentException` for invalid extractor types.
    /// - Returns: The extracted `InfoItem`.
    public override func extract(extractor: E) throws -> I {
        switch extractor {
        case let streamExtractor as StreamInfoItemExtractor:
            return try streamCollector.extract(extractor: extractor) 
//        case let userExtractor as ChannelInfoItemExtractor:
//            return try userCollector.extract(userExtractor)
//        case let playlistExtractor as PlaylistInfoItemExtractor:
//            return try playlistCollector.extract(playlistExtractor)
        default:
            throw IllegalArgumentException("Invalid extractor type: \(extractor)")
        }
    }
}

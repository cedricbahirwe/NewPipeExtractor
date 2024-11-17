//
//  StreamInfoItemsCollector.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 17/11/2024.
//

import Foundation

/// Collector for `StreamInfoItem` objects, using `StreamInfoItemExtractor` for extraction.
public class StreamInfoItemsCollector<I: StreamInfoItem, E: StreamInfoItemExtractor>: InfoItemsCollector<I, E> {

//    <StreamInfoItem, StreamInfoItemExtractor>

    // MARK: - Initializers
    /// Initializes the collector with a service ID and a comparator.
    ///
    /// - Parameters:
    ///   - serviceId: The ID of the service associated with this collector.
    ///   - comparator: A comparator used to sort items.
//    public init(serviceId: Int, comparator: @escaping (StreamInfoItem, StreamInfoItem) -> Bool) {
//        super.init(serviceId: serviceId, comparator: comparator)
//    }
    
    // MARK: - Methods
    
    /// Extracts a `StreamInfoItem` using the provided extractor.
    ///
    /// - Parameter extractor: The extractor to process.
    /// - Throws: `ParsingException` if extraction fails or `FoundAdException` if an ad is detected.
    /// - Returns: The extracted `StreamInfoItem`.
    public override func extract(extractor: E) throws -> I {
        guard try !extractor.isAd() else {
            throw FoundAdException("Found ad")
        }
        
        let resultItem = I.init(
            serviceId: getServiceId(),
            url: try extractor.getUrl(),
            name: try extractor.getName(),
            streamType: try extractor.getStreamType()
        )
        
        // Optional information
        handleExtraction {
            resultItem.setDuration(try extractor.getDuration())
        }
        handleExtraction {
            resultItem.setUploaderName(try extractor.getUploaderName())
        }
        handleExtraction {
            resultItem.setTextualUploadDate(try extractor.getTextualUploadDate())
        }
        handleExtraction {
            resultItem.setUploadDate(try extractor.getUploadDate())
        }
        handleExtraction {
            resultItem.setViewCount(try extractor.getViewCount())
        }
        handleExtraction {
            resultItem.setThumbnails(try extractor.getThumbnails())
        }
        handleExtraction {
            resultItem.setUploaderUrl(try extractor.getUploaderUrl())
        }
        handleExtraction {
            resultItem.setUploaderAvatars(try extractor.getUploaderAvatars())
        }
        handleExtraction {
            resultItem.setUploaderVerified(try extractor.isUploaderVerified())
        }
        handleExtraction {
            resultItem.setShortDescription(try extractor.getShortDescription())
        }
        handleExtraction {
            resultItem.setShortFormContent(try extractor.isShortFormContent())
        }
        
        return resultItem
    }
    
    /// Commits a `StreamInfoItem` extracted from the provided extractor to the collector.
    ///
    /// - Parameter extractor: The extractor to process.
    public override func commit(extractor: E) {
        do {
            addItem(try extract(extractor: extractor))
        } catch is FoundAdException {
            // Ignore ads
        } catch {
            addError(error)
        }
    }
    
    // MARK: - Helpers
    
    /// Handles an optional extraction, adding any errors to the collector.
    ///
    /// - Parameter action: The closure containing the extraction logic.
    private func handleExtraction(_ action: () throws -> Void) {
        do {
            try action()
        } catch {
            addError(error)
        }
    }
}

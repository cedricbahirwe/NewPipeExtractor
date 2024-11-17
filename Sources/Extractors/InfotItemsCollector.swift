//
//  InfotItemsCollector.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 16/11/2024.
//

import Foundation

public class InfoItemsCollector<I: InfoItem, E: InfoItemExtractor>: Collector {
    public typealias I = I
       public typealias E = E
//    public typealias I = InfoItem
//    public typealias E = InfoItemExtractor

//    <I: InfoItem, E: InfoItemExtractor>
    private var itemList: [I] = []
    private var errors: [Error] = []
    private let serviceId: Int
    private let comparator: ((I, I) -> Bool)?

    /// Create a new collector with no comparator / sorting function
    public convenience init(serviceId: Int) {
        self.init(serviceId: serviceId, comparator: nil)
    }

    /// Create a new collector with a custom comparator
    public init(serviceId: Int, comparator: ((I, I) -> Bool)?) {
        self.serviceId = serviceId
        self.comparator = comparator
    }

    public func getItems() -> [I] {
        if let comparator = comparator {
            return itemList.sorted(by: comparator)
        }
        return itemList
    }

    public func getErrors() -> [Error] {
        return errors
    }

    public func reset() {
        itemList.removeAll()
        errors.removeAll()
    }

    /// Add an error
    internal func addError(_ error: Error) {
        errors.append(error)
    }

    /// Add an item
    internal func addItem(_ item: I) {
        itemList.append(item)
    }

    /// Get the service ID
    public func getServiceId() -> Int {
        return serviceId
    }

    public func commit(extractor: E) {
        do {
            let item = try extract(extractor: extractor)
            addItem(item)
        } catch is FoundAdException {
            // Found an ad. Debug logging can be added here if needed.
        } catch let parsingError as ParsingException {
            addError(parsingError)
        } catch {
            addError(error)
        }
    }
    
    /// Extract an item from the extractor (to be implemented in subclasses)
    public func extract(extractor: E) throws -> I {
        fatalError("This method must be overridden by subclasses")
    }
}

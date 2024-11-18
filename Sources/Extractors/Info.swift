//
//  Info.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 18/11/2024.
//


import Foundation


 /// Represents an information object with details like service ID, URL, name, and errors.
public class Info: Codable {
    public struct InfoError: Error, Codable { }
    
    // MARK: - Properties
    private let serviceId: Int
    private let id: String
    private let url: String
    private var originalUrl: String
    private let name: String
    private var errors: [InfoError] = []

    // MARK: - Initializers
    public init(serviceId: Int, id: String, url: String, originalUrl: String, name: String) {
        self.serviceId = serviceId
        self.id = id
        self.url = url
        self.originalUrl = originalUrl
        self.name = name
    }

    public init(serviceId: Int, linkHandler: LinkHandler, name: String) {
        self.serviceId = serviceId
        self.id = linkHandler.getId()
        self.url = linkHandler.getUrl()
        self.originalUrl = linkHandler.getOriginalUrl()
        self.name = name
    }

    // MARK: - Methods
    public func addError(_ error: Error) {
        if let error = error as? InfoError {
            errors.append(error)
        }
    }

    public func addAllErrors(_ errors: [Error]) {
        self.errors.append(contentsOf: errors.compactMap({ $0 as? InfoError }))
    }

    public func getServiceId() -> Int {
        return serviceId
    }

    public func getService() -> any StreamingService {
        do {
            return try NewPipe.getService(serviceId)
        } catch {
            fatalError("Info object has invalid service id: \(error)")
        }
    }

    public func getId() -> String {
        return id
    }

    public func getUrl() -> String {
        return url
    }

    public func getOriginalUrl() -> String {
        return originalUrl
    }

    public func setOriginalUrl(_ originalUrl: String) {
        self.originalUrl = originalUrl
    }

    public func getName() -> String {
        return name
    }

    public func getErrors() -> [InfoError] {
        return errors
    }

    // MARK: - Description
    public var toString: String {
        let ifDifferentString = url == originalUrl ? "" : " (originalUrl=\"\(originalUrl)\")"
        return "\(type(of: self))[url=\"\(url)\"\(ifDifferentString), name=\"\(name)\"]"
    }
}

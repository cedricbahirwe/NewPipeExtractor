//
//  JsonUtils.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 16/11/2024.
//

import Foundation

public typealias JsonDict = [String: Any]

public enum JsonUtils {
    public static func getString(json object: JsonObject, path: String) throws -> String {
        try getInstanceOf(object, path: path, type: String.self)
    }

    /// Retrieves an instance of the specified type from a JSON object at the given path.
    ///
    /// - Parameters:
    ///   - object: The `JsonObject` to search within.
    ///   - path: The key path to retrieve the value.
    ///   - type: The type to which the value should conform.
    /// - Throws: A `ParsingException` if the value does not exist or is of the wrong type.
    /// - Returns: The value cast to the specified type.
    private static func getInstanceOf<T>(_ object: JsonObject, path: String, type: T.Type) throws -> T {
        let value = try getValue(object, path: path)

        if let castValue = value as? T {
            return castValue
        } else {
            throw ParsingException("Wrong data type at path \(path)")
        }
    }

    public static func getValue(
        _ object: JsonObject,
        path: String
    ) throws -> Any {
        let keys = path.split(separator: ".").map { String($0) }
        guard !keys.isEmpty else {
            throw JsonUtilsError.invalidPath("The provided path is empty")
        }

        var currentObject: Any = object

        for (index, key) in keys.enumerated() {
            if let dict = currentObject as? [String: Any], let value = dict[key] {
                if index == keys.count - 1 {
                    return value
                } else {
                    currentObject = value
                }
            } else {
                throw JsonUtilsError.keyNotFound("Unable to get \(path)")
            }
        }

        throw JsonUtilsError.keyNotFound("Unable to get \(path)")
    }
}

public enum JsonUtilsError: Error, CustomStringConvertible {
    case keyNotFound(String)
    case invalidType(String, expected: Any.Type)
    case invalidPath(String)
    case invalidData(String)

    public var description: String {
        switch self {
        case .invalidData(let data):
            return "The provided data is invalid: \(data)"
        case .invalidPath(let path):
            return "The provided path is empty or invalid: \(path)"
        case .keyNotFound(let key):
            return "Key '\(key)' not found."
        case .invalidType(let key, let expected):
            return "Invalid type for key '\(key)'. Expected: \(expected)."
        }
    }
}

import Foundation

/// A JSON object wrapper that provides utility methods for accessing and manipulating JSON-like data.
public class JsonObject {
    private var data: [String: Any]

    // MARK: - Initializers

    public init() {
        self.data = [:]
    }

    public init(_ dictionary: [String: Any]) {
        self.data = dictionary
    }

    public init(capacity: Int) {
        self.data = [:]
        self.data.reserveCapacity(capacity)
    }

    // MARK: - Utility Methods

    /// Retrieves a `JsonArray` for the given key or returns a default value.
    public func getArray(_ key: String, defaultValue: JsonArray = JsonArray()) -> JsonArray {
        return data[key] as? JsonArray ?? defaultValue
    }

    /// Retrieves a `Bool` for the given key or returns a default value.
    public func getBoolean(_ key: String, defaultValue: Bool = false) -> Bool {
        return data[key] as? Bool ?? defaultValue
    }

    /// Retrieves a `Double` for the given key or returns a default value.
    public  func getDouble(_ key: String, defaultValue: Double = 0.0) -> Double {
        return (data[key] as? NSNumber)?.doubleValue ?? defaultValue
    }

    /// Retrieves a `Float` for the given key or returns a default value.
    public func getFloat(_ key: String, defaultValue: Float = 0.0) -> Float {
        return (data[key] as? NSNumber)?.floatValue ?? defaultValue
    }

    /// Retrieves an `Int` for the given key or returns a default value.
    public func getInt(_ key: String, defaultValue: Int = 0) -> Int {
        return (data[key] as? NSNumber)?.intValue ?? defaultValue
    }

    /// Retrieves a `Long` (Int64) for the given key or returns a default value.
    public func getLong(_ key: String, defaultValue: Int64 = 0) -> Int64 {
        return (data[key] as? NSNumber)?.int64Value ?? defaultValue
    }

    /// Retrieves a `Number` for the given key or returns a default value.
    public func getNumber(_ key: String, defaultValue: NSNumber? = nil) -> NSNumber? {
        return data[key] as? NSNumber ?? defaultValue
    }

    /// Retrieves a nested `JsonObject` for the given key or returns a default value.
    public func getObject(_ key: String, defaultValue: JsonObject = JsonObject()) -> JsonObject {
        return data[key] as? JsonObject ?? defaultValue
    }

    /// Retrieves a `String` for the given key or returns a default value.
    public func getString(_ key: String, defaultValue: String? = nil) -> String? {
        return data[key] as? String ?? defaultValue
    }

    /// Checks if the key exists in the object.
    public func has(_ key: String) -> Bool {
        return data.keys.contains(key)
    }

    /// Checks if the value for the key is a `Bool`.
    public func isBoolean(_ key: String) -> Bool {
        return data[key] is Bool
    }

    /// Checks if the value for the key is `nil`.
    public func isNull(_ key: String) -> Bool {
        return data.keys.contains(key) && data[key] == nil
    }

    /// Checks if the value for the key is a `Number`.
    public func isNumber(_ key: String) -> Bool {
        return data[key] is NSNumber
    }

    /// Checks if the value for the key is a `String`.
    public func isString(_ key: String) -> Bool {
        return data[key] is String
    }

    // MARK: - Subscript Access

    public subscript(key: String) -> Any? {
        get {
            return data[key]
        }
        set {
            data[key] = newValue
        }
    }

    // MARK: - Builder Pattern

    /// Provides a builder for creating a `JsonObject`.
    static func builder() -> JsonBuilder<JsonObject> {
        return JsonBuilder(JsonObject())
    }
}

/// A placeholder for a `JsonBuilder` class.
class JsonBuilder<T> {
    private var jsonObject: T

    init(_ jsonObject: T) {
        self.jsonObject = jsonObject
    }

    func build() -> T {
        return jsonObject
    }
}

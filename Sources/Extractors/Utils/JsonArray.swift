//
//  JsonArray.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 17/11/2024.
//


import Foundation

/// A JSON array wrapper that extends array functionality with helper methods
/// to determine the underlying JSON type of the array elements.
public class JsonArray {
    private var elements: [Any]

    // MARK: - Initializers

    /// Creates an empty `JsonArray`.
    public init() {
        self.elements = []
    }

    /// Creates an empty `JsonArray` with a given initial capacity (not applicable in Swift but maintained for consistency).
    public init(initialCapacity: Int) {
        self.elements = []
        self.elements.reserveCapacity(initialCapacity)
    }

    /// Creates a `JsonArray` from a collection of objects.
    public  init(_ collection: [Any]) {
        self.elements = collection
    }

    /// Creates a `JsonArray` from an array of contents.
    public static func from(_ contents: Any...) -> JsonArray {
        return JsonArray(contents)
    }

    // MARK: - Element Access

    /// Returns the underlying object at the given index, or `nil` if it does not exist.
    public func get(_ index: Int) -> Any? {
        return index >= 0 && index < elements.count ? elements[index] : nil
    }

    /// Returns the `JsonArray` at the given index, or an empty one if it does not exist or is the wrong type.
    public func getArray(_ index: Int, defaultValue: JsonArray = JsonArray()) -> JsonArray {
        return get(index) as? JsonArray ?? defaultValue
    }

    /// Returns the `Bool` at the given index, or `false` if it does not exist or is the wrong type.
    public func getBoolean(_ index: Int, defaultValue: Bool = false) -> Bool {
        return get(index) as? Bool ?? defaultValue
    }

    /// Returns the `Double` at the given index, or `0.0` if it does not exist or is the wrong type.
    public func getDouble(_ index: Int, defaultValue: Double = 0.0) -> Double {
        return (get(index) as? NSNumber)?.doubleValue ?? defaultValue
    }

    /// Returns the `Float` at the given index, or `0.0` if it does not exist or is the wrong type.
    public func getFloat(_ index: Int, defaultValue: Float = 0.0) -> Float {
        return (get(index) as? NSNumber)?.floatValue ?? defaultValue
    }

    /// Returns the `Int` at the given index, or `0` if it does not exist or is the wrong type.
    public func getInt(_ index: Int, defaultValue: Int = 0) -> Int {
        return (get(index) as? NSNumber)?.intValue ?? defaultValue
    }

    /// Returns the `Int64` at the given index, or `0` if it does not exist or is the wrong type.
    public func getLong(_ index: Int, defaultValue: Int64 = 0) -> Int64 {
        return (get(index) as? NSNumber)?.int64Value ?? defaultValue
    }

    /// Returns the `NSNumber` at the given index, or `nil` if it does not exist or is the wrong type.
    public func getNumber(_ index: Int, defaultValue: NSNumber? = nil) -> NSNumber? {
        return get(index) as? NSNumber ?? defaultValue
    }

    /// Returns the `JsonObject` at the given index, or an empty one if it does not exist or is the wrong type.
    public func getObject(_ index: Int, defaultValue: JsonObject = JsonObject()) -> JsonObject {
        return get(index) as? JsonObject ?? defaultValue
    }

    /// Returns the `String` at the given index, or `nil` if it does not exist or is the wrong type.
    public func getString(_ index: Int, defaultValue: String? = nil) -> String? {
        return get(index) as? String ?? defaultValue
    }

    // MARK: - Type Checks

    /// Returns `true` if the array has an element at that index (even if that element is `nil`).
    public func has(_ index: Int) -> Bool {
        return index >= 0 && index < elements.count
    }

    /// Returns `true` if the array has a `Bool` element at that index.
    public func isBoolean(_ index: Int) -> Bool {
        return get(index) is Bool
    }

    /// Returns `true` if the array has a `nil` element at that index.
    public func isNull(_ index: Int) -> Bool {
        return has(index) && get(index) == nil
    }

    /// Returns `true` if the array has a `Number` element at that index.
    public func isNumber(_ index: Int) -> Bool {
        return get(index) is NSNumber
    }

    /// Returns `true` if the array has a `String` element at that index.
    public func isString(_ index: Int) -> Bool {
        return get(index) is String
    }

    // MARK: - Array Operations

    /// Adds an element to the array.
    public func append(_ element: Any) {
        elements.append(element)
    }

    /// Removes an element at the specified index.
    public func remove(at index: Int) {
        if index >= 0 && index < elements.count {
            elements.remove(at: index)
        }
    }

    /// Returns the number of elements in the array.
    public var count: Int {
        return elements.count
    }

    /// Checks if the array is empty.
    public var isEmpty: Bool {
        return elements.isEmpty
    }

    /// Retrieves the underlying array.
    public func toArray() -> [Any] {
        return elements
    }

    // MARK: - Builder Pattern

    /// Creates a `JsonBuilder` for a `JsonArray`.
//    public static func builder() -> JsonBuilder<JsonArray> {
//        return JsonBuilder(JsonArray())
//    }
}

extension JsonArray: Collection {
    /// The position of the first element in the array.
    public var startIndex: Int {
        return elements.startIndex
    }

    /// The position one past the last element in the array.
    public var endIndex: Int {
        return elements.endIndex
    }

    /// Returns the position immediately after the given index.
    public func index(after i: Int) -> Int {
        return elements.index(after: i)
    }

    /// Accesses the element at the specified position.
    public subscript(position: Int) -> Any {
        return elements[position]
    }
}

//
//  RandomStringFromAlphabetGenerator.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 18/11/2024.
//


import Foundation

public enum RandomStringFromAlphabetGenerator {
    /**
     * Generate a random string from an alphabet.
     *
     * - Parameters:
     *   - alphabet: The characters' alphabet to use.
     *   - length: The length of the returned string (greater than 0).
     *   - random: A random generator used for generating the random string.
     * - Returns: A random string of the requested length made of only characters from the provided alphabet.
     */
    public static func generate(from alphabet: String, length: Int, using random: inout RandomNumberGenerator) -> String {
        precondition(length > 0, "Length must be greater than 0")
        let characters = Array(alphabet)
        return String((0..<length).map { _ in characters.randomElement(using: &random)! })
    }
}

extension Array {
    /**
     * Returns a random element from the array using the given random number generator.
     *
     * - Parameter generator: The random number generator to use.
     * - Returns: A random element from the array.
     */
    func randomElement<T: RandomNumberGenerator>(using generator: inout T) -> Element? {
        guard !isEmpty else { return nil }
        let randomIndex = Int.random(in: 0..<count, using: &generator)
        return self[randomIndex]
    }
}

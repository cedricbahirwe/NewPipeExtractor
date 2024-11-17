//
//  JsonParser.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 17/11/2024.
//

import Foundation

public final class JsonParser {

    static func parse(from responseBody: String) throws -> JsonObject {
        guard let jsonData = responseBody.data(using: .utf8) else {
            throw ParsingException("Invalid json body: \(responseBody)")
        }

        do {
            let jsonObjectResponse = try JSONSerialization.jsonObject(with: jsonData)
            if let jsonObject = jsonObjectResponse as? JsonObject {
                return jsonObject
            } else {
                throw JsonUtilsError.invalidPath(responseBody)
            }
        } catch {
            throw Exception("Unable to parse body: ", error)
        }
    }
}

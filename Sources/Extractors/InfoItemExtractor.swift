//
//  InfoItemExtractor.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 16/11/2024.
//

import Foundation

public protocol InfoItemExtractor {
    func getName() throws -> String
    func getUrl() throws -> String
    func getThumbnails() throws -> List<Image>
}

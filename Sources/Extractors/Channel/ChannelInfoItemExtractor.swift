//
//  ChannelInfoItemExtractor.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 18/11/2024.
//

import Foundation

public protocol ChannelInfoItemExtractor: InfoItemExtractor {
    func getDescription() throws -> String
    func getSubscriberCount() throws -> Int64
    func getStreamCount() throws -> Int64
    func isVerified() throws -> Bool
}

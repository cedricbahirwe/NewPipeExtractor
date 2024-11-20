//
//  UnsupportedTabException.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 20/11/2024.
//

import Foundation

public final class UnsupportedTabException: IllegalArgumentException, @unchecked Sendable {
    public init(unsupportedTab: String) {
        super.init("Unsupported tab \(unsupportedTab)")
    }
}

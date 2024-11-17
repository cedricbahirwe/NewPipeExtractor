//
//  ParsingException.swift
//  NewPipe
//
//  Created by Cédric Bahirwe on 15/11/2024.
//

/*
 * Created by Christian Schabesberger on 31.01.16.
 *
 * Copyright (C) 2016 Christian Schabesberger <chris.schabesberger@mailbox.org>
 * ParsingException.java is part of NewPipe Extractor.
 *
 * NewPipe Extractor is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * NewPipe Extractor is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with NewPipe Extractor.  If not, see <http://www.gnu.org/licenses/>.
 */


public class ParsingException: ExtractionException, @unchecked Sendable {
    public let cause: Error?

    public init(_ message: String, _ cause: Error? = nil) {
        self.cause = cause
        super.init(message)
    }
}

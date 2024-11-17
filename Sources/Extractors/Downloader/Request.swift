//
//  Request.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 16/11/2024.
//

import Foundation

/// An object that holds request information used when executing a request.
public struct Request: Equatable, Hashable {
    /// A HTTP method (e.g., "GET", "POST", "HEAD").
    private let httpMethod: String
    /// The URL pointing to the desired resource.
    private let url: String
    /// A list of headers to use in the request.
    ///
    /// Any default headers that the implementation may have should be overridden by these.
    private let headers: [String: [String]]
    /// An optional byte array to send with the request, commonly used in POST requests.
    ///
    /// Implementations should consider some recommended headers (e.g., "Content-Length" in a POST request).
    private let dataToSend: Data?
    /// A localization object to use when executing a request.
    ///
    /// The "Accept-Language" header is usually set to this value.
    private let localization: Localization?

    public init(httpMethod: String,
                url: String,
                headers: [String: [String]]? = nil,
                dataToSend: Data? = nil,
                localization: Localization? = nil,
                automaticLocalizationHeader: Bool) {
        self.httpMethod = httpMethod
        self.url = url
        self.dataToSend = dataToSend
        self.localization = localization

        var actualHeaders = headers ?? [:]
        if automaticLocalizationHeader, let localization = localization {
            actualHeaders.merge(Self.getHeadersFromLocalization(localization)) { current, _ in current }
        }
        self.headers = actualHeaders
    }

    private init(builder: Builder) {
        self.init(
            httpMethod: builder.httpMethod ?? "",
            url: builder.url ?? "",
            headers: builder.headers,
            dataToSend: builder.dataToSend,
            localization: builder.localization,
            automaticLocalizationHeader: builder.automaticLocalizationHeader
        )
    }

    public static func newBuilder() -> Builder {
        return Builder()
    }

    public static func getHeadersFromLocalization(_ localization: Localization?) -> [String: [String]] {
        guard let localization = localization else { return [:] }
        let languageCode = localization.getLanguageCode()
        let value = localization.getCountryCode().isEmpty
            ? languageCode
            : "\(localization.getLocalizationCode()), \(languageCode);q=0.9"
        return ["Accept-Language": [value]]
    }

    public static func ==(lhs: Request, rhs: Request) -> Bool {
        return lhs.httpMethod == rhs.httpMethod &&
            lhs.url == rhs.url &&
            lhs.headers == rhs.headers &&
            lhs.dataToSend == rhs.dataToSend &&
            lhs.localization == rhs.localization
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(httpMethod)
        hasher.combine(url)
        hasher.combine(headers)
        hasher.combine(dataToSend)
        hasher.combine(localization)
    }

    public final class Builder {
        var httpMethod: String?
        var url: String?
        var headers: [String: [String]] = [:]
        var dataToSend: Data?
        var localization: Localization?
        var automaticLocalizationHeader = true

        public init() {}

        /// A HTTP method (e.g., "GET", "POST", "HEAD").
        public func httpMethod(_ httpMethodToSet: String) -> Builder {
            self.httpMethod = httpMethodToSet
            return self
        }

        /// The URL pointing to the desired resource.
        public func url(_ urlToSet: String) -> Builder {
            self.url = urlToSet
            return self
        }

        /// A list of headers to use in the request.
        ///
        /// Any default headers that the implementation may have should be overridden by these.
        public func headers(_ headersToSet: [String: [String]]?) -> Builder {
            self.headers = headersToSet ?? [:]
            return self
        }

        /// An optional byte array to send with the request, commonly used in POST requests.
        ///
        /// Implementations should consider some recommended headers (e.g., "Content-Length" in a POST request).
        public func dataToSend(_ dataToSendToSet: Data?) -> Builder {
            self.dataToSend = dataToSendToSet
            return self
        }

        /// A localization object to use when executing a request.
        ///
        /// The "Accept-Language" header is usually set to this value.
        public func localization(_ localizationToSet: Localization?) -> Builder {
            self.localization = localizationToSet
            return self
        }

        /// If localization headers should automatically be included in the request.
        public func automaticLocalizationHeader(_ automaticLocalizationHeaderToSet: Bool) -> Builder {
            self.automaticLocalizationHeader = automaticLocalizationHeaderToSet
            return self
        }

        public func build() -> Request {
            return Request(builder: self)
        }

        // MARK: - HTTP Methods Utils

        public func get(_ urlToSet: String) -> Builder {
            self.httpMethod = "GET"
            self.url = urlToSet
            return self
        }

        public func head(_ urlToSet: String) -> Builder {
            self.httpMethod = "HEAD"
            self.url = urlToSet
            return self
        }

        public func post(_ urlToSet: String, dataToSendToSet: Data?) -> Builder {
            self.httpMethod = "POST"
            self.url = urlToSet
            self.dataToSend = dataToSendToSet
            return self
        }

        // MARK: - Additional Headers Utils

        public func setHeaders(_ headerName: String, _ headerValueList: [String]) -> Builder {
            self.headers[headerName] = headerValueList
            return self
        }

        public func addHeaders(_ headerName: String, _ headerValueList: [String]) -> Builder {
            var currentHeaders = self.headers[headerName] ?? []
            currentHeaders.append(contentsOf: headerValueList)
            self.headers[headerName] = currentHeaders
            return self
        }

        public func setHeader(_ headerName: String, _ headerValue: String) -> Builder {
            return setHeaders(headerName, [headerValue])
        }

        public func addHeader(_ headerName: String, _ headerValue: String) -> Builder {
            return addHeaders(headerName, [headerValue])
        }
    }
}

//
//  StreaminService+Extensions.swift
//  NewPipe
//
//  Created by Cédric Bahirwe on 15/11/2024.
//

import Foundation

public typealias StreamingServiceInfo = StreamingServiceTypes.ServiceInfo
public enum StreamingServiceTypes {
    /**
     * This class holds meta information about the service implementation.
     */
    public class ServiceInfo {
        private final let name: String

        private final let mediaCapabilities: List<MediaCapability>

        /**
         * Creates a new instance of a ServiceInfo
         * @param name the name of the service
         * @param mediaCapabilities the type of media this service can handle
         */
        public init(_ name: String, _ mediaCapabilities: List<MediaCapability>) {
            self.name = name;
            self.mediaCapabilities = mediaCapabilities
        }

        public func getName() -> String {
            return name
        }

        public func getMediaCapabilities() -> List<MediaCapability> {
            return mediaCapabilities
        }

        public enum MediaCapability {
            case AUDIO, VIDEO, LIVE, COMMENTS
        }
    }

    /**
     * LinkType will be used to determine which type of URL you are handling, and therefore which
     * part of NewPipe should handle a certain URL.
     */
    public enum LinkType {
        case none,
        stream,
        channel,
        playlist
    }
}

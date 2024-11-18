//
//  MediaFormat.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 18/11/2024.
//


/**
 * Static data about various media formats supported by NewPipe, e.g., MIME type, extension.
 */
public enum MediaFormat: Int, Codable {
    // MARK: - Video and Audio Combined Formats
    case mpeg4
    case v3gpp
    case webm

    // MARK: - Audio Formats
    case m4a
    case webma
    case mp3
    case mp2
    case opus
    case ogg
    case webmaOpus
    case aiff
    case aif
    case wav
    case flac
    case alac

    // MARK: - Subtitle Formats
    case vtt
    case ttml
    case transcript1
    case transcript2
    case transcript3
    case srt

    // MARK: - Properties
    public var id: Int {
        switch self {
        case .mpeg4: return 0x0
        case .v3gpp: return 0x10
        case .webm: return 0x20
        case .m4a: return 0x100
        case .webma: return 0x200
        case .mp3: return 0x300
        case .mp2: return 0x310
        case .opus: return 0x400
        case .ogg: return 0x500
        case .webmaOpus: return 0x200
        case .aiff: return 0x600
        case .aif: return 0x600
        case .wav: return 0x700
        case .flac: return 0x800
        case .alac: return 0x900
        case .vtt: return 0x1000
        case .ttml: return 0x2000
        case .transcript1: return 0x3000
        case .transcript2: return 0x4000
        case .transcript3: return 0x5000
        case .srt: return 0x6000
        }
    }
    public var name: String {
        switch self {
        case .mpeg4: return "MPEG-4"
        case .v3gpp: return "3GPP"
        case .webm: return "WebM"
        case .m4a: return "m4a"
        case .webma: return "WebM"
        case .mp3: return "MP3"
        case .mp2: return "MP2"
        case .opus: return "opus"
        case .ogg: return "ogg"
        case .webmaOpus: return "WebM Opus"
        case .aiff, .aif: return "AIFF"
        case .wav: return "WAV"
        case .flac: return "FLAC"
        case .alac: return "ALAC"
        case .vtt: return "WebVTT"
        case .ttml: return "Timed Text Markup Language"
        case .transcript1: return "TranScript v1"
        case .transcript2: return "TranScript v2"
        case .transcript3: return "TranScript v3"
        case .srt: return "SubRip file format"
        }
    }

    public var suffix: String {
        switch self {
        case .mpeg4: return "mp4"
        case .v3gpp: return "3gp"
        case .webm, .webma, .webmaOpus: return "webm"
        case .m4a: return "m4a"
        case .mp3: return "mp3"
        case .mp2: return "mp2"
        case .opus: return "opus"
        case .ogg: return "ogg"
        case .aiff: return "aiff"
        case .aif: return "aif"
        case .wav: return "wav"
        case .flac: return "flac"
        case .alac: return "alac"
        case .vtt: return "vtt"
        case .ttml: return "ttml"
        case .transcript1: return "srv1"
        case .transcript2: return "srv2"
        case .transcript3: return "srv3"
        case .srt: return "srt"
        }
    }

    public var mimeType: String {
        switch self {
        case .mpeg4: return "video/mp4"
        case .v3gpp: return "video/3gpp"
        case .webm: return "video/webm"
        case .m4a: return "audio/mp4"
        case .webma: return "audio/webm"
        case .mp3: return "audio/mpeg"
        case .mp2: return "audio/mpeg"
        case .opus: return "audio/opus"
        case .ogg: return "audio/ogg"
        case .webmaOpus: return "audio/webm"
        case .aiff, .aif: return "audio/aiff"
        case .wav: return "audio/wav"
        case .flac: return "audio/flac"
        case .alac: return "audio/alac"
        case .vtt: return "text/vtt"
        case .ttml: return "application/ttml+xml"
        case .transcript1, .transcript2, .transcript3: return "text/xml"
        case .srt: return "text/srt"
        }
    }

    // MARK: - Static Methods
    public static func getNameById(_ id: Int) -> String {
        return MediaFormat(rawValue: id)?.name ?? ""
    }

    public static func getSuffixById(_ id: Int) -> String {
        return MediaFormat(rawValue: id)?.suffix ?? ""
    }

    public static func getMimeById(_ id: Int) -> String? {
        return MediaFormat(rawValue: id)?.mimeType
    }

    public static func getFromMimeType(_ mimeType: String) -> MediaFormat? {
        return MediaFormat.allCases.first { $0.mimeType == mimeType }
    }

    public static func getAllFromMimeType(_ mimeType: String) -> [MediaFormat] {
        return MediaFormat.allCases.filter { $0.mimeType == mimeType }
    }

    public static func getFormatById(_ id: Int) -> MediaFormat? {
        return MediaFormat(rawValue: id)
    }

    public static func getFromSuffix(_ suffix: String) -> MediaFormat? {
        return MediaFormat.allCases.first { $0.suffix == suffix }
    }
}

extension MediaFormat: CaseIterable {}

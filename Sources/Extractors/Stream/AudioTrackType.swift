//
//  AudioTrackType.swift
//  NewPipeExtractor
//
//  Created by Cédric Bahirwe on 18/11/2024.
//


/// An enum representing the track type of `AudioStream`s extracted by a `StreamExtractor`.
public enum AudioTrackType {
    
    /// An original audio track of a video.
    case original
    
    /// An audio track with the original voices replaced, typically in a different language.
    ///
    /// See: [Dubbing](https://en.wikipedia.org/wiki/Dubbing)
    case dubbed
    
    /// A descriptive audio track.
    ///
    /// A descriptive audio track is an audio track in which descriptions of visual elements of
    /// a video are added to the original audio, with the goal to make a video more accessible to
    /// blind and visually impaired people.
    ///
    /// See: [Audio description](https://en.wikipedia.org/wiki/Audio_description)
    case descriptive
    
    /// A secondary audio track.
    ///
    /// A secondary audio track can be an alternate audio track from the original language of a
    /// video or an alternate language.
    case secondary
}

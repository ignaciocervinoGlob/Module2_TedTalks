//
//  Chat.swift
//  ConstraintsInIB
//
//  Created by Ignacio Cervino on 12/11/2021.
//

import Foundation

struct TedTalk: Decodable {
    var comments: Int
    var description: String
    var duration: Double
    var event: String
    var filmDate: Double
    var languages: Int
    var mainSpeaker: String
    var name: String
    var numSpeaker: Int
    var publishedDate: Double
    var speakerOccupation: String
    var tags: [String]
    var title: String
    var url: String
    var views: Int
    
    enum CodingKeys: String, CodingKey {
        case comments, description, duration, event, languages, name, tags, title, url, views
        case filmDate = "film_date"
        case mainSpeaker = "main_speaker"
        case numSpeaker = "num_speaker"
        case publishedDate = "published_date"
        case speakerOccupation = "speaker_occupation"
    }
}

//
//  MusicModel.swift
//  MusicPlayer
//
//  Created by Sanjeeb Samanta on 25/11/23.
//

import Foundation

// MARK: - Welcome
struct MusicList : Codable{
    let data: [Musics]
}

// MARK: - Datum
struct Musics : Codable {
    let id: Int
    let status: Status
    let userCreated, dateCreated, userUpdated, dateUpdated: String
    let name, artist, accent, cover: String
    let topTrack: Bool
    let url: String

    enum CodingKeys: String, CodingKey {
        case id, status
        case userCreated = "user_created"
        case dateCreated = "date_created"
        case userUpdated = "user_updated"
        case dateUpdated = "date_updated"
        case name, artist, accent, cover
        case topTrack = "top_track"
        case url
    }
    
    init() {
        id = Int()
        status = Status.published
        userCreated = ""
        dateCreated = ""
        userUpdated = ""
        dateUpdated = ""
        name = ""
        artist = ""
        cover = ""
        accent = ""
        topTrack = false
        url = ""
    }
}

enum Status: String, Codable {
    case published = "published"
}

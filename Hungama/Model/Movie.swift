//
//  Movie.swift
//  Hungama
//
//  Created by admin_vserv on 19/12/20.
//

import Foundation


struct RootMovie: Codable {
    var page = 0
    var results: [Movie]?
}

struct Movie: Codable {
    var adult = false
    var backdrop_path: String?
    var id = 0
    var original_title: String?
    var original_language: String
    var overview: String?
    var poster_path: String?
    var release_date: String?
    var title: String?
    var vote_average: Double?
    var vote_count = 0
    var video = false
}

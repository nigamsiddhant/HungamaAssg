//
//  MovieDetail.swift
//  Hungama
//
//  Created by admin_vserv on 20/12/20.
//

import Foundation

struct MovieDetail: Codable {
    var genres: [Genres]?
    var title: String?
    var release_date: String?
    var overview: String?
    var production_countries: [Production_countries]?
}


struct Genres: Codable {
    var id = 0
    var name: String?
}

struct Production_countries: Codable {
    var name: String
}

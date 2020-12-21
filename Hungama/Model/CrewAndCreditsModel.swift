//
//  CrewAndCreditsModel.swift
//  Hungama
//
//  Created by admin_vserv on 20/12/20.
//

import Foundation

struct CrewAndCast: Codable {
    var cast: [CrewAndCastDetais]?
    var crew: [CrewAndCastDetais]?
}

struct CrewAndCastDetais: Codable {
    var name: String?
    var profile_path: String?
}


//
//  SimilarMovie.swift
//  Hungama
//
//  Created by admin_vserv on 20/12/20.
//

import Foundation


struct SimilarMovie: Codable {
    var results: [SimilarMovieResult]?
}


struct SimilarMovieResult: Codable {
    var title: String?
    var poster_path: String?
}

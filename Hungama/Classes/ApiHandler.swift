//
//  ApiHandler.swift
//  Hungama
//
//  Created by admin_vserv on 19/12/20.
//

import Foundation
//Api handler to do the api calls
struct ApiHandler {
    
    static let shared = ApiHandler()
    static let popular = "popular"
    static let api_key = "65d7e027240036eece4a5626b3a76a80"
    static let language = "en-US"
    static let credits = "credits"
    static let similar = "similar"
    let imageBaseUrl = "https://image.tmdb.org/t/p/w300/"
    let baseUrl = "https://api.themoviedb.org/3/movie/"

    //getApiCall to call all the get api.
    func getApiCall<T: Decodable>(urlString: String,queryParams: [URLQueryItem], completion: @escaping (T) -> ()) {
        
        var urlComps = URLComponents(string: ApiHandler.shared.baseUrl + urlString)
        
        urlComps?.queryItems = queryParams
        let finalUrl = urlComps?.url
        
        guard let url = finalUrl else {
            print("invalid url")
            return
        }
        print(url)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Api error occured")
                return
            }
            guard let data = data else {
                print("Api error occured")
                return
            }
            do {
                let jsonObj = try JSONDecoder().decode(T.self, from: data)
                completion(jsonObj)
            }
            catch{
                print("Api in catch block")
                print(error)
            }
        }.resume()
    }
    
}

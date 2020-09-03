//
//  MovieGenreApi.swift
//  MovieDB
//
//  Created by destanti on 03/09/20.
//  Copyright © 2020 destanti. All rights reserved.
//

import Foundation

protocol MovieGenreService {
    func getGenreList(completion: @escaping (Result<GenreResult, Error>) -> Void)
}


final class MovieGenreApi: NetworkingApi, MovieGenreService {
    func getGenreList(completion: @escaping (Result<GenreResult, Error>) -> Void) {
        var parameter = [String: String]()
        
        parameter["api_key"] = AppContants.apiKey
        let url = "\(AppContants.basePath)\(AppContants.genreListPath)"
        
        self.callAPI(url: url, parameter:  parameter, result: completion)
    }

}

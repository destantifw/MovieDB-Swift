//
//  MovieDetailApi.swift
//  MovieDB
//
//  Created by destanti on 02/09/20.
//  Copyright © 2020 destanti. All rights reserved.
//

import Foundation


protocol MovieDetailService {
    func getMovieDetail(withMovie movieId: Int, completion: @escaping (Result<MovieDetailModel, Error>) -> Void)
    
    func getVideos(withMovie movieId: Int, completion: @escaping (Result<MovieVideosModel, Error>) -> Void)
    
    func getReviews(withMovie movieId: Int, completion: @escaping (Result<ReviewModel, Error>) -> Void)
}


final class MovieDetailApi: NetworkingApi, MovieDetailService {
    func getVideos(withMovie movieId: Int, completion: @escaping (Result<MovieVideosModel, Error>) -> Void) {
        
        var parameter = [String: String]()
        parameter["api_key"] = AppContants.apiKey
        
        let url = "\(AppContants.basePath)\(AppContants.movieDetailPath)\(movieId)\(AppContants.videoDetailPath)"
        
        self.callAPI(url: url, parameter:  parameter, result: completion)
    }
    
    func getReviews(withMovie movieId: Int, completion: @escaping (Result<ReviewModel, Error>) -> Void) {
        
        var parameter = [String: String]()
        parameter["api_key"] = AppContants.apiKey
        
        let url = "\(AppContants.basePath)\(AppContants.movieDetailPath)\(movieId)\(AppContants.reviewDetailPath)"
        
        self.callAPI(url: url, parameter:  parameter, result: completion)
    }
    
    
    func getMovieDetail(withMovie movieId: Int, completion: @escaping (Result<MovieDetailModel, Error>) -> Void) {
        
        var parameter = [String: String]()
        parameter["api_key"] = AppContants.apiKey
        
        let url = "\(AppContants.basePath)\(AppContants.movieDetailPath)\(movieId)"
        
        self.callAPI(url: url, parameter:  parameter, result: completion)
        
    }
    
    
}

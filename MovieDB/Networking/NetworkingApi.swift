//
//  NetworkingApi.swift
//  MovieDB
//
//  Created by destanti on 02/09/20.
//  Copyright © 2020 destanti. All rights reserved.
//

import Foundation


protocol NetworkingService {
    func getMovieByGenre(withGenre genreId: Int, withPage page: Int, completion: @escaping (Result<MoviePage, Error>) -> Void)
}

class NetworkingApi: NetworkingService {
    
    private let session = URLSession.shared
    
    func getMovieByGenre(withGenre genreId: Int, withPage page: Int, completion: @escaping (Result<MoviePage, Error>) -> Void) {
        
        var parameter = [String: String]()
        parameter["with_genres"] = "\(genreId)"
        parameter["api_key"] = AppContants.apiKey
        parameter["page"] = "\(page)"
        
        
        let fullUrl = "\(AppContants.basePath)\(AppContants.movieListByGenrePath)"
        
        self.callAPI(url: fullUrl, parameter: parameter, result: completion)

    }
    
    func callAPI<D: Codable>(url: String, method: HTTPMethod? = .GET, headers: [String: String]? = nil, parameter: [String: String]? = nil, result: @escaping (Swift.Result<D, Swift.Error>) -> Void) {
        
        guard let request = self.makeRequest(from: url, method: method ?? .GET, headers: headers, parameter: parameter) else {
            return
        }
        
        let urlSession = URLSession.shared
        
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else {
                
                if let error = error {
                    result(.failure(error))
                }
                
                return
            }
            
//            let dataString = String(bytes: data, encoding: String.Encoding.utf8)
//            print("url \(url)", dataString)
            
            let decoder = JSONDecoder()

            do {
                
                let api = try decoder.decode(D.self, from: data)
                
                result(.success(api))
                
            } catch let error {
                
                result(.failure(error))
                
            }
        }
        
        task.resume()
        
    }
    
    private func makeRequest(from url: String, method: HTTPMethod, headers: [String: String]?, parameter: [String: String]?) -> URLRequest? {
        
        guard var urlComp = URLComponents(string: url) else {
            return nil
        }
        
        urlComp.queryItems = parameter?.map({ (key, value) -> URLQueryItem in
            return URLQueryItem(name: key, value: value)
        })
        
        guard let urlRequest = urlComp.url else {
            return nil
        }
        
        var request: URLRequest = URLRequest(url: urlRequest)
        request.httpMethod = method.value
        
        return request
    }
    
    
    
    
}

import Foundation

enum HTTPMethod: String, CaseIterable {
    
    var value: String {
        return self.rawValue
    }
    
    case GET = "GET"
    case POST = "POST"
}

//
//  MovieCategoryGenreViewModel.swift
//  MovieDB
//
//  Created by destanti on 03/09/20.
//  Copyright © 2020 destanti. All rights reserved.
//

import Foundation

final class MovieCategoryGenreViewModel {
    
    var isRefreshing: ((Bool) -> Void)?
    var didUpdateGenre: (([MovieCategoryCellViewModel]) -> Void)?
    var didSelecteGenre: ((Genre) -> Void)?
    
    
    var error: NSError?
    
    private(set) var genre: GenreResult?{
        didSet {
            guard let genre = genre else { return }
            didUpdateGenre?(genre.genres.map { MovieCategoryCellViewModel.init(genre: $0) })
        }
    }
    
    private var pages: [MoviePage] = []
    private var currentPage = 1
    private var totalPages = 0
    
    // Dependencies
    private let networkingService: MovieGenreService
    
    init(networkingService: MovieGenreService) {
        self.networkingService = networkingService
    }
    
    // Inputs
    func ready() {
        isRefreshing?(true)
        
        startSearchByGenre()
    }
    
    
    // Private
    private func startSearchByGenre() {
       
        isRefreshing?(true)
        networkingService.getGenreList() { (result) in
            switch result {
            case .success(let genre):
                self.finishGenres(with: genre)
            case .failure(let error):
                self.error = error as NSError
                print(error.localizedDescription)
            }
        }
    }

    private func finishGenres(with genres: GenreResult) {
        self.genre = genres
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        guard let data = genre else { return }
        didSelecteGenre?(data.genres[indexPath.row])
    }
    
}

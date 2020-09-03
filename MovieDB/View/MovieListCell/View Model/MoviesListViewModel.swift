//
//  MovieListViewModel.swift
//  MovieDB
//
//  Created by destanti on 02/09/20.
//  Copyright © 2020 destanti. All rights reserved.
//


import Foundation

final class MovieListViewModel {
    // Outputs
    var isRefreshing: ((Bool) -> Void)?
    var didUpdateRepos: (([MoviesListItemViewModel]) -> Void)?
    var didSelecteRepo: ((Int) -> Void)?
    
    var error: NSError?
    
    private(set) var movies: [MovieResult] = [MovieResult](){
        didSet {
            didUpdateRepos?(movies.map { MoviesListItemViewModel(movie: $0) })
        }
    }
    
    private var pages: [MoviePage] = []
    private var currentPage = 1
    private var totalPages = 0
    
    // Dependencies
    private let networkingService: NetworkingService
    
    init(networkingService: NetworkingService) {
        self.networkingService = networkingService
    }
    
    // Inputs
    func ready() {
        isRefreshing?(true)
        
        startSearchWithGenre("28", withPage: currentPage)
    }
    
    func didChangePage() {
        let page = currentPage + 1
        guard currentPage <= totalPages else {return}
        
        startSearchWithGenre("28", withPage: page)
    }
    
    private func appendPage(_ moviesPage: MoviePage) {
        currentPage = moviesPage.page
        totalPages = moviesPage.totalPages

        pages = pages
            .filter { $0.page != moviesPage.page }
            + [moviesPage]

        movies = pages.movies
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        if movies.isEmpty { return }
        didSelecteRepo?(movies[indexPath.item].id)
    }
    
    // Private
    private func startSearchWithGenre(_ genreId: String, withPage: Int) {
       
        isRefreshing?(true)
        networkingService.getMovieByGenre(withGenre: genreId, withPage: withPage) { (result) in

            switch result {
            case .success(let moviePage):
                self.currentPage = withPage
                self.appendPage(moviePage)
            case .failure(let error):
                self.error = error as NSError
                print(error.localizedDescription)
            }
            
        }
    }
}


private extension Array where Element == MoviePage {
    var movies: [MovieResult] { flatMap { $0.results } }
}


//
//  MovieDetailViewModel.swift
//  MovieDB
//
//  Created by destanti on 02/09/20.
//  Copyright © 2020 destanti. All rights reserved.
//

import Foundation

final class MovieDetailViewModel {
    // Outputs
    var isRefreshing: ((Bool) -> Void)?
    var didUpdateMovie: ((DetailedMovieViewModel) -> Void)?
    var didUpdateVideo: ((TrailerViewModel) -> Void)?
    var didUpdateReview: (([MovieReviewCellViewModel]) -> Void)?
    var didSelecteRepo: ((Int) -> Void)?
    
    var movieId : Int
    
    private var movie: MovieDetailModel?{
        didSet {
            guard let movie = movie else { return }
            didUpdateMovie?(DetailedMovieViewModel.init(movie: movie))
        }
    }
    
    private var video: MovieVideosModel?{
        didSet {
            guard let video = video?.results.first else { return }
            didUpdateVideo?(TrailerViewModel.init(video: video))
        }
    }
    
    private var reviews: [ReviewModelResult]?{
        didSet {
            guard let reviews = reviews else { return }
            didUpdateReview?(reviews.map { MovieReviewCellViewModel(review: $0) })
        }
    }
    
    var error: NSError?
    
    //    private(set) var movies: [MovieResult] = [MovieResult](){
    //        didSet {
    //            didUpdateMovie?(movies.map { MoviesListItemViewModel(movie: $0) })
    //        }
    //    }
    
    
    private var currentSearchNetworkTask: URLSessionDataTask?
    private var currentPage = 1
    
    // Dependencies
    private let service: MovieDetailService
    
    init(networkingService: MovieDetailService, movieId: Int) {
        self.service = networkingService
        self.movieId = movieId
        self.movie = nil
    }
    
    // Inputs
    func ready() {
        isRefreshing?(true)
        
        startGetMovieDetail()
        startGetListVideo()
        startGetListReview()
    }
    
    private func appendPage(_ moviesPage: MoviePage) {
        currentPage = moviesPage.page
        
        //        movies = pages.movies
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        //        if movies.isEmpty { return }
        //        didSelecteRepo?(movies[indexPath.item].id)
    }
    
    // Private
    private func startGetMovieDetail() {
        
        isRefreshing?(true)
        
        service.getMovieDetail(withMovie: movieId){ (result) in
            
            switch result {
            case .success(let movie):
                self.finishSearching(with: movie)
            case .failure(let error):
                self.finishWithError(error: error as NSError)
            }
            
        }
        
    }
    
    private func startGetListVideo() {
        
        service.getVideos(withMovie: movieId){ (result) in
            
            switch result {
            case .success(let video):
                self.finishVideos(with: video)
            case .failure(let error):
                self.finishWithError(error: error as NSError)
            }
            
        }
        
    }
    
    private func startGetListReview() {
        
        isRefreshing?(true)
        
        service.getReviews(withMovie: movieId){ (result) in
            
            switch result {
            case .success(let review):
                self.finishReview(with: review)
            case .failure(let error):
                self.finishWithError(error: error as NSError)
            }
            
        }
        
    }
    
    private func finishSearching(with movie: MovieDetailModel) {
        isRefreshing?(false)
        self.movie = movie
    }
    
    private func finishVideos(with video: MovieVideosModel) {
        self.video = video
    }
    
    private func finishWithError(error: NSError){
        self.error = error
        isRefreshing?(false)
    }
    
    private func finishReview(with review: ReviewModel) {
        isRefreshing?(false)
        self.reviews = review.results
    }
}

struct DetailedMovieViewModel {
    
    let genres: [MovieDetailGenreViewModel]?
    let id: Int
    let originalTitle, overview: String?
    let posterPath: String?
    var productionCompanies, productionCountries: NSMutableAttributedString?
    let releaseDate: String?
    let spokenLanguages: NSMutableAttributedString?
    let title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: String?
    
    init(movie: MovieDetailModel) {
        self.genres = movie.genres.map { MovieDetailGenreViewModel(genre: $0) }
        self.id = movie.id
        self.originalTitle = movie.originalTitle
        self.overview = movie.overview
        self.posterPath = movie.posterPath
        
        
        if let countries = movie.productionCountries{
            let productionString = countries.map({$0.name}).joined(separator: ", ")
            let productionText: NSMutableAttributedString = NSMutableAttributedString(string: "Production: \(productionString)")
            productionText.setBold(substring: "Production:")
            productionText.setNormal(substring: productionString)
            self.productionCountries = productionText
        } else {
            self.productionCompanies = NSMutableAttributedString(string: "Country:")
        }
        
        if let companies = movie.productionCompanies{
            let companiesString = companies.map({$0.name}).joined(separator: ", ")
            let companiesText: NSMutableAttributedString = NSMutableAttributedString(string: "Company: \(companiesString)")
            companiesText.setBold(substring: "Company:")
            companiesText.setNormal(substring: companiesString)
            self.productionCompanies = companiesText
        } else {
            self.productionCountries = NSMutableAttributedString(string: "")
        }
        
        self.releaseDate = movie.releaseDate
        
        if let languages = movie.spokenLanguages{
            let languagesString = languages.map({$0.name}).joined(separator: ", ")
            let languagesText: NSMutableAttributedString = NSMutableAttributedString(string: "Language: \(languagesString)")
            languagesText.setBold(substring: "Language:")
            languagesText.setNormal(substring: languagesString)
            self.spokenLanguages = languagesText
        } else {
            self.spokenLanguages = NSMutableAttributedString(string: "")
        }
        
        self.title = movie.title
        self.video = movie.video
        self.voteAverage = movie.voteAverage
        self.voteCount = "(\(movie.voteCount))"
        
    }
}


struct TrailerViewModel {
    let url: String
    
    init(video: MovieVideosListModel) {
        self.url = "https://www.youtube.com/watch?v=\(video.key)"
    }
}

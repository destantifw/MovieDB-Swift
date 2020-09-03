//
//  MovieListCellViewModel.swift
//  MovieDB
//
//  Created by destanti on 02/09/20.
//  Copyright © 2020 destanti. All rights reserved.
//

import Foundation

struct MoviesListItemViewModel: Equatable {
    let title: String
    let posterImagePath: String?
}

extension MoviesListItemViewModel {

    init(movie: MovieResult) {
        self.title = movie.title 
        self.posterImagePath = movie.posterPath
    }
}

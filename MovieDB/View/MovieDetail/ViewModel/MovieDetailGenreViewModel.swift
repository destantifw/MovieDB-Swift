//
//  MovieDetailGenreViewModel.swift
//  MovieDB
//
//  Created by destanti on 03/09/20.
//  Copyright © 2020 destanti. All rights reserved.
//


import Foundation

struct MovieDetailGenreViewModel: Equatable {
    let title: String
}

extension MovieDetailGenreViewModel {

    init(genre: Genre) {
        self.title = genre.name
    }
}

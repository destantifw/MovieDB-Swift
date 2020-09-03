//
//  MoviecellViewModel.swift
//  MovieDB
//
//  Created by destanti on 03/09/20.
//  Copyright © 2020 destanti. All rights reserved.
//
import Foundation

struct MovieCategoryCellViewModel: Equatable {
    let id: Int
    let name: String
}

extension MovieCategoryCellViewModel {

    init(genre: Genre) {
        self.id = genre.id
        self.name = genre.name
    }
}

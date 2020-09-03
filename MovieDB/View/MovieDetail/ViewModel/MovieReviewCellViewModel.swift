//
//  MovieReviewCellViewModel.swift
//  MovieDB
//
//  Created by destanti on 03/09/20.
//  Copyright © 2020 destanti. All rights reserved.
//

import Foundation

struct MovieReviewCellViewModel: Equatable {
    let author: String
    let content: String
}

extension MovieReviewCellViewModel {

    init(review: ReviewModelResult) {
        self.author = review.author ?? ""
        self.content = review.content ?? ""
    }
}

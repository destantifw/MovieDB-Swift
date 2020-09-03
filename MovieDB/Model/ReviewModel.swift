//
//  ReviewModel.swift
//  MovieDB
//
//  Created by destanti on 03/09/20.
//  Copyright © 2020 destanti. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct ReviewModel: Codable {
    let id, page: Int?
    let results: [ReviewModelResult]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case id, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
struct ReviewModelResult: Codable {
    let id, author, content: String?
    let url: String?
}

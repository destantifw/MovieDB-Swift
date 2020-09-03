//
//  MovieVideosModel.swift
//  MovieDB
//
//  Created by destanti on 03/09/20.
//  Copyright © 2020 destanti. All rights reserved.
//

import Foundation

// MARK: - Welcome
struct MovieVideosModel: Codable {
    let id: Int
    let results: [MovieVideosListModel]
}

// MARK: - Result
struct MovieVideosListModel: Codable {
    let id, iso639_1, iso3166_1, key: String
    let name, site: String
    let size: Int
    let type: String

    enum CodingKeys: String, CodingKey {
        case id
        case iso639_1 = "iso_639_1"
        case iso3166_1 = "iso_3166_1"
        case key, name, site, size, type
    }
}

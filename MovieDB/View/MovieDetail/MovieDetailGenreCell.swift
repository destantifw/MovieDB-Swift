//
//  MovieDetailGenreCell.swift
//  MovieDB
//
//  Created by destanti on 03/09/20.
//  Copyright © 2020 destanti. All rights reserved.
//

import UIKit

class MovieDetailGenreCell: UICollectionViewCell {
    @IBOutlet weak private var genreLabel: UILabel!
    private var viewModel : MovieDetailGenreViewModel!
    
    func fill(with viewModel: MovieDetailGenreViewModel) {
        self.viewModel = viewModel
        
        genreLabel.text = viewModel.title
    }
    
}

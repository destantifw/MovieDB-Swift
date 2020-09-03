//
//  MovieListCell.swift
//  MovieDB
//
//  Created by destanti on 02/09/20.
//  Copyright © 2020 destanti. All rights reserved.
//

import UIKit

class MovieListCell: UICollectionViewCell {
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    
    private var viewModel: MoviesListItemViewModel!
    
    func fill(with viewModel: MoviesListItemViewModel) {
        self.viewModel = viewModel
        
        movieTitle.text = viewModel.title
        guard let imgUrl = viewModel.posterImagePath else { return }
        movieImageView.loadImageUsingCache(withUrl: imgUrl)
    }
    
    
}

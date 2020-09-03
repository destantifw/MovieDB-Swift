//
//  MovieCategoryCell.swift
//  MovieDB
//
//  Created by destanti on 03/09/20.
//  Copyright © 2020 destanti. All rights reserved.
//

import UIKit

class MovieCategoryCell: UITableViewCell{
    @IBOutlet weak var categoryNameLabel: UILabel!
    
    private var viewModel: MovieCategoryCellViewModel!
    
    func fill(with viewModel: MovieCategoryCellViewModel) {
        self.viewModel = viewModel
        
        categoryNameLabel.text = viewModel.name
    }
}

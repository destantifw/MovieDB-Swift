//
//  MovieDetailReviewTableCell.swift
//  MovieDB
//
//  Created by destanti on 03/09/20.
//  Copyright © 2020 destanti. All rights reserved.
//

import UIKit

class MovieDetailReviewTableCell: UITableViewCell {
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var userContentReviewLabel: UILabel!
    
    var viewModel : MovieReviewCellViewModel!
    
    func fill(with viewModel: MovieReviewCellViewModel) {
        self.viewModel = viewModel
        
        userLabel.text = viewModel.author
        userContentReviewLabel.text = viewModel.content
        self.layoutIfNeeded()
    }
}

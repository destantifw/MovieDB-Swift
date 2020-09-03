//
//  MovieDetailController.swift
//  MovieDB
//
//  Created by destanti on 03/09/20.
//  Copyright © 2020 destanti. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class MovieDetailViewController: UIViewController {
    
    @IBOutlet var trailerWebView: WKWebView!
    @IBOutlet weak var movieTitleContainerView: UIView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var genreCollectionView: UICollectionView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var totalRateLabel: UILabel!
    @IBOutlet weak var detailInformationContainerView: UIView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var productionLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var userReviewTableView: UITableView!

    
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        return layout
    }()
    
    private let viewModel: MovieDetailViewModel
    private var movieData: DetailedMovieViewModel?
    private var videoData: TrailerViewModel?
    private var userReviewData: [MovieReviewCellViewModel]?
    private var genreData: [MovieDetailGenreViewModel]?
    
    private let reviewCellIdentifier = "MovieDetailReviewTableCell"
    private let genreCellIdentifier = "MovieDetailGenreCell"
    private let emptyDataCellIdentifier = "emptyDataTableCell"
    
    init(viewModel: MovieDetailViewModel, nibName: String) {
        self.viewModel = viewModel
        super.init(nibName: nibName, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        configureCollectionView()
        configureTableView()
    }
    
    private func configureCollectionView() {
        view.backgroundColor = .black
        
        genreCollectionView.collectionViewLayout = collectionViewLayout
        genreCollectionView.delegate = self
        genreCollectionView.dataSource = self
    }
    
    private func configureTableView(){
        userReviewTableView.separatorStyle = .singleLine
        userReviewTableView.separatorColor = .white
        userReviewTableView.separatorInset = .init(top: 0, left: 5, bottom: 0, right: 5)
        
        view.layoutIfNeeded()
        
        userReviewTableView.dataSource = self
        userReviewTableView.delegate = self
        
        userReviewTableView.register(UINib(nibName: "MovieDetailReviewTableCell", bundle: nil), forCellReuseIdentifier: reviewCellIdentifier)
        genreCollectionView.register(UINib(nibName: "MovieDetailGenreCell", bundle: nil), forCellWithReuseIdentifier: genreCellIdentifier)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBarTitle("")
        viewModel.ready()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        userReviewTableView.layoutIfNeeded()
    }
    
    private func setupViewModel() {
        viewModel.didUpdateVideo = { [weak self] data in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.videoData = data
                strongSelf.loadVideo()
                strongSelf.view.layoutIfNeeded()
            }
        }
        viewModel.didUpdateReview = { [weak self] data in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.userReviewData = data
                strongSelf.userReviewTableView.reloadData()
                strongSelf.userReviewTableView.layoutIfNeeded()
                strongSelf.view.layoutIfNeeded()
            }
        }
        viewModel.isRefreshing = { loading in
            loading ? SVProgressHUD.show() : SVProgressHUD.dismiss()
        }
        viewModel.didUpdateMovie = { [weak self] data in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                self?.movieData = data
                self?.genreData = data.genres
                self?.fillMovie()
                strongSelf.genreCollectionView.reloadData()
                strongSelf.collectionViewHeight.constant = strongSelf.genreCollectionView.collectionViewLayout.collectionViewContentSize.height
                strongSelf.view.layoutIfNeeded()
            }
        }
        viewModel.didSelecteRepo = { [weak self] id in
            guard let strongSelf = self else { return }
            let alertController = UIAlertController(title: "\(id)", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            strongSelf.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func fillMovie(){
        guard let data = movieData else { return }
        movieTitleLabel.text = data.originalTitle
        rateLabel.text = "\(data.voteAverage ?? 0.0)"
        totalRateLabel.text = data.voteCount
        overviewLabel.text = data.overview
        productionLabel.attributedText = data.productionCompanies
        countryLabel.attributedText = data.productionCountries
        languageLabel.attributedText = data.spokenLanguages
        
    }
    
    private func loadVideo(){
        let config = WKWebViewConfiguration()
        trailerWebView.uiDelegate = self
        self.trailerWebView = WKWebView(frame: self.view.frame, configuration: config)
        guard let data = videoData else {
            return
        }
        guard let url = URL(string: data.url) else {
            return
        }
        
        print("yutuburl \(url)")
        let youtubeRequest = URLRequest(url: url)
        trailerWebView.load(youtubeRequest)
    }
    
}

extension MovieDetailViewController: WKUIDelegate{
    
}

extension MovieDetailViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height / 5
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "User Reviews"
    }
    
}

extension MovieDetailViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = userReviewData
            else {
                return 0
        }
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = userReviewData else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: reviewCellIdentifier, for: indexPath) as! MovieDetailReviewTableCell
        cell.selectionStyle = .none
        cell.fill(with: data[indexPath.row])
        return cell
    }
    
    
}

extension MovieDetailViewController : UICollectionViewDelegate{
    
}

extension MovieDetailViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let data = genreData
            else {
                return 0
        }
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let data = genreData else { return UICollectionViewCell() }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: genreCellIdentifier, for: indexPath) as! MovieDetailGenreCell
        cell.fill(with: data[indexPath.row])
        return cell
    }
    
    
}
extension MovieDetailViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
            return getSize(indexPath: indexPath)
    }
    
    private func getSize(indexPath: IndexPath) -> CGSize{
        
        var width: CGFloat = 100
        let padding: CGFloat = 1
        
        let fontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
        
        if let text = genreData?[indexPath.item].title {
            width = (text as NSString).size(withAttributes: fontAttributes).width + padding
        }
    
        return CGSize(width: width, height: 30)
    }
    
}

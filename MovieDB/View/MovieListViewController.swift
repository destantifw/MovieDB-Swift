//
//  MovieListViewController.swift
//  MovieDB
//
//  Created by destanti on 02/09/20.
//  Copyright © 2020 destanti. All rights reserved.
//

import UIKit
import CRRefresh

class MovieListViewController: UIViewController {
    
    private let viewModel: MovieListViewModel
    
    private var data: [MoviesListItemViewModel]?
    
    private let movieCellIdentifier = "movieListCell"
    private let emptyDataCellIdentifier = "emptyDataCell"
    
    
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 5
        let numOfColumns: CGFloat = 2
        let itemSize: CGFloat = (UIScreen.main.bounds.width - 40) / numOfColumns
        layout.itemSize = CGSize(width: itemSize, height: (itemSize * 2))
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    init(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        definesPresentationContext = true
        
        setupViewModel()
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        view.backgroundColor = .black
        collectionView.backgroundColor = .black
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(UINib(nibName: "MovieListCell", bundle: nil), forCellWithReuseIdentifier: movieCellIdentifier)
        collectionView.register(UINib(nibName: "EmptyDataCell", bundle: nil), forCellWithReuseIdentifier: emptyDataCellIdentifier)
        
        collectionView.cr.addFootRefresh(animator: NormalFooterAnimator()) { [weak self] in
            self?.viewModel.didChangePage()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                
                self?.collectionView.cr.endLoadingMore()
                
            })
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBarTitle("Genre")
        viewModel.ready()
    }
    
    private func setupViewModel() {
        viewModel.isRefreshing = { loading in
//            UIApplication.shared.isNetworkActivityIndicatorVisible = loading
        }
        viewModel.didUpdateRepos = { [weak self] repos in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.data = repos
                strongSelf.collectionView.reloadData()
            }
        }
        viewModel.didSelecteRepo = { [weak self] id in
            let detailVC = MovieDetailViewController(viewModel: MovieDetailViewModel(networkingService: MovieDetailApi(), movieId: id), nibName: "MovieDetailViewController")
            self?.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
}

extension MovieListViewController : UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
}

extension MovieListViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let data = data
            else {
                let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: emptyDataCellIdentifier, for: indexPath) 
                return emptyCell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieCellIdentifier, for: indexPath) as! MovieListCell
        cell.fill(with: data[indexPath.row])
        return cell
    }
    
}

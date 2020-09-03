//
//  MovieDetailViewController.swift
//  MovieDB
//
//  Created by destanti on 02/09/20.
//  Copyright © 2020 destanti. All rights reserved.
//

import UIKit
import SVProgressHUD

class MovieDetail: UIViewController {
    
    private let viewModel: MovieDetailViewModel
    
    private var data: [MoviesListItemViewModel]?
    
    private let movieCellIdentifier = "movieListCell"
    private let emptyDataCellIdentifier = "emptyDataTableCell"
    
    private lazy var tableView: UITableView = UITableView(frame: .zero, style: .plain)
    
    init(viewModel: MovieDetailViewModel) {
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
        tableView.backgroundColor = .black
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        
      //  tableView.register(UINib(nibName: "MovieListCell", bundle: nil), forCellWithReuseIdentifier: movieCellIdentifier)
        tableView.register(UINib(nibName: "EmptyDataTableCell", bundle: nil), forCellReuseIdentifier: emptyDataCellIdentifier)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBarTitle("")
        viewModel.ready()
    }
    
    private func setupViewModel() {
        viewModel.isRefreshing = { loading in
            self.show(self, sender: nil)
        }
        viewModel.didUpdateMovie = { [weak self] repos in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
//                strongSelf.data = repos
                strongSelf.tableView.reloadData()
            }
        }
        viewModel.didSelecteRepo = { [weak self] id in
            guard let strongSelf = self else { return }
            let alertController = UIAlertController(title: "\(id)", message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            strongSelf.present(alertController, animated: true, completion: nil)
        }
    }
    
}

extension MovieDetail : UITableViewDelegate{
    
}

extension MovieDetail : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let data = data
//            else {
//                let emptyCell = collectionView.dequeueReusableCell(withReuseIdentifier: emptyDataCellIdentifier, for: indexPath)
//                return emptyCell
//        }
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieCellIdentifier, for: indexPath) as! MovieListCell
//        cell.fill(with: data[indexPath.row])
//        return cell
//    }
    
}

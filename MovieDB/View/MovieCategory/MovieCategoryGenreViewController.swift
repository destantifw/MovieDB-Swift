//
//  MovieCategoryGenreViewController.swift
//  MovieDB
//
//  Created by destanti on 03/09/20.
//  Copyright © 2020 destanti. All rights reserved.
//

import UIKit

class MovieCategoryGenreViewController: UIViewController {
    private let viewModel: MovieCategoryGenreViewModel
    
    private var data: [MovieCategoryCellViewModel]?
    private let movieCellIdentifier = "MovieCategoryCell"
    
    var tableView: UITableView!
    
    init(viewModel: MovieCategoryGenreViewModel, tableView: UITableView?) {
        self.viewModel = viewModel
        if let table = tableView {
            self.tableView = table
        } else {
            self.tableView = UITableView(frame: .zero, style: .plain)
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        configureTableView()
    }
    
    private func configureTableView() {
        view.backgroundColor = .black
        tableView.backgroundColor = .clear
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "MovieCategoryCell", bundle: nil), forCellReuseIdentifier: movieCellIdentifier)
        
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
        viewModel.didUpdateGenre = { [weak self] data in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.data = data
                strongSelf.tableView.reloadData()
            }
        }
        viewModel.didSelecteGenre = { [weak self] genre in
            let viewModel = MovieListViewModel(networkingService: NetworkingApi(), id: genre.id)
            let viewController = MovieListViewController(viewModel: viewModel, title: genre.name)
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension MovieCategoryGenreViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension MovieCategoryGenreViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = data else { return 0 }
        return data.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = data else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: movieCellIdentifier, for: indexPath) as! MovieCategoryCell
        cell.selectionStyle = .none
        cell.fill(with: data[indexPath.row])
        return cell
    }
    
}

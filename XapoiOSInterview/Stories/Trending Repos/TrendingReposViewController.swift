//
//  TrendingReposViewController.swift
//  XapoiOSInterview
//
//  Created by Juan Pereira on 6/18/18.
//  Copyright © 2018 Juan Pereira. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa
import ReactiveSwift

class TrendingReposViewController: UIViewController {
    
    private let repoCellIdentifier = "RepoCellView"
    private let repoCellHeight: CGFloat = 110.0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let viewModel: TrendingReposViewModel
    
    init(viewModel: TrendingReposViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "TrendingReposViewController", bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.repoChangesSignal
            .observe(on: UIScheduler())
            .observeValues({ (_) in
                guard let tableView = self.tableView else { return }
                
                tableView.reloadData()
            })
        
        viewModel.isLoading.producer
            .observe(on: UIScheduler())
            .startWithValues { (isLoading) in
                if isLoading {
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                }
        }
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "RepoCellView", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: repoCellIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
}

extension TrendingReposViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRepos()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: repoCellIdentifier, for: indexPath) as! RepoCellView
        
        cell.repoNameLabel.text = viewModel.repoNameAt(position: indexPath.row)
        cell.starsLabel.text = viewModel.repoStarsAt(position: indexPath.row)
        cell.descriptionLabel.text = viewModel.repoDescriptionAt(position: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //TODO: Present repo detail view controller
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return repoCellHeight
    }
}

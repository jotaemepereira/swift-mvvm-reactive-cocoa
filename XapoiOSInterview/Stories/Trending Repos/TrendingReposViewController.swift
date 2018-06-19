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
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(TrendingReposViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        return refreshControl
    }()
    
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
        viewModel.searchReposSignal <~ searchBar.reactive.continuousTextValues
        
        viewModel.repoChangesSignal
            .observe(on: UIScheduler())
            .observeValues {
                guard let tableView = self.tableView else { return }
                
                tableView.reloadData()
            }
        
        viewModel.alertMessageSignal
            .observe(on: UIScheduler())
            .observeValues { (alertMessage) in
                self.showErrorAlert(alertMessage: alertMessage)
            }
        
        viewModel.isLoading.producer
            .observe(on: UIScheduler())
            .startWithValues { (isLoading) in
                if isLoading {
                    self.refreshControl.beginRefreshing()
                    self.activityIndicator.startAnimating()
                } else {
                    self.refreshControl.endRefreshing()
                    self.activityIndicator.stopAnimating()
                }
        }
    }
    
    private func showErrorAlert(alertMessage: String) {
        let alertController = UIAlertController(
            title: "Error!",
            message: alertMessage,
            preferredStyle: .alert
        )
        
        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "RepoCellView", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: repoCellIdentifier)
        tableView.addSubview(self.refreshControl)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.searchBar.text = ""
        viewModel.refreshRepos()
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if searchBar.text!.isEmpty && indexPath.row == viewModel.lastPositionTillScrol() {
            self.viewModel.loadMoreRepos()
        }
    }
}

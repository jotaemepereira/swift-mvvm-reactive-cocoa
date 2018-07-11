//
//  RepoDetailViewController.swift
//  GithubTrends
//
//  Created by Juan Pereira on 6/18/18.
//  Copyright © 2018 Juan Pereira. All rights reserved.
//

import Foundation
import UIKit
import Down
import ReactiveSwift
import Kingfisher

class RepoDetailViewController: BaseViewController {
    
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var repoDescriptionLabel: UILabel!
    @IBOutlet weak var readmeView: UIView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var repoInfoContainer: UIView!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var starsContainerView: UIView!
    @IBOutlet weak var forksContainerView: UIView!
    
    private let viewModel: RepoDetailViewModel
    
    init(viewModel: RepoDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "RepoDetailViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupCircularProfileImage()
        setupInfoRepoContainer()
        bindViewModel()
    }
    
    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
        self.navigationItem.leftBarButtonItem = backButton
        navigationBar.items = [navigationItem]
    }
    
    private func setupCircularProfileImage() {
        userProfileImage.layer.cornerRadius = 40.0
        userProfileImage.layer.masksToBounds = true
    }
    
    private func setupInfoRepoContainer() {
        repoInfoContainer.layer.cornerRadius = 20.0
        repoInfoContainer.layer.masksToBounds = true
        starsContainerView.layer.cornerRadius = 20.0
        starsContainerView.layer.masksToBounds = true
        starsContainerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        forksContainerView.layer.cornerRadius = 20.0
        forksContainerView.layer.masksToBounds = true
        forksContainerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
    }
    
    private func bindViewModel() {
        navigationBar.topItem!.title = viewModel.title
        self.userNameLabel.text = viewModel.userName
        self.repoDescriptionLabel.text = viewModel.description
        self.starsLabel.text = viewModel.stars
        self.forksLabel.text = viewModel.forks
        self.userProfileImage.kf.setImage(with: viewModel.profileURL)
        
        viewModel.readmeChangeSignal
            .observe(on: UIScheduler())
            .observeValues { (markdownString) in
                let downView = try? DownView(frame: CGRect(x: 0, y: 50, width: self.readmeView.frame.width, height: self.readmeView.frame.height), markdownString: markdownString)
                self.readmeView.addSubview(downView!)
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
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.stopAnimating()
                }
        }
    }
    
    @objc func goBack() {
        self.dismiss(animated: false, completion: nil)
    }
    
}

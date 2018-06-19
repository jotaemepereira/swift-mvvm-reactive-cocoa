//
//  TrendingRepoViewModel.swift
//  XapoiOSInterview
//
//  Created by Juan Pereira on 6/18/18.
//  Copyright © 2018 Juan Pereira. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

class TrendingReposViewModel {
    //Inputs
    let searchReposSignal = MutableProperty<String?>(nil)
    let alertMessageSignal: Signal<String, NoError>
    
    // Outputs
    let repoChangesSignal: Signal<Void, NoError>
    let isLoading = MutableProperty(false)
    
    private var repos: [Repo]
    private var filteredRepos: [Repo]
    private var apiClient: ApiClient
    private var page: Int
    private var refresh = false
    private let repoChangesObserver: Signal<Void, NoError>.Observer
    private let alertMessageObserver: Signal<String, NoError>.Observer
    
    init(apiClient: ApiClient) {
        self.page = 1
        self.apiClient = apiClient
        self.repos = []
        self.filteredRepos = []
        self.isLoading.value = false
        
        let (repoChangesSignal, repoChangesObserver) = Signal<Void, NoError>.pipe()
        self.repoChangesSignal = repoChangesSignal
        self.repoChangesObserver = repoChangesObserver
        
        let (alertMessageSignal, alertMessageObserver) = Signal<String, NoError>.pipe()
        self.alertMessageSignal = alertMessageSignal
        self.alertMessageObserver = alertMessageObserver
        
        
        SignalProducer(searchReposSignal)
            .on(starting: { self.isLoading.value = true })
            .map { (query) -> [Repo] in
                if let query = query {
                    if query.isEmpty {
                        return self.repos
                    }
                    
                    return self.repos.filter {
                        $0.description.lowercased().contains(query.lowercased()) ||
                            $0.name.lowercased().contains(query.lowercased()) }
                } else {
                    return self.repos
                }
            }
            .startWithValues { (repos) in
                self.filteredRepos.removeAll()
                self.filteredRepos.append(contentsOf: repos)
                self.repoChangesObserver.send(value: ())
                self.isLoading.value = false
            }
        
        loadRepos()
    }
    
    func refreshRepos() {
        page = 1
        refresh = true
        loadRepos()
    }
    
    func loadMoreRepos() {
        page = page + 1
        loadRepos()
    }
    
    private func loadRepos() {
        apiClient.getTrendingRepos(page: page)
            .on(starting: { self.isLoading.value = true })
            .flatMap(.latest, { (repos) -> SignalProducer<[Repo], AnyError> in
                return SignalProducer<[Repo], AnyError>(value: repos)
            })
            .on(completed: { self.isLoading.value = false })
            .observe(on: UIScheduler())
            .startWithResult({ (result) in
                if let repos = result.value {
                    if self.refresh {
                        self.repos.removeAll()
                        self.filteredRepos.removeAll()
                        self.refresh = false
                    }
                    
                    self.repos.append(contentsOf: repos)
                    self.filteredRepos.append(contentsOf: repos)
                    self.repoChangesObserver.send(value: ())
                } else {
                    self.isLoading.value = false
                    self.alertMessageObserver.send(value: result.error!.localizedDescription)
                }
            })
    }
    
    func numberOfRepos() -> Int {
        return filteredRepos.count
    }
    
    func lastPositionTillScrol() -> Int {
        return filteredRepos.count - 3
    }
    
    func repoNameAt(position: Int) -> String {
        return filteredRepos[position].name
    }
    
    func repoStarsAt(position: Int) -> String {
        let stars = String(filteredRepos[position].stars)
        
        return "Stars: \(stars)"
    }
    
    func repoDescriptionAt(position: Int) -> String {
        return filteredRepos[position].description
    }
    
    func getRepoDetailViewModelAt(position: Int) -> RepoDetailViewModel {
        return RepoDetailViewModel(repo: filteredRepos[position], apiClient: self.apiClient)
    }
}

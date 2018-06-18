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
    
    private var repos: [Repo]
    private var apiClient: ApiClient
    
    //Inputs
    
    // Outputs
    let repoChangesSignal: Signal<Void, NoError>
    let isLoading = MutableProperty(false)
    
    private var page: Int
    private var refresh = false
    private let repoChangesObserver: Signal<Void, NoError>.Observer
    
    init(apiClient: ApiClient) {
        self.page = 1
        self.apiClient = apiClient
        self.repos = []
        self.isLoading.value = false
        
        let (repoChangesSignal, repoChangesObserver) = Signal<Void, NoError>.pipe()
        self.repoChangesSignal = repoChangesSignal
        self.repoChangesObserver = repoChangesObserver
        
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
            .flatMap(.latest, { (repos) -> SignalProducer<[Repo], NoError> in
                return SignalProducer<[Repo], NoError>(value: repos)
            })
            .on(completed: { self.isLoading.value = false })
            .promoteError()
            .observe(on: UIScheduler())
            .startWithValues { (repos) in
                if self.refresh {
                    self.repos.removeAll()
                    self.refresh = false
                }
                
                self.repos.append(contentsOf: repos)
                self.repoChangesObserver.send(value: ())
        }
    }
    
    func numberOfRepos() -> Int {
        return repos.count
    }
    
    func lastPositionTillScrol() -> Int {
        return repos.count - 3
    }
    
    func repoNameAt(position: Int) -> String {
        return repos[position].name
    }
    
    func repoStarsAt(position: Int) -> String {
        let stars = String(repos[position].stars)
        
        return "Stars: \(stars)"
    }
    
    func repoDescriptionAt(position: Int) -> String {
        return repos[position].description
    }
}

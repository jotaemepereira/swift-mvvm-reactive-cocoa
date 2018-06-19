//
//  RepoDetailViewModel.swift
//  XapoiOSInterview
//
//  Created by Juan Pereira on 6/18/18.
//  Copyright © 2018 Juan Pereira. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

class RepoDetailViewModel {
 
    //Outputs
    let isLoading = MutableProperty(false)
    let alertMessageSignal: Signal<String, NoError>
    let readmeChangeSignal: Signal<String, NoError>
    
    lazy var title: String = {
        [unowned self] in
        return repo.name
    }()
    
    lazy var userName: String = {
        [unowned self] in
            return repo.owner!.login
        }()
    
    lazy var description: String = {
        [unowned self] in
        return repo.description
        }()
    
    lazy var profileURL: URL = {
        [unowned self] in
        return URL(string: repo.owner!.avatarURL)!
        }()
    
    lazy var forks: String = {
        [unowned self] in
        return "\(String(repo.forks)) Forks"
        }()
    
    lazy var stars: String = {
        [unowned self] in
        return "\(String(repo.stars)) Stars"
    }()
    private let readmeChangeObserver: Signal<String, NoError>.Observer
    private let alertMessageObserver: Signal<String, NoError>.Observer
    
    private let repo: Repo
    private let apiClient: ApiClient
    
    init(repo: Repo, apiClient: ApiClient) {
        self.repo = repo
        self.apiClient = apiClient
        
        let (readmeChangeSignal, readmeChangeObserver) = Signal<String, NoError>.pipe()
        self.readmeChangeSignal = readmeChangeSignal
        self.readmeChangeObserver = readmeChangeObserver
        
        let (alertMessageSignal, alertMessageObserver) = Signal<String, NoError>.pipe()
        self.alertMessageSignal = alertMessageSignal
        self.alertMessageObserver = alertMessageObserver
        
        apiClient.getReadme(owner: repo.owner!.login, repoName: repo.name)
            .on(starting: { self.isLoading.value = true })
            .flatMap(.latest) { (readme) -> SignalProducer<Readme, AnyError> in
                return SignalProducer<Readme, AnyError>(value: readme)
            }
            .on(completed: { self.isLoading.value = false })
            .observe(on: UIScheduler())
            .startWithResult { (result) in
                if let readme = result.value {
                    if let decoded = readme.content.base64Decoded() {
                        readmeChangeObserver.send(value: decoded)
                    }
                } else {
                    if let error = result.error {
                        alertMessageObserver.send(value: error.localizedDescription)
                    }
                }
            }
    }
}

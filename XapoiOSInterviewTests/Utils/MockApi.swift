//
//  MockApi.swift
//  XapoiOSInterviewTests
//
//  Created by Juan Pereira on 6/18/18.
//  Copyright © 2018 Juan Pereira. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

class MockApi: ApiClientProtocol {
    
    let error = NSError(domain: "Error", code: 100, userInfo: nil)
    
    var successGetTrending = false
    var successGetReadme = false
    
    func getTrendingRepos(page: Int) -> SignalProducer<[Repo], AnyError> {
        if successGetTrending {
            return SignalProducer<[Repo], AnyError>.init(value: self.createMockRepos())
        } else {
            return SignalProducer<[Repo], AnyError>.init(error: AnyError(error))
        }
    }
    
    func getReadme(owner: String, repoName: String) -> SignalProducer<Readme, AnyError> {
        if successGetReadme {
            return SignalProducer<Readme, AnyError>.init(value: Readme())
        } else {
            return SignalProducer<Readme, AnyError>.init(error: AnyError(error))
        }
    }
    
    private func createMockRepos() -> [Repo] {
        var repos = [Repo]()
        
        let owner = Owner(login: "Juan", avatarURL: "avatar_test")
        let repo1 = Repo(name: "Repo 1", description: "Repo 1 Description", stars: 25, forks: 26, owner: owner)
        let repo2 = Repo(name: "Repo 2", description: "Repo 2 Description", stars: 27, forks: 28, owner: owner)
        let repo3 = Repo(name: "Repo 3", description: "Repo 3 Description", stars: 29, forks: 30, owner: owner)
        
        repos.append(repo1)
        repos.append(repo2)
        repos.append(repo3)
        
        return repos
    }
}

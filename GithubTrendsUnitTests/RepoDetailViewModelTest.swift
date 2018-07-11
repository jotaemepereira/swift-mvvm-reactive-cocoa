//
//  RepoDetailViewModelTest.swift
//  GithubTrendsTests
//
//  Created by Juan Pereira on 6/19/18.
//  Copyright © 2018 Juan Pereira. All rights reserved.
//

import XCTest
@testable import Pods_Github_Trends

class RepoDetailViewModelTest: XCTestCase {
    
    let mockApi = MockApi()
    
    override func setUp() {
        super.setUp()
    }
    
    func testTitleValue_isCorrect() {
        mockApi.successGetReadme = true
        let repo = createFakeRepo()
        
        let subject = RepoDetailViewModel(repo: repo, apiClient: mockApi)
        
        XCTAssertEqual(subject.title, repo.name)
    }
    
    func testDescriptionValue_isCorrect() {
        mockApi.successGetReadme = true
        let repo = createFakeRepo()
        
        let subject = RepoDetailViewModel(repo: repo, apiClient: mockApi)
        
        XCTAssertEqual(subject.description, repo.description)
    }
    
    func testStarsValue_isCorrect() {
        mockApi.successGetReadme = true
        let repo = createFakeRepo()
        
        let subject = RepoDetailViewModel(repo: repo, apiClient: mockApi)
        
        XCTAssertEqual(subject.stars, "\(repo.stars) Stars")
    }
    
    func testForksValue_isCorrect() {
        mockApi.successGetReadme = true
        let repo = createFakeRepo()
        
        let subject = RepoDetailViewModel(repo: repo, apiClient: mockApi)
        
        XCTAssertEqual(subject.forks, "\(repo.forks) Forks")
    }
    
    func testProfileURLValue_isCorrect() {
        mockApi.successGetReadme = true
        let repo = createFakeRepo()
        
        let subject = RepoDetailViewModel(repo: repo, apiClient: mockApi)
        
        XCTAssertEqual(subject.profileURL, URL(string: repo.owner!.avatarURL)!)
    }
    
    private func createFakeRepo() -> Repo {
        let owner = Owner(login: "Juan", avatarURL: "avatar_test")
        return Repo(name: "Repo", description: "Repo Description", stars: 25, forks: 26, owner: owner)
    }
}

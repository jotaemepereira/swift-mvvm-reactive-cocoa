//
//  XapoiOSInterviewTests.swift
//  XapoiOSInterviewTests
//
//  Created by Juan Pereira on 6/18/18.
//  Copyright © 2018 Juan Pereira. All rights reserved.
//

import XCTest
@testable import XapoiOSInterview

class TrendingReposViewModelTest: XCTestCase {
    
    let mockApi = MockApi()
    
    override func setUp() {
        super.setUp()
    }
    
    func testRepoList_hasTheCorrectSize() {
        mockApi.successGetTrending = true
        
        let subject = TrendingReposViewModel(apiClient: mockApi)
        
        XCTAssert(!subject.isLoading.value)
        XCTAssertEqual(subject.numberOfRepos(), 3)
    }
    
    func testRepoNames_areCorrectlySet() {
        mockApi.successGetTrending = true
        
        let subject = TrendingReposViewModel(apiClient: mockApi)
        
        XCTAssertEqual(subject.repoNameAt(position: 0), "Repo 1")
        XCTAssertEqual(subject.repoNameAt(position: 1), "Repo 2")
        XCTAssertEqual(subject.repoNameAt(position: 2), "Repo 3")
    }
    
    func testRepoStars_areCorrectlySet() {
        mockApi.successGetTrending = true
        
        let subject = TrendingReposViewModel(apiClient: mockApi)
        
        XCTAssertEqual(subject.repoStarsAt(position: 0), "Stars: 25")
        XCTAssertEqual(subject.repoStarsAt(position: 1), "Stars: 27")
        XCTAssertEqual(subject.repoStarsAt(position: 2), "Stars: 29")
    }
    
    func testRepoDescriptions_areCorrectlySet() {
        mockApi.successGetTrending = true
        
        let subject = TrendingReposViewModel(apiClient: mockApi)
        
        XCTAssertEqual(subject.repoDescriptionAt(position: 0), "Repo 1 Description")
        XCTAssertEqual(subject.repoDescriptionAt(position: 1), "Repo 2 Description")
        XCTAssertEqual(subject.repoDescriptionAt(position: 2), "Repo 3 Description")
    }
    
    func testLoadMoreRepos_increasesReposList() {
        mockApi.successGetTrending = true
        
        let subject = TrendingReposViewModel(apiClient: mockApi)
        
        subject.loadMoreRepos()
        
        XCTAssertEqual(subject.numberOfRepos(), 6)
    }
    
    func testLoadReposWhenRefreshing_clearsListOfRepos() {
        mockApi.successGetTrending = true
        
        let subject = TrendingReposViewModel(apiClient: mockApi)
        
        subject.refreshRepos()
        
        XCTAssertEqual(subject.numberOfRepos(), 3)
    }
    
    func testCorrectViewModel_isCreatedWhenRepoIsSelected() {
        mockApi.successGetTrending = true
        
        let subject = TrendingReposViewModel(apiClient: mockApi)
        let repoDetail = subject.getRepoDetailViewModelAt(position: 0)
        
        XCTAssertEqual(repoDetail.title, "Repo 1")
    }
    
    func testListIsEmpty_onNetworkError() {
        mockApi.successGetTrending = false
        
        let subject = TrendingReposViewModel(apiClient: mockApi)
        
        XCTAssertEqual(subject.numberOfRepos(), 0)
    }
}

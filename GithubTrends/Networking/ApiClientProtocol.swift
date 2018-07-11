//
//  ApiClientProtocol.swift
//  GithubTrends
//
//  Created by Juan Pereira on 6/18/18.
//  Copyright © 2018 Juan Pereira. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

protocol ApiClientProtocol {
    func getTrendingRepos(page: Int) -> SignalProducer<[Repo], AnyError>
    func getReadme(owner: String, repoName: String) -> SignalProducer<Readme, AnyError>
}

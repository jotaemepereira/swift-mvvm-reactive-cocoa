//
//  ApiClient.swift
//  XapoiOSInterview
//
//  Created by Juan Pereira on 6/18/18.
//  Copyright © 2018 Juan Pereira. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ReactiveSwift
import ObjectMapper
import Result

protocol ApiClientProtocol {
    func getTrendingRepos(page: Int) -> SignalProducer<[Repo], NoError>
    func getReadme(owner: String, repoName: String) -> SignalProducer<Readme, NoError>
}

struct ApiClient: ApiClientProtocol {

    func getTrendingRepos(page: Int) -> SignalProducer<[Repo], NoError> {
        return SignalProducer { observer, disposable in
            Alamofire.request(ApiRouter.getTrendingRepos(page: page, query: "ios", sort: "stars", order: "desc"))
            .validate()
            .responseObject { (response: DataResponse<RepoSearchResponse>) in
                switch response.result {
                case .success:
                    observer.send(value: response.result.value!.items)
                    observer.sendCompleted()
                case .failure(let error):
                    print(error.localizedDescription)
                    observer.send(error: (error as? NoError)!)
                }
            }
        }
    }
    
    func getReadme(owner: String, repoName: String) -> SignalProducer<Readme, NoError> {
        return SignalProducer { observer, disposable in
            Alamofire.request(ApiRouter.getReadme(owner: owner, repoName: repoName))
                .validate()
                .responseObject { (response: DataResponse<Readme>) in
                    switch response.result {
                    case .success:
                        observer.send(value: response.result.value!)
                        observer.sendCompleted()
                    case .failure(let error):
                        print(error)
                        observer.send(error: (error as? NoError)!)
                    }
            }
        }
    }
}

extension Request {
    public func debugLog() -> Self {
        #if DEBUG
        debugPrint(self)
        #endif
        return self
    }
}


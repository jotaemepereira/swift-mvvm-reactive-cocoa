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
import ObjectMapper

protocol ApiClientProtocol {
    func getTrendingRepos(page: Int, completion: @escaping(Result<RepoSearchResponse>) -> Void)
    func getReadme(owner: String, repoName: String, completion: @escaping(Result<Readme>) -> Void)
}

struct ApiClient: ApiClientProtocol {

    func getTrendingRepos(page: Int, completion: @escaping (Result<RepoSearchResponse>) -> Void) {
        Alamofire.request(ApiRouter.getTrendingRepos(page: page, query: "ios", sort: "stars", order: "desc"))
            .debugLog()
            .validate()
            .responseObject { (response: DataResponse<RepoSearchResponse>) in
                switch response.result {
                case .success:
                    completion(Result.success(response.value!))
                case .failure(let error):
                    print(error)
                    completion(Result.failure(error))
                }
        }
    }
    
    func getReadme(owner: String, repoName: String, completion: @escaping (Result<Readme>) -> Void) {
        Alamofire.request(ApiRouter.getReadme(owner: owner, repoName: repoName))
            .validate()
            .responseObject { (response: DataResponse<Readme>) in
                switch response.result {
                case .success:
                    completion(Result.success(response.value!))
                case .failure(let error):
                    print(error)
                    completion(Result.failure(error))
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


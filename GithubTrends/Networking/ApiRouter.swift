//
//  ApiRouter.swift
//  GithubTrends
//
//  Created by Juan Pereira on 6/18/18.
//  Copyright © 2018 Juan Pereira. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

protocol ApiConfiguration: URLRequestConvertible {
    var method: HTTPMethod { get }
    var path: String { get }
    var parameters: Parameters? { get }
}

enum ApiRouter: ApiConfiguration {
    
    case getTrendingRepos(page: Int, query: String, sort: String, order: String)
    case getReadme(owner: String, repoName: String)
    
    var method: HTTPMethod {
        switch self {
        case .getReadme:
            return .get
        case .getTrendingRepos:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getTrendingRepos:
            return "/search/repositories"
        case .getReadme(let owner, let repoName):
            return "/repos/\(owner)/\(repoName)/readme"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getTrendingRepos(let page, let query, let sort, let order):
            return ["page": String(page), "q": query, "sort": sort, "order": order]
        case .getReadme:
            return nil
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var urlComponent = URLComponents(string: NetworkConstants.baseURL + path)!
        var items = [URLQueryItem]()
        
        if let parameters = parameters {
            for (key,value) in parameters {
                items.append(URLQueryItem(name: key, value: value as? String))
            }
        }
        
        urlComponent.queryItems = items
        var urlRequest = URLRequest(url: urlComponent.url!)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        urlRequest.httpMethod = method.rawValue
        
        return urlRequest
    }
    
    
}

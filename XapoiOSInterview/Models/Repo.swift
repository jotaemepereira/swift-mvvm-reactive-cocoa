//
//  Repo.swift
//  XapoiOSInterview
//
//  Created by Juan Pereira on 6/18/18.
//  Copyright © 2018 Juan Pereira. All rights reserved.
//

import Foundation
import ObjectMapper

class RepoSearchResponse: Mappable {
    var totalCount = 0
    var incompleteResults = false
    var items = [Repo]()
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        totalCount <- map["total_count"]
        incompleteResults <- map["incomplete_results"]
        items <- map["items"]
    }
}

class Repo: Mappable {
    var name = ""
    var description = ""
    var stars = 0
    var forks = 0
    var owner: Owner?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        name <- map["name"]
        description <- map["description"]
        stars <- map["stargazers_count"]
        forks <- map["forks"]
        owner <- map["owner"]
    }
}

class Owner: Mappable {
    var login = ""
    var avatarURL = ""
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        login <- map["login"]
        avatarURL <- map["avatar_url"]
    }
}


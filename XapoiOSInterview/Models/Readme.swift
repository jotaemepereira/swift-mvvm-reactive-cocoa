//
//  Readme.swift
//  XapoiOSInterview
//
//  Created by Juan Pereira on 6/18/18.
//  Copyright © 2018 Juan Pereira. All rights reserved.
//

import Foundation
import ObjectMapper

class Readme: Mappable {
    var content = ""
    var encoding = ""
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        content <- map["content"]
        encoding <- map["encoding"]
    }
}

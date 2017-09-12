//
//  WebserviceJSON.swift
//  Demo ReignDesign
//
//  Created by Daniel López  on 11-09-17.
//  Copyright © 2017 Daniel. All rights reserved.
//

import EVReflection

class WebserviceJSON: EVObject{
    var hits: [Hit] = []
    var page: Int = 0
    var nbPages: Int = 0
    var hitsPerPage: Int = 0
    var processingTimeMS: Int = 0
    var exhaustiveNbHits: Bool = false
    var query : String = ""
    var params : String = ""
}

class Hit: EVObject{
    var created_at : String = ""
    var title : String = ""
    var url : String = ""
    var author : String = ""
    var story_title : String = ""
    var story_url : String = ""
    var created_at_i : Int = 0
    var story_id : Int = 0
}

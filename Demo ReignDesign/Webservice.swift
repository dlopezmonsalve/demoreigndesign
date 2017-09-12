//
//  Webservice.swift
//  Demo ReignDesign
//
//  Created by Daniel López  on 11-09-17.
//  Copyright © 2017 Daniel. All rights reserved.
//

import Alamofire

class Webservice {
    
    init(){
        
    }
    
    class func getStories(completion: @escaping (Any) -> Void){
        
        let url : String = "http://hn.algolia.com/api/v1/search_by_date?query=ios"
        
        Alamofire.request(
            URL(string: url)!,
            method: .get)
            .validate()
            .responseString { response in
                guard response.result.isSuccess else {
                    print("Error while fetching tags: \(response.result.error)")
                    completion(false)
                    return
                }
                
                guard let responseJSON = response.result.value else {
                    print("Invalid tag information received from the service")
                    completion(false)
                    return
                }
                
                let json = WebserviceJSON(json: responseJSON)
                
                completion(json)
        }
    }
}

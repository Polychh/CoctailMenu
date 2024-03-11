//
//  File.swift
//  CoctailMenu
//
//  Created by Polina on 11.03.2024.
//

import Foundation



struct CoctailRequest: CoctailRequestProtocol{
   
    typealias Response = CoctailData
    
    let cotailName: String?
    let ingridients: String?
    let paramToChoose: Param
    
    
    var param: Param{
        paramToChoose
    }
    
    var url: String {
        let baseUrl = "https://api.api-ninjas.com/v1/cocktail"
        return baseUrl
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var headers: [String : String]?{
        let headers = [
            "X-Api-Key": "wxtyeSNfBjqN3so2bKQLlobqLoQJMB12ALwi4BID",
        ]
        return headers
    }
    
    var queryItems: [String : String]?{
        switch paramToChoose{
        case .coctailName:
            if let cotailName {
                let params = [
                    "name": "\(cotailName)",
                ]
                return params
            }
          
        case .ingridients:
            if let ingridients{
                let params = [
                    "ingredients": "\(ingridients)",
                ]
                return params
            }
        }
       return nil
    }
}

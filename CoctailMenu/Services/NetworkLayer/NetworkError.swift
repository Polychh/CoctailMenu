//
//  NetworkError.swift
//  CoctailMenu
//
//  Created by Polina on 11.03.2024.
//

import Foundation

enum NetworkError: Error, LocalizedError{
    case invalidURL
    case invalidResponse
    case invalidData
    case unknow(Error)
    
    var errorDescription: String?{
        switch self{
        case .invalidURL:
            return "Wrong URL"
        case .invalidResponse:
            return  "Wrong Response"
        case .invalidData:
            return "Can not to decode Data"
        case .unknow(let error):
            return error.localizedDescription
        }
    }
}

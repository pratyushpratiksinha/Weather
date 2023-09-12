//
//  URN.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 11/09/23.
//

import Foundation

protocol URN {
    associatedtype Derived: Decodable
    var endPoint: EndPoints { get }
    var baseURL: BaseUrl { get }
    var method: HTTPMethod { get }
    var parameters: [String: String]? { get }
    var urlQueryItems: [URLQueryItem] { get }
    var headers: [String: String]? { get }
}

extension URN {
    
    var urlQueryItems: [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        if let parameters = parameters {
            for eachQueryParam in parameters {
                queryItems.append(URLQueryItem(name: eachQueryParam.key, value: eachQueryParam.value))
            }
        }
        return queryItems
    }
    
    var headers: [String: String]? {
        return [NetworkConstants.Content_Type: NetworkConstants.Application_Json]
    }
}

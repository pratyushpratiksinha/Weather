//
//  NetworkConstants.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 11/09/23.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

struct NetworkConstants {
    static let Content_Type = "Content-Type"
    static let Application_Json = "application/json"
}

struct HTTPStatus {
    static let internetFailure:Int = 0
    static let success = 200...299
    static let done:Int = 200
    static let created:Int = 201
    static let noContentAvailable:Int = 204
    static let faliure = 400...499
    static let unauthorized:Int = 401
    static let forbidden:Int = 403
    static let resourceNotExist:Int = 404
    static let conflict:Int = 409
    static let badRequest:Int  = 400
    static let imageNotUploaded:Int = 5000
}

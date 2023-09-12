//
//  NetworkError.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 11/09/23.
//

import Foundation

enum NetworkError: Error, Equatable {
    
    case unableToFindBaseURL
    case timedOut
    case cannotConnectToHost
    case unknownError
    case customError(error: String)
    case unknownStatusCode(statusCode: Int)
    case parsingError
    case noInternet
    case jsonParametersNotGenerated
    case serverError
    case badServerResponse
    
    var title: String {
        switch self {
        case .noInternet:
            return "Network.Error.NoInternet".localized
        default:
            return "Network.Error.Text".localized
        }
    }
    
    var description: String {
        switch self {
        case .unableToFindBaseURL:
            return "Network.Error.UnableToFindBaseURL".localized
        case .timedOut:
            return "Network.Error.TimedOut".localized
        case .cannotConnectToHost:
            return "Network.Error.CannotConnectToHost".localized
        case .unknownError:
            return "Network.Error.UnknownError".localized
        case .customError(let error):
            return error
        case .unknownStatusCode(let statusCode):
            return String(format: "Network.Error.UnknownStatusCode".localized, arguments: [statusCode])
        case .parsingError:
            return "Network.Error.ParsingError".localized
        case .noInternet:
            return "Network.Error.NoInternet".localized
        case .jsonParametersNotGenerated:
            return "Network.Error.JSONParametersNotGenerated".localized
        case .serverError:
            return "Network.Error.ServerError".localized
        case .badServerResponse:
            return "Network.Error.BadServerResponse".localized
        }
    }
}

//
//  APIClient.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 11/09/23.
//

import Foundation
import UIKit

final class APIClient {
    
    final func fireAPI<T: URN>(with urnData: T, onCompletion: @escaping (Result<T.Derived, NetworkError>) -> Void) {
        
        let networkReachabilityManager = NetworkReachabilityManager()
        
        DispatchQueue.global(qos: .background).async {
            guard networkReachabilityManager?.isReachable == true else {
                onCompletion(.failure(.noInternet))
                return
            }
            
            let url = urnData.baseURL.rawValue + urnData.endPoint.rawValue
            print("\n\n url ====>>>>>> \(url)")
            var urlComponents = URLComponents(string: url)!
            urlComponents.queryItems = urnData.urlQueryItems
            var request = URLRequest(url: urlComponents.url!)
            request.httpMethod = urnData.method.rawValue
            request.allHTTPHeaderFields = urnData.headers
            print("\n\n request ====>>>>>> \(request)")

            let sessionConfig = URLSessionConfiguration.default
            sessionConfig.timeoutIntervalForRequest = 20.0
            sessionConfig.timeoutIntervalForResource = 40.0
            let session = URLSession(configuration: sessionConfig)
            
            let task = session.dataTask(with: request) { (data, response, error) in
                
                if let error = error {
                    onCompletion(.failure(.customError(error: error.localizedDescription)))
                    return
                }
                
                guard let data = data, let httpResponse = response as? HTTPURLResponse else {
                    onCompletion(.failure(.unknownError))
                    return
                }
                
                let statusCode = httpResponse.statusCode
                print("\n\n statusCode ====>>>>>> \(statusCode)")
                switch statusCode {
                    
                //predefined faliure cases
                case NSURLErrorBadURL, NSURLErrorUnsupportedURL:
                    onCompletion(.failure(.unableToFindBaseURL))
                case NSURLErrorCannotFindHost, NSURLErrorCannotConnectToHost:
                    onCompletion(.failure(.cannotConnectToHost))
                case NSURLErrorUnknown:
                    onCompletion(.failure(.unknownError))
                case NSURLErrorTimedOut:
                    onCompletion(.failure(.timedOut))
                case NSURLErrorNetworkConnectionLost, NSURLErrorNotConnectedToInternet, HTTPStatus.internetFailure:
                    onCompletion(.failure(.noInternet))
                case NSURLErrorBadServerResponse:
                    onCompletion(.failure(.badServerResponse))
                    
                //success from server
                case HTTPStatus.success:
                    JSONParser().parseJSON(from: data, onCompletion: onCompletion)
                    
                //faliure from server
                case HTTPStatus.faliure:
                    onCompletion(.failure(.customError(error: "Error Status Code = \(statusCode)")))
                default:
                    onCompletion(.failure(.unknownError))
                }
            }
            task.resume()
        }
    }
}

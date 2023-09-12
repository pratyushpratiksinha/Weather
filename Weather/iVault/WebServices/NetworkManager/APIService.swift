//
//  APIService.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 11/09/23.
//

import Foundation

protocol APIServiceProvider {
    func request<T: URN>(with URN: T, onCompletion: @escaping (Result<T.Derived, NetworkError>) -> Void)
}

extension APIServiceProvider where Self: AnyObject {
    func request<T: URN>(with URN: T, onCompletion: @escaping (Result<T.Derived, NetworkError>) -> Void) {
        APIClient().fireAPI(with: URN, onCompletion: onCompletion)
    }
}

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

final class APIService: APIClient, APIServiceProvider {
    func request<T: URN>(with URN: T, onCompletion: @escaping (Result<T.Derived, NetworkError>) -> Void) {
        fireAPI(with: URN, onCompletion: onCompletion)
    }
}

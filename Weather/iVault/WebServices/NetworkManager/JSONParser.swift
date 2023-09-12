//
//  JSONParser.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 11/09/23.
//

import Foundation

final class JSONParser {
    
    final func parseJSON<T: Decodable>(from data: Data, onCompletion: @escaping(Result<T, NetworkError>)->()) {
        DispatchQueue.global(qos: .userInteractive).async {
            if let derivedModel = CodableMapper<T>().convert(from: data) {
                onCompletion(.success(derivedModel))
            } else {
                onCompletion(.failure(.parsingError))
            }
        }
    }
}

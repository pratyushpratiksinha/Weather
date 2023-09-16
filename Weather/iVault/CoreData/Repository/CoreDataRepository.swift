//
//  CoreDataRepository.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 15/09/23.
//

import Foundation

protocol CoreDataRepository {
    associatedtype T
    func create(record: T, onCompletion: @escaping (Bool) -> Void)
    func getAll() -> [T]?
    func get(byIdentifier id: Int, onCompletion: @escaping (T?) -> Void)
    func update(record: T, onCompletion: @escaping (Bool) -> Void)
    func delete(byIdentifier id: Int, onCompletion: @escaping (Bool) -> Void)
}

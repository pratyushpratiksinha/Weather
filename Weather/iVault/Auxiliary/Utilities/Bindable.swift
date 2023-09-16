//
//  Bindable.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 11/09/23.
//

import Foundation

//MARK: - Bindable
///generic bindable class for observing values
final class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    final func bind(observer: @escaping (T?) -> ()) {
        self.observer = observer
    }
}

//
//  CityVM.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 12/09/23.
//

import Foundation

class CityVM: APIServiceProvider, TemperatureScaleConversionDataSource {
    private(set) lazy var cityList = Bindable<[CityTVCModel]>()
    private(set) var temperatureScale: TemperatureScale = .celsius
}


//
//  CityVMTests.swift
//  WeatherTests
//
//  Created by Pratyush Pratik Sinha on 17/09/23.
//

import XCTest
import CoreLocation
@testable import Weather

final class CityVMTests: XCTestCase {
    
    func testfireAPIGetCityForecastSuccess() {
        let mockCityAPIServiceSuccess = MockCityAPIServiceSuccess()
        let viewModel = CityVM(apiService: mockCityAPIServiceSuccess)
        viewModel.fireAPIGETWeatherForecast(for: CLLocation(latitude: 33.9731, longitude: -118.24)) {
            XCTAssertTrue((viewModel.cityForecast.value?.count ?? 0) > 0)
        }
    }
    
    func testfireAPIGetCityConditionSuccess() {
        let mockCityAPIServiceSuccess = MockCityAPIServiceSuccess()
        let viewModel = CityVM(apiService: mockCityAPIServiceSuccess)
        viewModel.fireAPIGETWeatherForecast(for: CLLocation(latitude: 33.9731, longitude: -118.24)) {
            XCTAssertTrue((viewModel.cityCondition.value?.count ?? 0) > 0)
        }
    }
    
    func testfireAPIGetCityListFaliure() {
        let mockCityAPIServiceError = MockCityAPIServiceError()
        let viewModel = CityVM(apiService: mockCityAPIServiceError)
        viewModel.fireAPIGETWeatherForecast(for: CLLocation(latitude: 0, longitude: 0))
        XCTAssertTrue(viewModel.error.value?.description != "")
    }
    
    func testCityVMWithForecastDataModel() {
        let obj = CityForecastWeatherDataCVCModel(id: 3243235, dt: 3243235, day: "Today", icon: "https://openweathermap.org//img/wn/icon.png", temperatureHigh: -228.14999999999998, temperatureLow: -246.14999999999998)
        let cityVM = CityVM()
        cityVM.testCityForecast(for: obj)
        XCTAssertEqual(obj, cityVM.cityForecast.value?[0])
    }

    func testCityVMWithConditionDataModel() {
        let arr = [CityConditionWeatherDataCVCModel(id: 3243235, title: "Sea level", message: "1016"), CityConditionWeatherDataCVCModel(id: 3243235, title: "Pressure", message: "1016"), CityConditionWeatherDataCVCModel(id: 3243235, title: "Feels like", message: "-236"), Weather.CityConditionWeatherDataCVCModel(id: 3243235, title: "Humidity", message: "86"), CityConditionWeatherDataCVCModel(id: 3243235, title: "Ground level", message: "1009")]
        let cityVM = CityVM()
        cityVM.testCityCondition(for: arr)
        XCTAssertEqual(arr, cityVM.cityCondition.value)
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

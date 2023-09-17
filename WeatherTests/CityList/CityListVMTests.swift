//
//  CityListVMTests.swift
//  WeatherTests
//
//  Created by Pratyush Pratik Sinha on 17/09/23.
//

import XCTest
import CoreLocation
@testable import Weather

final class CityListVMTests: XCTestCase {
    
    func testfireAPIGetCityListSuccess() {
        let mockCityListAPIServiceSuccess = MockCityListAPIServiceSuccess()
        let viewModel = CityListVM(apiService: mockCityListAPIServiceSuccess)
        viewModel.fireAPIGETWeather(for: CLLocation(latitude: 33.9731, longitude: -118.24)) {
            XCTAssertTrue((viewModel.cityList.value?.count ?? 0) > 0)
        }
    }
    
    func testfireAPIGetCityListFaliure() {
        let mockCityListAPIServiceError = MockCityListAPIServiceError()
        let viewModel = CityListVM(apiService: mockCityListAPIServiceError)
        viewModel.fireAPIGETWeather(for: CLLocation(latitude: 0, longitude: 0))
        XCTAssertTrue(viewModel.error.value?.description != "")
    }
    
    func testCityListVMWithDataModel() {
        let obj = CityTVCModel(id: 201301, cityName: "Noida", countryName: "India", weatherDescription: WeatherDescription.clearSky.rawValue, backgroundImage: WeatherDescription.clearSky.dayImage, temperatureCurrent: 35, temperatureHigh: 42, temperatureLow: 26, location: .init(latitude: 28.5355, longitude: 77.3910))
        let cityListVM = CityListVM()
        cityListVM.testCityList(for: obj)
        XCTAssertEqual(obj, cityListVM.cityList.value?[0])
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

//
//  CityTodayWeatherDataCVC.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 12/09/23.
//

import UIKit

struct CityTodayWeatherDataCVCModel: Hashable {
    let id: Int
    let cityName: String
    let countryName: String
    let weatherDescription: String
    var temperatureCurrent: Double
    var temperatureHigh: Double
    var temperatureLow: Double
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(cityName)
    }
    
    static func == (lhs: CityTodayWeatherDataCVCModel, rhs: CityTodayWeatherDataCVCModel) -> Bool {
        lhs.id == rhs.id && lhs.cityName == rhs.cityName && lhs.countryName == rhs.countryName && lhs.weatherDescription == rhs.weatherDescription && lhs.temperatureCurrent == rhs.temperatureCurrent && lhs.temperatureHigh == rhs.temperatureHigh && lhs.temperatureLow == rhs.temperatureLow
    }
}

class CityTodayWeatherDataCVC: UICollectionViewCell {
    
    private let customView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 10.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let cityNameLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.numberOfLines = 1
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let temperatureCurrentLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.numberOfLines = 1
        lbl.font = UIFont.systemFont(ofSize: 40, weight: .heavy)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let weatherDescriptionLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.numberOfLines = 1
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let temperatureHighLowLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.numberOfLines = 1
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(customView)
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            customView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            customView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            customView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
        
        customView.addSubview(cityNameLabel)
        NSLayoutConstraint.activate([
            cityNameLabel.topAnchor.constraint(equalTo: customView.topAnchor, constant: 8),
            cityNameLabel.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 8),
            cityNameLabel.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -8),
            cityNameLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        customView.addSubview(temperatureCurrentLabel)
        NSLayoutConstraint.activate([
            temperatureCurrentLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor),
            temperatureCurrentLabel.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 8),
            temperatureCurrentLabel.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -8),
            temperatureCurrentLabel.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        customView.addSubview(weatherDescriptionLabel)
        NSLayoutConstraint.activate([
            weatherDescriptionLabel.topAnchor.constraint(greaterThanOrEqualTo: temperatureCurrentLabel.bottomAnchor),
            weatherDescriptionLabel.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 8),
            weatherDescriptionLabel.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -8),
            weatherDescriptionLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        customView.addSubview(temperatureHighLowLabel)
        NSLayoutConstraint.activate([
            temperatureHighLowLabel.topAnchor.constraint(greaterThanOrEqualTo: weatherDescriptionLabel.bottomAnchor),
            temperatureHighLowLabel.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 8),
            temperatureHighLowLabel.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -8),
            temperatureHighLowLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        self.contentView.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(for model: CityTodayWeatherDataCVCModel) {
        self.cityNameLabel.text = model.cityName
        self.weatherDescriptionLabel.text = model.weatherDescription.capitalized
        self.temperatureCurrentLabel.text = "\(Int(model.temperatureCurrent))°"
        self.temperatureHighLowLabel.text = "H:\(Int(model.temperatureHigh))°  L:\(Int(model.temperatureLow))°"
    }
}

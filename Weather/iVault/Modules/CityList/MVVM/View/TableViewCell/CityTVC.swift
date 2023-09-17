//
//  SearchTVC.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 11/09/23.
//

import UIKit
import CoreLocation

struct CityTVCModel: Hashable {
    let id: Int
    let cityName: String
    let countryName: String
    let weatherDescription: String
    let backgroundImage: String?
    var temperatureCurrent: Double
    var temperatureHigh: Double
    var temperatureLow: Double
    var location: CLLocation
    var scale: String?
    var forecast: [CityForecastWeatherDataCVCModel]?
    var condition: [CityConditionWeatherDataCVCModel]?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(cityName)
    }
    
    static func == (lhs: CityTVCModel, rhs: CityTVCModel) -> Bool {
        lhs.id == rhs.id && lhs.cityName == rhs.cityName && lhs.countryName == rhs.countryName && lhs.weatherDescription == rhs.weatherDescription && lhs.backgroundImage == rhs.backgroundImage && lhs.temperatureCurrent == rhs.temperatureCurrent && lhs.temperatureHigh == rhs.temperatureHigh && lhs.temperatureLow == rhs.temperatureLow && lhs.location == rhs.location && lhs.scale == rhs.scale && lhs.forecast == rhs.forecast  && lhs.condition == rhs.condition
    }
}

class CityTVC: UITableViewCell {
    
    private let customView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor("#89CFF0")
        view.layer.cornerRadius = 10.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backgroundImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10.0
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let cityNameLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.numberOfLines = 1
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let countryNameLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.numberOfLines = 1
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let weatherDescriptionLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.numberOfLines = 1
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let temperatureCurrentLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.numberOfLines = 1
        lbl.font = UIFont.systemFont(ofSize: 24, weight: .heavy)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let temperatureHighLowLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.numberOfLines = 1
        lbl.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(customView)
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            customView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            customView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            customView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        customView.addSubview(backgroundImageView)
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: customView.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: customView.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: customView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: customView.trailingAnchor)
        ])
        
        customView.addSubview(cityNameLabel)
        NSLayoutConstraint.activate([
            cityNameLabel.topAnchor.constraint(equalTo: customView.topAnchor, constant: 8),
            cityNameLabel.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 8)
        ])
        
        customView.addSubview(countryNameLabel)
        NSLayoutConstraint.activate([
            countryNameLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 4),
            countryNameLabel.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 8),
            countryNameLabel.trailingAnchor.constraint(equalTo: cityNameLabel.trailingAnchor)
        ])
        
        customView.addSubview(weatherDescriptionLabel)
        NSLayoutConstraint.activate([
            weatherDescriptionLabel.topAnchor.constraint(greaterThanOrEqualTo: countryNameLabel.bottomAnchor, constant: 16),
            weatherDescriptionLabel.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -8),
            weatherDescriptionLabel.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 8),
            weatherDescriptionLabel.trailingAnchor.constraint(equalTo: cityNameLabel.trailingAnchor)
        ])
        
        customView.addSubview(temperatureCurrentLabel)
        NSLayoutConstraint.activate([
            temperatureCurrentLabel.topAnchor.constraint(equalTo: customView.topAnchor, constant: 8),
            temperatureCurrentLabel.leadingAnchor.constraint(greaterThanOrEqualTo: cityNameLabel.trailingAnchor, constant: 16),
            temperatureCurrentLabel.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -16)
        ])
        
        customView.addSubview(temperatureHighLowLabel)
        NSLayoutConstraint.activate([
            temperatureHighLowLabel.topAnchor.constraint(greaterThanOrEqualTo: temperatureCurrentLabel.bottomAnchor, constant: 16),
            temperatureHighLowLabel.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -8),
            temperatureHighLowLabel.leadingAnchor.constraint(equalTo: temperatureCurrentLabel.leadingAnchor),
            temperatureHighLowLabel.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -8)
        ])
        
        self.contentView.backgroundColor = .black
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    final func setup(for model: CityTVCModel) {
        self.cityNameLabel.text = model.cityName
        self.countryNameLabel.text = model.countryName
        self.weatherDescriptionLabel.text = model.weatherDescription.capitalized
        self.temperatureCurrentLabel.text = "\(Int(model.temperatureCurrent))°"
        self.temperatureHighLowLabel.text = "H:\(Int(model.temperatureHigh))°  L:\(Int(model.temperatureLow))°"
        if let backgroundImage = model.backgroundImage {
            self.backgroundImageView.image = UIImage(named: backgroundImage)
        }
    }
}

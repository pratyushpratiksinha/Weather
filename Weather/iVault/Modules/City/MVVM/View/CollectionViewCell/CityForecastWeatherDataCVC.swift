//
//  CityForecastWeatherDataCVC.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 13/09/23.
//

import UIKit

struct CityForecastWeatherDataCVCModel: Hashable {
    let id: Int
    let day: String
    let icon: String
    var temperatureHigh: Double
    var temperatureLow: Double
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: CityForecastWeatherDataCVCModel, rhs: CityForecastWeatherDataCVCModel) -> Bool {
        lhs.id == rhs.id && lhs.day == rhs.day && lhs.icon == rhs.icon && lhs.temperatureHigh == rhs.temperatureHigh && lhs.temperatureLow == rhs.temperatureLow
    }
}

class CityForecastWeatherDataCVC: UICollectionViewCell {
    
    private let customView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray.withAlphaComponent(0.4)
        view.layer.cornerRadius = 10.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dayLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.numberOfLines = 1
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let iconImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let temperatureHighLowLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.numberOfLines = 1
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        contentView.addSubview(customView)
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            customView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            customView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            customView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0)
        ])
        
        customView.addSubview(dayLabel)
        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: customView.topAnchor, constant: 8),
            dayLabel.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 16),
            dayLabel.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -8),
            dayLabel.widthAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 16)/4)
        ])
        
        customView.addSubview(iconImageView)
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: customView.topAnchor, constant: 8),
            iconImageView.leadingAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: 8),
            iconImageView.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -8),
        ])
        iconImageView.addConstraint(NSLayoutConstraint(item: iconImageView,attribute: .width, relatedBy: .equal,toItem: iconImageView, attribute: .height, multiplier: (1.0 / 1.0),constant: 0))

        customView.addSubview(temperatureHighLowLabel)
        NSLayoutConstraint.activate([
            temperatureHighLowLabel.topAnchor.constraint(equalTo: customView.topAnchor, constant: 8),
            temperatureHighLowLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            temperatureHighLowLabel.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -16),
            temperatureHighLowLabel.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -8),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(for model: CityForecastWeatherDataCVCModel) {
        self.dayLabel.text = model.day
        self.iconImageView.loadImageUsingCacheWithURLString(model.icon, placeHolder: nil)
        self.temperatureHighLowLabel.text = "H:\(Int(model.temperatureHigh))°  L:\(Int(model.temperatureLow))°"
    }
}

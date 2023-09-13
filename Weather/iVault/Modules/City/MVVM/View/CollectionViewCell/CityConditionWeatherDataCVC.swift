//
//  CityConditionWeatherDataCVC.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 13/09/23.
//

import UIKit

struct CityConditionWeatherDataCVCModel: Hashable {
    let title: String
    let message: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    
    static func == (lhs: CityConditionWeatherDataCVCModel, rhs: CityConditionWeatherDataCVCModel) -> Bool {
        lhs.title == rhs.title && lhs.message == rhs.message
    }
}

class CityConditionWeatherDataCVC: UICollectionViewCell {
    
    private let customView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray.withAlphaComponent(0.4)
        view.layer.cornerRadius = 10.0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.numberOfLines = 1
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let messageLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.numberOfLines = 1
        lbl.font = UIFont.systemFont(ofSize: 26, weight: .heavy)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        contentView.addSubview(customView)
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            customView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            customView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        customView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: customView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -8),
            titleLabel.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        customView.addSubview(messageLabel)
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 8),
            messageLabel.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -8),
            messageLabel.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -8),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    func setup(for model: CityConditionWeatherDataCVCModel) {
        self.titleLabel.text = model.title
        self.messageLabel.text = model.message
    }
}

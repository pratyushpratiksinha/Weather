//
//  SectionHeaderCRV.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 14/09/23.
//

import UIKit

struct SectionHeaderCRVModel: Hashable {
    let title: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    
    static func == (lhs: SectionHeaderCRVModel, rhs: SectionHeaderCRVModel) -> Bool {
        lhs.title == rhs.title
    }
}

class SectionHeaderCRV: UICollectionReusableView {
    private let customView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel : UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.numberOfLines = 1
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        lbl.textAlignment = .left
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        addSubview(customView)
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            customView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            customView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        customView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: customView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: customView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    func setup(for model: SectionHeaderCRVModel) {
        self.titleLabel.text = model.title
    }
}

//
//  Loader.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 12/09/23.
//

import UIKit

fileprivate struct LoaderDisplayingConstants {
    fileprivate static let loadingView = "LoaderDisplayingLoadingView"
}

protocol LoaderDisplaying {
    func showLoadingView()
    func hideLoadingView()
}

extension LoaderDisplaying where Self: UIViewController {
    
    func showLoadingView() {
        let loadingView = LoadingView()
        view.addSubview(loadingView)
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        loadingView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height).isActive = true
        loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingView.animate()
        
        loadingView.accessibilityIdentifier = LoaderDisplayingConstants.loadingView
    }
    
    func hideLoadingView() {
        view.subviews.forEach { subview in
            if subview.accessibilityIdentifier == LoaderDisplayingConstants.loadingView {
                subview.removeFromSuperview()
            }
        }
    }
}

final class LoadingView: UIView {
    private let activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = .black.withAlphaComponent(0.4)
        isUserInteractionEnabled = true
        
        if activityIndicatorView.superview == nil {
            addSubview(activityIndicatorView)
            activityIndicatorView.color = .white
            activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
            activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            activityIndicatorView.startAnimating()
        }
    }
    
    public func animate() {
        activityIndicatorView.startAnimating()
    }
}

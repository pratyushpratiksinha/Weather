//
//  CityVC.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 11/09/23.
//

import UIKit

protocol CityDetailTopBarDelegate: AnyObject {
    func onDismissButtonCTA()
    func onAddButtonCTA()
}

class CityVC: UIViewController {
    
    private let topBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let dismissButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("CityVC.TopBar.DismissButton.Title".localized, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 10.0
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        btn.isUserInteractionEnabled = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let addButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("CityVC.TopBar.AddButton.Title".localized, for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 10.0
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        btn.isUserInteractionEnabled = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var delegate: CityDetailTopBarDelegate?
    var navigationItemTitle: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.isMovingToParent {
            setupNavigationBar()
        }
    }
}

extension CityVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

private extension CityVC {
    func setupUI() {
        setupView()
        if self.isBeingPresented {
            setupTopBar()
        }
    }
    
    func setupNavigationBar() {
        navigationItem.title = navigationItemTitle ?? ""
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    func setupView() {
        view.backgroundColor = UIColor("#89CFF0")
    }
    
    func setupTopBar() {
        view.addSubview(topBarView)
        NSLayoutConstraint.activate([
            topBarView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            topBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            topBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            topBarView.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        topBarView.addSubview(dismissButton)
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: topBarView.topAnchor),
            dismissButton.bottomAnchor.constraint(equalTo: topBarView.bottomAnchor),
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
        dismissButton.addTarget(self, action: #selector(buttonCTADismiss), for: .touchUpInside)
        
        topBarView.addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: topBarView.topAnchor),
            addButton.bottomAnchor.constraint(equalTo: topBarView.bottomAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        addButton.addTarget(self, action: #selector(buttonCTAAdd), for: .touchUpInside)
    }
}

private extension CityVC {
    @objc func buttonCTADismiss() {
        delegate?.onDismissButtonCTA()
        self.dismiss(animated: true)
    }
    
    @objc func buttonCTAAdd() {
        delegate?.onAddButtonCTA()
        self.dismiss(animated: true)
    }
}

//
//  CityVC.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 11/09/23.
//

import UIKit
import CoreLocation

protocol CityDetailTopBarDelegate: AnyObject {
    func onDismissButtonCTA()
    func onAddButtonCTA()
}

class CityVC: UIViewController {
    
    private let viewModel = CityVM()

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
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private enum CityWeatherDataCollectionViewSection {
        case todayWeather
        case condition
        case forecast
    }
    
    private typealias CityWeatherDataSourceReturnType = UICollectionViewDiffableDataSource<CityWeatherDataCollectionViewSection, CityWeatherForecastResponse.CityWeather>
    
    private lazy var cityWeatherDataSource = cityWeatherConfigureDataSource()

    var delegate: CityDetailTopBarDelegate?
    var cityData: CityTVCModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        setupBinding()
        
        viewModel.fireAPIGETWeatherForecast(for: CLLocation(latitude: 33.9731, longitude: -118.24))
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
        setupCollectionView()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationController?.navigationBar.barTintColor = .black.withAlphaComponent(0)
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
        dismissButton.addTarget(self, action: #selector(dismissButtonCTA), for: .touchUpInside)
        
        topBarView.addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: topBarView.topAnchor),
            addButton.bottomAnchor.constraint(equalTo: topBarView.bottomAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        addButton.addTarget(self, action: #selector(addButtonCTA), for: .touchUpInside)
    }
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: self.isBeingPresented ? 64 : 16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        collectionView.delegate = self
        collectionView.dataSource = cityWeatherDataSource
        collectionView.register(CityTodayWeatherDataCVC.self, forCellWithReuseIdentifier: ReusableIdentifierCVC.CityTodayWeatherDataCVC.rawValue)
    }
}

private extension CityVC {
    @objc func dismissButtonCTA() {
        delegate?.onDismissButtonCTA()
        self.dismiss(animated: true)
    }
    
    @objc func addButtonCTA() {
        delegate?.onAddButtonCTA()
        self.dismiss(animated: true)
    }
}

extension CityVC {
    func setupBinding() {
        viewModel.cityForecast.bind { [weak self] (value) in
            guard let self = self else { return }
            self.cityWeatherUpdateSnapshot()
        }
    }
}

private extension CityVC {
    private func cityWeatherConfigureDataSource() -> CityWeatherDataSourceReturnType {
        let dataSource = CityWeatherDataSourceReturnType(collectionView: collectionView) { [weak self] (collectionView, indexPath, model) -> UICollectionViewCell? in
            guard let self = self,
                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReusableIdentifierCVC.CityTodayWeatherDataCVC.rawValue, for: indexPath) as? CityTodayWeatherDataCVC else {
                return UICollectionViewCell()
            }
            if let cityData = self.cityData {
                let obj = CityTodayWeatherDataCVCModel(id: cityData.id, cityName: cityData.cityName, countryName: cityData.countryName, weatherDescription: cityData.weatherDescription, temperatureCurrent: cityData.temperatureCurrent, temperatureHigh: cityData.temperatureHigh, temperatureLow: cityData.temperatureLow)
                cell.setup(for: obj)
                return cell
            }
            return UICollectionViewCell()
        }
        return dataSource
    }
    
    func cityWeatherUpdateSnapshot(animatingChange: Bool = false) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            var snapshot = NSDiffableDataSourceSnapshot<CityWeatherDataCollectionViewSection, CityWeatherForecastResponse.CityWeather>()
            snapshot.appendSections([.todayWeather])
            snapshot.appendItems(self.viewModel.cityForecast.value?.list ?? [], toSection: .todayWeather)
            self.cityWeatherDataSource.apply(snapshot, animatingDifferences: false) {
//                self.stopLoaderAnimation()
            }
        }
    }
}

extension CityVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width - 16)
        return CGSize(width: width, height: 180)
    }
}

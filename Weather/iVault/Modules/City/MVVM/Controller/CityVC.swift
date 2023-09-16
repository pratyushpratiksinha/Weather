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
    
    private let backgroundImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10.0
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private enum CityWeatherDataCollectionViewSection {
        case todayWeather
        case forecast
        case condition
    }
    
    private enum CityWeatherDataCollectionViewItem: Hashable {
        case todayWeather(CityTVCModel)
        case forecast(CityForecastWeatherDataCVCModel)
        case condition(CityConditionWeatherDataCVCModel)
    }
    
    private typealias CityWeatherDataSourceReturnType = UICollectionViewDiffableDataSource<CityWeatherDataCollectionViewSection, CityWeatherDataCollectionViewItem>
    
    private lazy var cityWeatherDataSource = cityWeatherConfigureDataSource()

    private var temperatureScale: TemperatureScale = .celsius
    private var delegate: CityDetailTopBarDelegate?
    private var cityData: CityTVCModel?
    private var isCityObjectAlreadyAvailableInList = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        setupBinding()
        cityWeatherUpdateSnapshot()
        fireForecastAPI()
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

extension CityVC {
    final func set(delegate: CityDetailTopBarDelegate? = nil, cityData: CityTVCModel?, temperatureScale: TemperatureScale, isCityObjectAlreadyAvailableInList: Bool? = false) {
        self.delegate = delegate
        self.cityData = cityData
        self.temperatureScale = temperatureScale
        self.isCityObjectAlreadyAvailableInList = isCityObjectAlreadyAvailableInList ?? false
    }
}

private extension CityVC {
    final func setupUI() {
        setupView()
        setupBackgroundImage()
        setupTopBar()
        setupCollectionView()
    }
    
    final func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    final func setupView() {
        view.backgroundColor = UIColor("#89CFF0")
    }
    
    final func setupTopBar() {
        if self.isBeingPresented {
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
            addButton.isHidden = isCityObjectAlreadyAvailableInList
        }
    }
    
    final func setupBackgroundImage() {
        if let backgroundImage = cityData?.backgroundImage {
            view.addSubview(backgroundImageView)
            NSLayoutConstraint.activate([
                backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
                backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
            backgroundImageView.image = UIImage(named: backgroundImage)
        }
    }
    
    final func setupCollectionView() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: self.isBeingPresented ? 64 : 16),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        collectionView.delegate = self
        collectionView.dataSource = cityWeatherDataSource
        collectionView.register(CityTodayWeatherDataCVC.self, forCellWithReuseIdentifier: ReusableIdentifierCVC.CityTodayWeatherDataCVC.rawValue)
        collectionView.register(CityForecastWeatherDataCVC.self, forCellWithReuseIdentifier: ReusableIdentifierCVC.CityForecastWeatherDataCVC.rawValue)
        collectionView.register(CityConditionWeatherDataCVC.self, forCellWithReuseIdentifier: ReusableIdentifierCVC.CityConditionWeatherDataCVC.rawValue)
        collectionView.register(SectionHeaderCRV.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReusableIdentifierCRV.SectionHeaderCRV.rawValue)
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
    final func setupBinding() {
        viewModel.setTemperatureScale(temperatureScale)
        
        if let city = cityData {
            viewModel.setCityData(city)
        }
        
        viewModel.cityForecast.bind { [weak self] (_) in
            guard let self = self else { return }
            self.cityWeatherUpdateSnapshot()
        }
    }
}

private extension CityVC {
    private func cityWeatherConfigureDataSource() -> CityWeatherDataSourceReturnType {
        let dataSource = CityWeatherDataSourceReturnType(collectionView: collectionView) { (collectionView, indexPath, model) -> UICollectionViewCell? in
            switch model {
            case .todayWeather(let model):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReusableIdentifierCVC.CityTodayWeatherDataCVC.rawValue, for: indexPath) as? CityTodayWeatherDataCVC else {
                    return UICollectionViewCell()
                }
                let obj = CityTodayWeatherDataCVCModel(id: model.id, cityName: model.cityName, countryName: model.countryName, weatherDescription: model.weatherDescription, temperatureCurrent: model.temperatureCurrent, temperatureHigh: model.temperatureHigh, temperatureLow: model.temperatureLow)
                cell.setup(for: obj)
                return cell
            case .forecast(let model):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReusableIdentifierCVC.CityForecastWeatherDataCVC.rawValue, for: indexPath) as? CityForecastWeatherDataCVC else {
                    return UICollectionViewCell()
                }
                cell.setup(for: model)
                return cell
            case .condition(let model):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReusableIdentifierCVC.CityConditionWeatherDataCVC.rawValue, for: indexPath) as? CityConditionWeatherDataCVC else {
                    return UICollectionViewCell()
                }
                cell.setup(for: model)
                return cell
            }
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ReusableIdentifierCRV.SectionHeaderCRV.rawValue, for: indexPath) as? SectionHeaderCRV else {
                return UICollectionReusableView()
            }
            switch indexPath.section {
            case 0:
                header.setup(for: SectionHeaderCRVModel(title: ""))
            case 1:
                header.setup(for: SectionHeaderCRVModel(title: "CityVC.CollectionView.Section.Header.Forecast.Title".localized))
            case 2:
                header.setup(for: SectionHeaderCRVModel(title: "CityVC.CollectionView.Section.Header.Condition.Title".localized))
            default:
                return UICollectionReusableView()
            }
            return header
        }
        return dataSource
    }
    
    private func cityWeatherUpdateSnapshot(animatingChange: Bool = true) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            var snapshot = NSDiffableDataSourceSnapshot<CityWeatherDataCollectionViewSection, CityWeatherDataCollectionViewItem>()
            if let cityData = self.cityData {
                snapshot.appendSections([.todayWeather])
                snapshot.appendItems([CityWeatherDataCollectionViewItem.todayWeather(cityData)], toSection: .todayWeather)
            }
            if let cityForecastValue = self.viewModel.cityForecast.value {
                snapshot.appendSections([.forecast])
                var items = [CityWeatherDataCollectionViewItem]()
                items = cityForecastValue.compactMap{ CityWeatherDataCollectionViewItem.forecast($0) }
                snapshot.appendItems(items, toSection: .forecast)
            }
            if let cityConditionValue = self.viewModel.cityCondition.value {
                snapshot.appendSections([.condition])
                var items = [CityWeatherDataCollectionViewItem]()
                items = cityConditionValue.compactMap{ CityWeatherDataCollectionViewItem.condition($0) }
                snapshot.appendItems(items, toSection: .condition)
            }
            self.cityWeatherDataSource.apply(snapshot, animatingDifferences: animatingChange)
        }
    }
}

extension CityVC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            let width = (UIScreen.main.bounds.width - 16)
            return CGSize(width: width, height: 140)
        case 1:
            let width = self.collectionView.bounds.width
            return CGSize(width: width, height: 48)
        default:
            let width = (self.collectionView.bounds.width - 12)/2
            return CGSize(width: width, height: 96)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            return CGSize.zero
        default:
            return CGSize(width: self.collectionView.bounds.width, height: 56)
        }
    }
}

extension CityVC {
    final func fireForecastAPI() {
        viewModel.getOfflineData()
        if let latitude = cityData?.location.coordinate.latitude,
           let longitude = cityData?.location.coordinate.longitude {
            viewModel.fireAPIGETWeatherForecast(for: CLLocation(latitude: latitude, longitude: longitude))
        }
    }
}

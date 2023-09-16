//
//  CityListVC.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 11/09/23.
//

import UIKit
import CoreLocation

fileprivate enum ElementOperation {
    case created
    case deleted
    case updated
    case currentLocationCreated
    case none
}

fileprivate enum CoreDataModel {
    case existing
    case notExisting
}

fileprivate enum LocationOperation {
    case once
    case none
}

fileprivate struct TemperatureScaleOptionItem: PopoverOptionItem {
    var text: String
    var isSelected: Bool
    var font = UIFont.systemFont(ofSize: 14, weight: .medium)
}

class CityListVC: UIViewController {

    private let viewModel = CityListVM()
    private let locationManager = CLLocationManager()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.rowHeight = 100
        tableView.backgroundColor = .black
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "CityListVC.SearchBar.Placeholder".localized
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barStyle = .black
        return searchController
    }()
    
    private enum CityListTableViewSection {
        case all
    }

    private typealias CityListDataSourceReturnType = UITableViewDiffableDataSource<CityListTableViewSection, CityTVCModel>
    
    private lazy var cityListDataSource = cityListConfigureDataSource()
    private var elementOperation: ElementOperation = .none
    private var locationOperation: LocationOperation = .none
    private var coreDataModel: CoreDataModel?

    private var celsiusItem: TemperatureScaleOptionItem?
    private var fahrenheitItem: TemperatureScaleOptionItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        setupBinding()
        getCityList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
}

private extension CityListVC {
    func setupUI() {
        setupTableView()
        setupPopoverItems()
    }
    
    func setupNavigationBar() {
        navigationItem.title = "CityListVC.NavigationItem.Title".localized
        navigationController?.navigationBar.prefersLargeTitles = true
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationController?.navigationBar.barTintColor = UIColor.black.withAlphaComponent(0.4)
        navigationController?.navigationBar.tintColor = .white
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(rightBarButtonCTA))
    }
    
    @objc func rightBarButtonCTA() {
        if let celsiusItem = celsiusItem,
           let fahrenheitItem = fahrenheitItem {
            self.presentOptionsPopover(withOptionItems: [[celsiusItem, fahrenheitItem]], fromBarButtonItem: navigationItem.rightBarButtonItem!)
        }
    }
    
    func presentOptionsPopover(withOptionItems items: [[PopoverOptionItem]], fromBarButtonItem barButtonItem: UIBarButtonItem) {
        let optionItemListVC = PopoverOptionItemListVC()
        optionItemListVC.items = items
        optionItemListVC.delegate = self
        
        guard let popoverPresentationController = optionItemListVC.popoverPresentationController else { fatalError("Set Modal presentation style") }
        popoverPresentationController.barButtonItem = barButtonItem
        popoverPresentationController.delegate = self
        self.present(optionItemListVC, animated: true, completion: nil)
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        tableView.delegate = self
        tableView.dataSource = cityListDataSource
        tableView.register(CityTVC.self, forCellReuseIdentifier: ReusableIdentifierTVC.CityTVC.rawValue)
        inspectNilDataNilData(for: self.tableView, with: (self.viewModel.cityList.value ?? []) as Array<AnyObject>)
    }
}

private extension CityListVC {
    
    func setupPopoverItems() {
        if let scale = viewModel.getTemperatureScaleFromUserDefaults() {
            celsiusItem = TemperatureScaleOptionItem(text: "CityVC.Popover.CelsiusItem.Title".localized, isSelected: scale == .celsius)
            fahrenheitItem = TemperatureScaleOptionItem(text: "CityVC.Popover.FahrenheitItem.Title".localized, isSelected: scale == .fahrenheit)
        } else {
            viewModel.setTemperatureScaleInUserDefaults(.celsius)
            celsiusItem = TemperatureScaleOptionItem(text: "CityVC.Popover.CelsiusItem.Title".localized, isSelected: true)
            fahrenheitItem = TemperatureScaleOptionItem(text: "CityVC.Popover.FahrenheitItem.Title".localized, isSelected: false)
        }
    }
    
    func setupBinding() {
        viewModel.cityList.bind { [weak self] (value) in
            guard let self = self else { return }
            if self.coreDataModel == .existing ||
                self.elementOperation == .deleted ||
                (value?.isEmpty == false && (self.elementOperation == .updated || self.elementOperation == .currentLocationCreated)) {
                self.cityListUpdateSnapshot()
            } else {
                DispatchQueue.main.async {
                    self.stopLoaderAnimation()
                    
                    let cityVC = CityVC()
                    cityVC.temperatureScale = self.viewModel.temperatureScale
                    cityVC.cityData = value?.last
                    cityVC.delegate = self
                    if let sheet = cityVC.sheetPresentationController {
                        sheet.detents = [.large()]
                        sheet.largestUndimmedDetentIdentifier = .medium
                        sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                        sheet.prefersEdgeAttachedInCompactHeight = true
                        sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
                    }
                    self.present(cityVC, animated: true)
                }
            }
            self.coreDataModel = .notExisting
            self.elementOperation = .none
        }
        
        viewModel.availableObjCity.bind { [weak self] (value) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.stopLoaderAnimation()
                
                let cityVC = CityVC()
                cityVC.temperatureScale = self.viewModel.temperatureScale
                cityVC.cityData = value
                cityVC.delegate = self
                cityVC.isCityObjectAlreadyAvailableInList = true
                if let sheet = cityVC.sheetPresentationController {
                    sheet.detents = [.large()]
                    sheet.largestUndimmedDetentIdentifier = .medium
                    sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                    sheet.prefersEdgeAttachedInCompactHeight = true
                    sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
                }
                self.present(cityVC, animated: true)
            }
        }
        
        viewModel.alert.bind { [weak self] (titleMessage) in
            guard let self = self else { return }
            self.stopLoaderAnimation()
            if let alertTitleMessage = titleMessage {
                self.showAlert(title: alertTitleMessage.0, message: alertTitleMessage.1)
            }
        }
        
        viewModel.error.bind { [weak self] (_) in
            guard let self = self else { return }
            self.stopLoaderAnimation()
            self.elementOperation = .none
        }
    }
    
    func getWeather(for location: CLLocation) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            self.startLoaderAnimation()
            self.viewModel.fireAPIGETWeather(for: location)
        }
    }
}

extension CityListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let value = viewModel.cityList.value {
            if indexPath.row <= value.count - 1 {
                let cityVC = CityVC()
                cityVC.temperatureScale = viewModel.temperatureScale
                cityVC.cityData = value[indexPath.row]
                self.navigationController?.pushViewController(cityVC, animated: false)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "CityListVC.TableView.DeleteSwipeAction.Title".localized) { [weak self] (action, sourceView, completionHandler) in
            guard let self = self else { return }
            self.elementOperation = .deleted
            self.viewModel.deleteElement(fromCityListAt: indexPath.row)
            completionHandler(true)
        }
        
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = true
        return swipeActionConfig
    }
}

private extension CityListVC {
    private func cityListConfigureDataSource() -> CityListDataSourceReturnType {
        let dataSource = CityListDataSourceReturnType(tableView: tableView) { (tableView, indexPath, model) -> UITableViewCell? in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifierTVC.CityTVC.rawValue, for: indexPath) as? CityTVC else {
                return UITableViewCell()
            }
            cell.setup(for: model)
            return cell
        }
        return dataSource
    }
    
    func cityListUpdateSnapshot(animatingChange: Bool = false) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.inspectNilDataNilData(for: self.tableView, with: (self.viewModel.cityList.value ?? []) as Array<AnyObject>)
            self.searchController.searchBar.text = ""
            var snapshot = NSDiffableDataSourceSnapshot<CityListTableViewSection, CityTVCModel>()
            snapshot.appendSections([.all])
            snapshot.appendItems(self.viewModel.cityList.value ?? [], toSection: .all)
            self.cityListDataSource.apply(snapshot, animatingDifferences: false) {
                self.stopLoaderAnimation()
            }
        }
    }
}

extension CityListVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if (viewModel.cityList.value?.count ?? 0) <= 10 {
            if let text = searchBar.text {
                startLoaderAnimation()
                viewModel.fireAPIGETGeo(from: text)
            }
        } else {
            showAlert(title: "CityListVC.Alert.ListLimit.Title".localized, message: "CityListVC.Alert.ListLimit.Message".localized)
        }
    }
}

extension CityListVC: HandleNilDataDelegate {
    private func inspectNilDataNilData(for tableView: UITableView, with arr: Array<AnyObject>) {
        examineNilData(for: tableView, with: arr)
    }
}

extension CityListVC: LocationDelegate, CLLocationManagerDelegate {

    private func isLocationPermissionEnabled(onCompletion: (Bool) -> Void) {
        hasLocationPermission(onCompletion: onCompletion)
    }

    private func getCityList() {
        
        viewModel.getCDCityListRecords { [weak self] (isDataAvailable) in
            guard let self = self else { return }
            if isDataAvailable == false {
                self.coreDataModel = .notExisting
                self.locationManager.requestWhenInUseAuthorization()
                self.locationManager.delegate = self
                self.requestLocation()
            } else {
                self.coreDataModel = .existing
            }
        }
    }
    
    private func requestLocation() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.isLocationPermissionEnabled { isEnabled in
                if isEnabled {
                    self.locationOperation = .once
                    self.locationManager.startUpdatingLocation()
                } else {
                    self.showAlertWithGoToSettingsAction(title: "CityListVC.Alert.LocationPermission.Title".localized, message: "CityListVC.Alert.LocationPermission.Message".localized)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationOperation = .once
            locationManager.startUpdatingLocation()
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        if locationOperation == .once {
            guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
            self.elementOperation = .currentLocationCreated
            self.getWeather(for: CLLocation(latitude: locValue.latitude, longitude: locValue.longitude))
            self.locationOperation = .none
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //
    }
}

extension CityListVC: DisplayAlertDelegate {
    private func showAlert(title: String, message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.displayAlert(title: title, message: message)
        }
    }
    
    private func showAlertWithGoToSettingsAction(title: String, message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.displayAlertWithGoToSettingsAction(title: title, message: message)
        }
    }
}

extension CityListVC: DisplayLoaderDelegate {
    private func startLoaderAnimation() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.showLoadingView()
        }
    }
    
    private func stopLoaderAnimation() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.hideLoadingView()
        }
    }
}

extension CityListVC: CityDetailTopBarDelegate {
    func onDismissButtonCTA() {
        if let value = viewModel.cityList.value {
            elementOperation = .deleted
            viewModel.deleteElement(fromCityListAt: value.count - 1)
        }
    }
    
    func onAddButtonCTA() {
        elementOperation = .created
        self.cityListUpdateSnapshot()
    }
}

extension CityListVC: UIPopoverPresentationControllerDelegate, PopoverOptionItemListVCDelegate {
    func optionItemListViewController(_ controller: PopoverOptionItemListVC, didSelectOptionItem item: PopoverOptionItem) {
        if let item = item as? TemperatureScaleOptionItem {
            switch item.text {
            case fahrenheitItem?.text:
                if viewModel.temperatureScale == .fahrenheit {
                    return
                } else {
                    viewModel.setTemperatureScaleInUserDefaults(.fahrenheit)
                    setupPopoverItems()
                    elementOperation = .updated
                    viewModel.displayConvertedTemperature(temperatureScale: .fahrenheit)
                }
            case celsiusItem?.text:
                if viewModel.temperatureScale == .celsius {
                    return
                } else {
                    viewModel.setTemperatureScaleInUserDefaults(.celsius)
                    setupPopoverItems()
                    elementOperation = .updated
                    viewModel.displayConvertedTemperature(temperatureScale: .celsius)
                }
            default:
                return
            }
        }
        controller.dismiss(animated: false)
    }

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        //
    }

    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}

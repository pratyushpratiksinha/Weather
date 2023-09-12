//
//  CityListVC.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 11/09/23.
//

import UIKit
import CoreLocation

fileprivate enum ElementOperation {
    case added
    case deleted
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
    
    private var celsiusItem: TemperatureScaleOptionItem?
    private var fahrenheitItem: TemperatureScaleOptionItem?
    private var isTemperatureScaleChanged = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        setupBinding()
        setupPopoverItems()
        cityListUpdateSnapshot()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
}

private extension CityListVC {
    func setupUI() {
        setupTableView()
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
    }
}

private extension CityListVC {
    
    func setupPopoverItems(fahrenheitItem isSelected: Bool = true) {
        celsiusItem = TemperatureScaleOptionItem(text: "Celsius        °C", isSelected: !isSelected)
        fahrenheitItem = TemperatureScaleOptionItem(text: "Fahrenheit  °F", isSelected: isSelected)
    }
    
    func setupBinding() {
        viewModel.cityList.bind { [weak self] (value) in
            guard let self = self else { return }
            if value?.isEmpty == false && self.elementOperation != .deleted && self.isTemperatureScaleChanged == false {
                DispatchQueue.main.async {
                    self.stopLoaderAnimation()
                    
                    let cityVC = CityVC()
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
            } else {
                self.isTemperatureScaleChanged = false
                self.cityListUpdateSnapshot()
            }
            self.elementOperation = .none
        }
        
        viewModel.alert.bind { [weak self] (titleMessage) in
            guard let self = self else { return }
            if let alertTitleMessage = titleMessage {
                self.showAlert(title: alertTitleMessage.0, message: alertTitleMessage.1)
            }
        }
        
        viewModel.error.bind { [weak self] (_) in
            guard let self = self else { return }
            self.stopLoaderAnimation()
        }
    }
    
    func getWeather(location: CLLocation) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            self.startLoaderAnimation()
            self.viewModel.fireAPIGETWeather(for: location)
        }
    }
}

extension CityListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row <= (viewModel.cityList.value?.count ?? 0) - 1 {
            let cityVC = CityVC()
            cityVC.navigationItemTitle = viewModel.cityList.value?[indexPath.row].cityName
            self.navigationController?.pushViewController(cityVC, animated: true)
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
        if let text = searchBar.text {
            startLoaderAnimation()
            viewModel.fireAPIGETGeo(from: text)
        }
    }
}

extension CityListVC: HandleNilDataDelegate {
    private func inspectNilDataNilData(for tableView: UITableView, with arr: Array<AnyObject>) {
        examineNilData(for: tableView, with: arr)
    }
}

//extension CityListVC: LocationDelegate, CLLocationManagerDelegate {
//
//    private func isLocationPermissionEnabled() -> Bool {
//        hasLocationPermission()
//    }
//
//    private func updateFirstItemWRTLocation() {
//        if isLocationPermissionEnabled() {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            locationManager.startUpdatingLocation()
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
//        print("locations = \(locValue.latitude) \(locValue.longitude)")
//    }
//}

extension CityListVC: DisplayAlertDelegate {
    private func showAlert(title: String, message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.displayAlert(title: title, message: message)
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
        elementOperation = .added
        self.cityListUpdateSnapshot()
    }
}

extension CityListVC: UIPopoverPresentationControllerDelegate, PopoverOptionItemListVCDelegate {
    func optionItemListViewController(_ controller: PopoverOptionItemListVC, didSelectOptionItem item: PopoverOptionItem) {
        if let item = item as? TemperatureScaleOptionItem {
            setupPopoverItems(fahrenheitItem: item.text == fahrenheitItem?.text)
            if item.text == fahrenheitItem?.text {
                if viewModel.temperatureScale == .fahrenheit {
                    return
                } else {
                    isTemperatureScaleChanged = true
                    viewModel.displayConvertedTemperature(temperatureScale: .fahrenheit)
                }
            } else {
                if viewModel.temperatureScale == .celsius {
                    return
                } else {
                    isTemperatureScaleChanged = true
                    viewModel.displayConvertedTemperature(temperatureScale: .celsius)
                }
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

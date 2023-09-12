//
//  CityListVC.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 11/09/23.
//

import UIKit
import CoreLocation

class CityListVC: UIViewController {

    private let viewModel = CityListVM()

    let tableView: UITableView = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        setUpBinding()
        getWeather()
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
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
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
        tableView.reloadData()
    }
}

extension CityListVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

private extension CityListVC {
    func setUpBinding() {
        viewModel.cityList.bind { [weak self] (_) in
            guard let self = self else { return }
            self.cityListUpdateSnapshot()
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
    
    func getWeather() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            self.startLoaderAnimation()
            self.viewModel.fireAPIGETWeather(for: CLLocation(latitude: 44.34, longitude: 10.99))
        }
    }
}

extension CityListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\n\nindexPath.row", indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "CityListVC.TableView.DeleteSwipeAction.Title".localized) { [weak self] (action, sourceView, completionHandler) in
            guard let self = self else { return }
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
    
    private func cityListUpdateSnapshot(animatingChange: Bool = false) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
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

extension CityListVC: AlertDisplaying {
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.stopLoaderAnimation()
            self.displayAlert(title: title, message: message)
        }
    }
}


extension CityListVC: LoaderDisplaying {
    func startLoaderAnimation() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.showLoadingView()
        }
    }
    
    func stopLoaderAnimation() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.hideLoadingView()
        }
    }
}

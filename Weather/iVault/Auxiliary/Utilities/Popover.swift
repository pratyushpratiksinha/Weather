//
//  Popover.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 12/09/23.
//

import UIKit

protocol PopoverOptionItem {
    var text: String { get }
    var isSelected: Bool { get set }
    var font: UIFont { get set }
}

extension PopoverOptionItem {
    func sizeForDisplayText() -> CGSize {
        return text.size(withAttributes: [NSAttributedString.Key.font: font])
    }
}

protocol PopoverOptionItemListVCDelegate: AnyObject {
    func optionItemListViewController(_ controller: PopoverOptionItemListVC, didSelectOptionItem item: PopoverOptionItem)
}

class PopoverOptionItemListVC: UIViewController {
    var items = [[PopoverOptionItem]]() {
        didSet {
            calculateAndSetPreferredContentSize()
        }
    }
    private(set) var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    weak var delegate: PopoverOptionItemListVCDelegate?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalPresentationStyle = .popover
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupView()
        setupTableView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
    }

    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    func calculateAndSetPreferredContentSize() {
        let approxAccessoryViewWidth: CGFloat = 56
        let maxWidth = items.flatMap{ $0 }.reduce(0) { $1.sizeForDisplayText().width + approxAccessoryViewWidth > $0 ? $1.sizeForDisplayText().width + 56 : $0 }
        let totalItems = CGFloat(items.flatMap{ $0 }.count)
        let totalHeight = totalItems * 44
        preferredContentSize = CGSize(width: maxWidth + 20, height: totalHeight)
    }
}

extension PopoverOptionItemListVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let item = items[indexPath.section][indexPath.row]
        cell.configure(with:item)
        return cell
    }
}

extension PopoverOptionItemListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.section][indexPath.row]
        delegate?.optionItemListViewController(self, didSelectOptionItem: item)
    }
}

extension UITableViewCell {
    func configure(with optionItem: PopoverOptionItem) {
        textLabel?.text = optionItem.text
        textLabel?.font = optionItem.font
        accessoryType = optionItem.isSelected ? .checkmark : .none
        selectionStyle = .none
        tintColor = .black
    }
}

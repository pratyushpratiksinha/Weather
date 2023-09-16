//
//  NilDataHandler.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 12/09/23.
//

import UIKit

//MARK: - HandleNilDataDelegate
protocol HandleNilDataDelegate {
    func examineNilData(for tableView: UITableView, with arr: Array<AnyObject>)
}

extension HandleNilDataDelegate where Self: UIViewController {
    func examineNilData(for tableView: UITableView, with arr: Array<AnyObject>) {
        switch arr.isEmpty == false {
        case true:
            tableView.backgroundView = nil
        default:
            if tableView.backgroundView == nil {
                let noDataView: UILabel = UILabel(frame: CGRect(x:0,y: 0,width: tableView.bounds.size.width,height: tableView.bounds.size.height))
                noDataView.text = "NilDataView.Label.Text".localized
                noDataView.textColor = .white
                noDataView.contentMode = .center
                noDataView.textAlignment = .center
                noDataView.font = UIFont.systemFont(ofSize: 18.0, weight: .heavy)
                noDataView.isUserInteractionEnabled = true
                noDataView.isHidden = false
                noDataView.alpha = 0.0
                tableView.backgroundView = noDataView
                UIView.animate(withDuration: 2.0, delay: 0, options: .curveEaseInOut, animations: {
                    noDataView.alpha = 1.0
                }, completion: { _ in })
            }
        }
    }
}

//
//  Alert.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 12/09/23.
//

import UIKit

typealias AlertAction = (UIAlertAction) -> Void

protocol DisplayAlertDelegate {
    func displayAlert(title: String, message: String)
    func displayAlertWithAction(title: String?, message: String?, action: AlertAction?)
}

extension DisplayAlertDelegate where Self: UIViewController {
    
    func displayAlert(title: String, message: String) {
        displayAlert(title: title,
                     message: message,
                     actions: [UIAlertAction(title: "Alert.Ok.title".localized, style: .cancel, handler: nil)])
    }
    
    func displayAlertWithAction(title: String?, message: String?, action: AlertAction?) {
        displayAlert(title: title,
                     message: message,
                     actions: [UIAlertAction(title: "Alert.Ok.title".localized, style: .default, handler: action),
                               UIAlertAction(title: "Alert.Cancel.title".localized, style: .cancel, handler: nil)])
    }
    
    private func displayAlert(title: String? = "", message: String? = "", actions: [UIAlertAction] = []) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        actions.forEach { (action) in
            alertController.addAction(action)
        }
        present(alertController, animated: true, completion: nil)
    }
}

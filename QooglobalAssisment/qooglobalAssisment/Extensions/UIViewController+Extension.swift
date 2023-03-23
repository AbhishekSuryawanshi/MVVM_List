//
//  UIViewController+Extension.swift
//  qooglobalAssisment
//
//  Created by Abhishek Suryawanshi on 21/03/23.
//

import Foundation
import UIKit

extension UIViewController {
    public func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        self.present(alert, animated: true)
    }
}

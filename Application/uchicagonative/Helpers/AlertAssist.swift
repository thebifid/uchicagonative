//
//  AlertAssist.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 27.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import UIKit

class AlertAssist {
    private init() {}

    enum AlertType {
        case success(String, ((UIAlertAction) -> Void)?), failure(Error)
    }

    static let sharedInstance = AlertAssist()

    func showErrorAlert(type: AlertType) -> UIAlertController {
        switch type {
        case let .success(message, handler):
            let ac = UIAlertController(title: "Success!", message: message, preferredStyle: .alert)
            let alertOkAction = UIAlertAction(title: "OK", style: .cancel, handler: handler)
            ac.addAction(alertOkAction)
            return ac
        case let .failure(error):
            let ac = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
            let alertOkAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            ac.addAction(alertOkAction)
            return ac
        }
    }
}

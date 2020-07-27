//
//  AlertAssist.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 27.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import UIKit

class AlertAssist {
    static func showSuccessAlert(withMessage message: String, handler: ((UIAlertAction) -> Void)?) -> UIAlertController {
        let ac = UIAlertController(title: "Success!", message: message, preferredStyle: .alert)
        let alertOkAction = UIAlertAction(title: "OK", style: .cancel, handler: handler)
        ac.addAction(alertOkAction)
        return ac
    }

    static func showErrorAlert(_ error: Error) -> UIAlertController {
        let ac = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
        let alertOkAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        ac.addAction(alertOkAction)
        return ac
    }
}

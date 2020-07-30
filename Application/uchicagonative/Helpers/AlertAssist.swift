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

    static func showErrorAlertWithCancelAndOption(_ error: Error, optionName: String,
                                                  optionHadler: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        let ac = UIAlertController(title: "Error!", message: error.localizedDescription, preferredStyle: .alert)
        let alertCancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        ac.addAction(alertCancelAction)

        let optionAction = UIAlertAction(title: optionName, style: .default, handler: optionHadler)
        ac.addAction(optionAction)

        return ac
    }

    static func showCustomAlert(_ title: String, message: String,
                                optionHadler: ((UIAlertAction) -> Void)?) -> UIAlertController {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertCancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: optionHadler)
        ac.addAction(alertCancelAction)

        return ac
    }
}

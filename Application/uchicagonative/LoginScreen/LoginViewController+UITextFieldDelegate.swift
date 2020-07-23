//
//  LoginViewController+UITextFieldDelegate.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 23.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import UIKit

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextiField:
            passwordTextiField.becomeFirstResponder()
        case passwordTextiField:
            break
        default:
            break
        }
        return false
    }
}

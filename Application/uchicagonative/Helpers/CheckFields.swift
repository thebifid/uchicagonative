//
//  CheckFields.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 29.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Foundation

class CheckFields {
    /// check if email correct
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email) ? true : false
    }

    /// check if password is not empty
    static func isValidPassword(_ password: String) -> Bool {
        return !password.isEmpty
    }
}

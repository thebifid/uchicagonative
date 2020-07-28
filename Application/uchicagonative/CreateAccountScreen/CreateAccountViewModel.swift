//
//  CreateAccountViewModel.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 27.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import UIKit

class CreateAccountViewModel {
    var email: String?
    var password: String?
    var selectedGroup: String?

    var availableGroups: [String]?

    var didFetchedGroups: (() -> Void)?

    var didUpdateState: (() -> Void)?

    var signUpButtonState: Bool {
        return isPasswordNotEmptyCheck() && isValidEmailCheck() && isSelectedGroupNotNil()
    }

    init() {
        FireBaseManager.sharedInstance.fetchAvailableGroups { [weak self] result in

            switch result {
            case let .failure(error):
                print(error)
            case let .success(groups):
                self?.availableGroups = groups
                self?.didFetchedGroups?()
                print("groups fetched")
            }
        }
    }

    func setEmail(_ email: String) {
        self.email = email
        print("email")
        didUpdateState?()
    }

    func setPassword(_ password: String) {
        print("password")
        self.password = password
        didUpdateState?()
    }

    func didChangeGroup(group: String) {
        selectedGroup = group
        didUpdateState?()
    }

    /// Return true if user password and email are correct form
    func isLoginButtonEnabled() -> Bool {
        return isPasswordNotEmptyCheck() && isValidEmailCheck()
    }

    /// check if email correct
    private func isValidEmailCheck() -> Bool {
        guard let email = email else { return false }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email) ? true : false
    }

    /// check if password is not empty
    private func isPasswordNotEmptyCheck() -> Bool {
        guard let password = password else { return false }
        return !password.isEmpty ? true : false
    }

    private func isSelectedGroupNotNil() -> Bool {
        guard let selectedGroup = selectedGroup else { return false }
        if selectedGroup != "Select an item..." {
            return true
        }
        return false
    }
}

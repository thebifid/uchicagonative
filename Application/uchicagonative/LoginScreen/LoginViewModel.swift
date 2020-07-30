//
//  LoginViewModel.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 24.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import FirebaseAuth
import UIKit
/// View Model for LoginView Controller
class LoginViewModel {
    // MARK: - Private Properties

    private var email: String?
    private var password: String?

    private var isLoggingIn: Bool = false {
        didSet {
            didUpdateState?()
        }
    }

    // MARK: - Public Properties

    var loginButtonState: LoginButtonState {
        if isLoggingIn {
            return .animating
        } else {
            return .enabled(isPasswordNotEmptyCheck() && isValidEmailCheck())
        }
    }

    // MARK: - Handlers

    /// Handler for update login state
    var didUpdateState: (() -> Void)?

    // MARK: - Enums

    enum LoginButtonState {
        case enabled(Bool), animating
    }

    // MARK: - Public Methods

    /// Set User email for login
    func setEmail(_ email: String) {
        self.email = email
        didUpdateState?()
    }

    /// Set User password for login
    func setPassword(_ password: String) {
        self.password = password
        didUpdateState?()
    }

    /// Return true if user password and email are correct form
    func isLoginButtonEnabled() -> Bool {
        return isPasswordNotEmptyCheck() && isValidEmailCheck()
    }

    /// FireBase authorization
    func login(completion: @escaping (Result<Bool, Error>) -> Void) {
        // get text data from emailTF and passwordTF and clearing from any spaces or new lines
        guard let email = email?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let password = password?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        isLoggingIn = true
        // LogIn FireBase
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in

            // Logged
            if error == nil {
                FirebaseManager.sharedInstance.isUserDataExitsts { [weak self] result in
                    switch result {
                    case let .success(state):
                        // userData is not exists
                        if !state {
                            completion(.success(false))
                        } else {
                            // userData exists
                            if error == nil {
                                completion(.success(true))
                            } else {
                                self?.didUpdateState?()
                                completion(.failure(error!))
                            }
                        }
                    case let .failure(error):
                        completion(.failure(error))
                    }
                    self?.isLoggingIn = false
                }
            }

            // Failed to log in
            else {
                completion(.failure(error!))
            }
        }
    }

    // MARK: - Private Methods

    /// check if email correct
    private func isValidEmailCheck() -> Bool {
        guard let email = email else { return false }
        return CheckFields.isValidEmail(email)
    }

    /// check if password is not empty
    private func isPasswordNotEmptyCheck() -> Bool {
        guard let password = password else { return false }
        return CheckFields.isValidPassword(password)
    }
}

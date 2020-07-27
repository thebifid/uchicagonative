//
//  LoginViewModel.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 24.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import FirebaseAuth
import UIKit
/// This is a View Model for LoginView Controller
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
    func login(completion: @escaping (Result<Void, Error>) -> Void) {
        // get text data from emailTF and passwordTF and clearing from any spaces or new lines
        guard let email = email?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let password = password?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        isLoggingIn = true
        // LogIn FireBase
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
            if error == nil {
                self?.didUpdateState?()
                completion(.success(()))
            } else {
                self?.didUpdateState?()
                completion(.failure(error!))
            }
            self?.isLoggingIn = false
        }
    }

    // MARK: - Private Methods

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
}

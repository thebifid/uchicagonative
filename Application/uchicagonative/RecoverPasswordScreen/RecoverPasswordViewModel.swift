//
//  RecoverPasswordViewModel.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 27.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import FirebaseAuth
import UIKit

class RecoverPasswordViewModel {
    // MARK: - Private Properties

    private var email: String?

    private var isRequesting: Bool = false {
        didSet {
            didUpdateState?()
        }
    }

    // MARK: - Handlers

    /// Handler for update request password button state
    var didUpdateState: (() -> Void)?

    // MARK: - Public Properties

    /// Disabled request password button if email is not valid. Enabled button if email is valid.
    /// Starts animating if button is valid and pressed.
    var requestNewPasswordButtonState: RequestNewPasswordButtonState {
        if isRequesting {
            return .animating
        } else {
            return .enabled(isValidEmailCheck())
        }
    }

    // MARK: - Public Methods

    /// Set self email
    func setEmail(_ email: String) {
        self.email = email
        didUpdateState?()
    }

    /// Send reset password request to FireBase
    func resetPassword(completion: @escaping (Result<Void, Error>) -> Void) {
        isRequesting = true
        guard let email = email?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }

        FirebaseAuth.Auth.auth().sendPasswordReset(withEmail: email) { error in
            if error == nil {
                self.didUpdateState?()
                completion(.success(()))
            } else {
                self.didUpdateState?()
                completion(.failure(error!))
            }
            self.isRequesting = false
        }
    }

    // MARK: - Enums

    enum RequestNewPasswordButtonState {
        case enabled(Bool), animating
    }

    // MARK: - Private Methods

    /// Check if email correct
    private func isValidEmailCheck() -> Bool {
        guard let email = email else { return false }
        return CheckFields.isValidEmailCheck(email)
    }
}

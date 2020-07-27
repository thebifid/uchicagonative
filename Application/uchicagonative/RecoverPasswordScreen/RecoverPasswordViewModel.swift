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

    var didUpdateState: (() -> Void)?

    // MARK: - Public Properties

    var requestNewPasswordButtonState: RequestNewPasswordButtonState {
        if isRequesting {
            return .animating
        } else {
            return .enabled(isValidEmailCheck())
        }
    }

    // MARK: - Public Methods

    func setEmail(_ email: String) {
        self.email = email
        didUpdateState?()
    }

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

    /// check if email correct
    private func isValidEmailCheck() -> Bool {
        guard let email = email else { return false }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email) ? true : false
    }
}

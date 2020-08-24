//
//  CreateAccountViewModel.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 27.07.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import FirebaseAuth
import FirebaseFirestore
import UIKit

class CreateAccountViewModel {
    // MARK: - Init

    // MARK: - Private Properties

    private(set) var email: String?
    private var password: String?
    private(set) var selectedGroup: String?
    private var groupNameIdDictionary = [String: String]()
    private var userInfo = [String: Any]()

    // MARK: - Public Properties

    /// Available groups for popUpMenu
    var availableGroups: [String] {
        return Array(groupNameIdDictionary.keys)
    }

    /// SignUp button state
    var signUpButtonState: SignUpButtonState {
        if isRequesting {
            return .animating
        } else {
            return .enabled(isPasswordNotEmpty() && isValidEmail() && isSelectedGroupNotNil())
        }
    }

    // MARK: - Handlers

    /// Works when fetch group request is completed
    var didFetchedGroups: (() -> Void)?

    /// Hanlder for update button state (SignUp button)
    var didUpdateState: (() -> Void)?

    // MARK: - Enums

    enum SignUpButtonState {
        case enabled(Bool), animating
    }

    // MARK: - Public Methods

    /// Set model email
    func setEmail(_ email: String) {
        self.email = email
        didUpdateState?()
    }

    /// Set model password
    func setPassword(_ password: String) {
        self.password = password
        didUpdateState?()
    }

    /// Set self selected group from dporDown menu and update state
    func didChangeGroup(group: String) {
        selectedGroup = group
        didUpdateState?()
    }

    func addUserData(completion: @escaping ((Result<Void, Error>) -> Void)) {
        setUserInfo()
        FirebaseManager.sharedInstance.addDocumentToUserProfiles(attributes: userInfo) { [weak self] result in
            self?.isRequesting = false
            switch result {
            case let .failure(error):
                self?.didUpdateState?()
                completion(.failure(error))
            case .success:
                self?.didUpdateState?()
                completion(.success(()))
            }
        }
    }

    func fetchAvailableGroups(completion: @escaping ((Result<Void, Error>) -> Void)) {
        FirebaseManager.sharedInstance.fetchAvailableGroups { [weak self] result in
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(groups):
                self?.groupNameIdDictionary = groups
                self?.didFetchedGroups?()
                completion(.success(()))
            }
        }
    }

    /// Create new account is Firebase
    func createNewAccount(completion: @escaping (Result<String, Error>) -> Void) {
        // get text data from emailTF and passwordTF and clearing from any spaces or new lines
        guard let email = email?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let password = password?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        // LogIn FireBase
        isRequesting = true
        Auth.auth().signIn(withEmail: email, password: password) { result, error in

            if error == nil {
                // Logged
                FirebaseManager.sharedInstance.isUserDataExitsts { resultCheck in
                    switch resultCheck {
                    case let .success(status):
                        // document isn't exist
                        if !status {
                            self.addUserData { result in
                                switch result {
                                case .success:
                                    completion(.success("Data successfully added."))

                                case let .failure(error):
                                    do {
                                        try FirebaseAuth.Auth.auth().signOut()
                                    } catch let logOutError {
                                        completion(.failure(logOutError))
                                    }
                                    completion(.failure(error))
                                }
                            }
                        }
                        // document exists
                        else {
                            completion(.success("Account already exists. You will be redirected to the main menu."))
                        }

                    case let .failure(error):
                        completion(.failure(error))
                    }
                }

            } else {
                self.createNewUser(completion: { result in
                    // user created
                    switch result {
                    case .success:
                        // add user data
                        self.addUserData(completion: { result in
                            switch result {
                            case .success:
                                completion(.success("Account Created!"))
                            case let .failure(error):
                                completion(.failure(error))
                            }
                        })
                    // user is not created
                    case let .failure(error):
                        completion(.failure(error))
                    }
                })
            }
        }
    }

    /// Return true if user password and email are correct form
    func isLoginButtonEnabled() -> Bool {
        return isPasswordNotEmpty() && isValidEmail()
    }

    // MARK: - Private Methods

    private func createNewUser(completion: @escaping (Result<Void, Error>) -> Void) {
        // get text data from emailTF and passwordTF and clearing from any spaces or new lines
        guard let email = email?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let password = password?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        isRequesting = true

        // LogIn FireBase
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak self] _, error in
            if error == nil {
                completion(.success(()))
            } else {
                completion(.failure(error!))
                self?.isRequesting = false
            }
        }
    }

    private func setUserInfo() {
        guard let selectedGroup = self.selectedGroup else { return }
        userInfo = [
            "email": email!,
            "projectId": groupNameIdDictionary[selectedGroup]!,
            "role": "subject",
            "createdAt": FieldValue.serverTimestamp(),
            "updatedAt": FieldValue.serverTimestamp()
        ]
    }

    private var isRequesting: Bool = false {
        didSet {
            didUpdateState?()
        }
    }

    /// check if email correct
    private func isValidEmail() -> Bool {
        guard let email = email else { return false }
        return CheckFields.isValidEmail(email)
    }

    /// check if password is not empty
    private func isPasswordNotEmpty() -> Bool {
        guard let password = password else { return false }
        return CheckFields.isValidPassword(password)
    }

    private func isSelectedGroupNotNil() -> Bool {
        guard let selectedGroup = selectedGroup else { return false }
        if selectedGroup != "Select an item..." {
            return true
        }
        return false
    }
}

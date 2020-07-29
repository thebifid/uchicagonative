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

    init() {
        FireBaseManager.sharedInstance.fetchAvailableGroups { [weak self] result in
            switch result {
            case let .failure(error):
                print(error)
            case let .success(groups):
                self?.availableGroups = Array(groups.keys)
                self?.groupNameIdDictionary = groups
                self?.didFetchedGroups?()
            }
        }
    }

    // MARK: - Private Properties

    private var email: String?
    private var password: String?
    private var selectedGroup: String?
    private var groupNameIdDictionary = [String: String]()

    // MARK: - Public Properties

    /// Available groups for popUpMenu
    var availableGroups = [String]()

    /// This Property for signUp button (if requesting = animate), disabled / enabled if fields are filled
    var signUpButtonState: SignUpButtonState {
        if isRequesting {
            return .animating
        } else {
            return .enabled(isPasswordNotEmptyCheck() && isValidEmailCheck() && isSelectedGroupNotNil())
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

    /// Create new user in FireBase
    func createNewUser(completion: @escaping (Result<Void, Error>) -> Void) {
        // get text data from emailTF and passwordTF and clearing from any spaces or new lines
        guard let email = email?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        guard let password = password?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
        isRequesting = true
        // LogIn FireBase
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if error == nil {
                guard let selectedGroup = self?.selectedGroup else { return }

                let userInfo: [String: Any] = [
                    "email": email,
                    "projectId": self?.groupNameIdDictionary[selectedGroup] ?? "",
                    "role": "subject",
                    "createdAt": FieldValue.serverTimestamp(),
                    "updatedAt": FieldValue.serverTimestamp()
                ]

                FireBaseManager.sharedInstance.addDocumentToUserProfiles(documentName: (result?.user.uid)!,
                                                                         attributes: userInfo) { result in
                    switch result {
                    case let .failure(error):
                        print(error.localizedDescription)
                    case .success:
                        break
                    }
                }

                self?.didUpdateState?()
                completion(.success(()))
            } else {
                self?.didUpdateState?()
                completion(.failure(error!))
            }
            self?.isRequesting = false
        }
    }

    /// Return true if user password and email are correct form
    func isLoginButtonEnabled() -> Bool {
        return isPasswordNotEmptyCheck() && isValidEmailCheck()
    }

    // MARK: - Private Methods

    private var isRequesting: Bool = false {
        didSet {
            didUpdateState?()
        }
    }

    /// check if email correct
    private func isValidEmailCheck() -> Bool {
        guard let email = email else { return false }
        return CheckFields.isValidEmailCheck(email)
    }

    /// check if password is not empty
    private func isPasswordNotEmptyCheck() -> Bool {
        guard let password = password else { return false }
        return CheckFields.isPasswordNotEmptyCheck(password)
    }

    private func isSelectedGroupNotNil() -> Bool {
        guard let selectedGroup = selectedGroup else { return false }
        if selectedGroup != "Select an item..." {
            return true
        }
        return false
    }
}

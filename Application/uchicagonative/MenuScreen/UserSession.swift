//
//  UserSession.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 05.08.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Firebase
import Foundation

/// Provide information about user
class UserSession {
    // MARK: - Init

    init(user: User) {
        self.user = user
        addUserInfoChangeListener { user in
            self.user = user
            self.didUpdateUser?()
        }
    }

    // MARK: - Private properties

    private(set) var user: User
    private var listener: ListenerRegistration?

    // MARK: - Public Methods

    func setNewUserInfo(newUserInfo info: User) {
        user = info
    }

    // MARK: - Handlers

    var didUpdateUser: (() -> Void)?

    // MARK: - Private Methods

    private func addUserInfoChangeListener(completion: @escaping ((User) -> Void)) {
        listener = FirebaseManager.sharedInstance.addUserInfoChangeListener { user in
            completion(user)
        }
    }

    // MARK: - Deinit

    deinit {
        listener?.remove()
    }
}

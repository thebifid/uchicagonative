//
//  UserSession.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 05.08.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Foundation

/// Provide information about user
class UserSession {
    // MARK: - Init

    init(user: User) {
        self.user = user
        addUserInfoChangeListener { user in
            self.user = user
        }
    }

    // MARK: - Private properties

    private(set) var user: User
    private(set) var sessionConfiguration = SessionConfiguration()

    // MARK: - Public Methods

    func setNewUserInfo(newUserInfo info: User) {
        user = info
    }

    func setSessionConfiguration(newSession session: SessionConfiguration) {
        sessionConfiguration = session
    }

    // MARK: - Private Methods

    private func addUserInfoChangeListener(completion: @escaping ((User) -> Void)) {
        FirebaseManager.sharedInstance.addUserInfoChangeListener { user in
            completion(user)
        }
    }
}

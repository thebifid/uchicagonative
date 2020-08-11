//
//  MenuScreenViewModel.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 05.08.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Foundation

class MenuScreenViewModel {
    // MARK: - Init

    init(userSession: UserSession) {
        self.userSession = userSession
    }

    // MARK: - Private Properties

    private(set) var userSession: UserSession

    // MARK: - Public Methods

    /// Add listener for user info
    func addUserChangeListener() {
        FirebaseManager.sharedInstance.addUserInfoChangeListener { user in
            self.userSession = UserSession(user: user)
        }
    }
}

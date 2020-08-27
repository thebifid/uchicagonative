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
    private(set) var sessionConfiguration = SessionConfiguration()

    // MARK: - Public Properties

    var isUserDataFilled: Bool {
        return isAllUserDataFilled()
    }

    // MARK: - Private Methods

    private func isAllUserDataFilled() -> Bool {
        let user = userSession.user

        return !user.firstName.isEmpty &&
            !user.lastName.isEmpty &&
            user.birthYear != 0 &&
            user.zipCode != 0 &&
            !user.gender.isEmpty
    }
}

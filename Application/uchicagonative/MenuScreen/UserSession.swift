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
    }
    
    // MARK: - Private properties
    private(set) var user: User

    // MARK: - Public Methods
    func setNewUserInfo(newUserInfo info: User) {
        user = info
    }

    
}

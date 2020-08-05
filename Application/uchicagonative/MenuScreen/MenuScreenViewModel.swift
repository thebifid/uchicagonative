//
//  MenuScreenViewModel.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 05.08.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Foundation

class MenuScreenViewModel {
    private(set) var userSession: UserSession

    init(userSession: UserSession) {
        self.userSession = userSession
    }
}

//
//  GetHelpViewModel.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 04.08.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Foundation

class GetHelpViewModel {
    init(userSession: UserSession) {
        self.userSession = userSession
    }

    let userSession: UserSession

    // MARK: - Private Properties

    // MARK: Public Protperties

    /// Email address and subject to report
    let emailRecipient: String = "lazareva@saritasa.com"
    let emailSubject: String = "MMA Support Request"

    let websiteUrl: URL = URL(string: "https://awhvogellab.com")!

    var isEmailFetched: Bool {
        return !userSession.user.email.isEmpty
    }

    // MARK: - Public Methods
}

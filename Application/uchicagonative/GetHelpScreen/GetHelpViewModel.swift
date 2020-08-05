//
//  GetHelpViewModel.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 04.08.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Foundation

class GetHelpViewModel {
    // MARK: - Private Properties

    private(set) var userEmail: String = ""

    // MARK: Public Protperties

    /// Email address and subject to report
    let emailRecipient: String = "lazareva@saritasa.com"
    let emailSubject: String = "MMA Support Request"

    let websiteUrlString: String = "https://awhvogellab.com"

    var isEmailFetched: Bool {
        return !userEmail.isEmpty
    }

    // MARK: - Public Methods

    /// Fetches current user email address
    func fetchUserEmail(completion: @escaping ((Result<Void, Error>) -> Void)) {
        FirebaseManager.sharedInstance.fetchUserInfo { [weak self] result in

            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(userInfo):
                self?.userEmail = userInfo["email"] as? String ?? ""
            }
        }
    }
}

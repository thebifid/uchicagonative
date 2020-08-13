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
    private(set) var sessionConfiguration: SessionConfiguration?

    // MARK: - Handlers

    var didFechSessionConfiguration: (() -> Void)?

    // MARK: - Public Methods

    func fetchSessionConfigurations(completion: @escaping ((Result<Void, Error>) -> Void)) {
        FirebaseManager.sharedInstance.fetchSessionConfigurations(withSessionId: userSession.user.projectId) { [weak self] result in
            switch result {
            case let .failure(error):
                completion(.failure(error))

            case let .success(sessionConfiguration):
                guard let self = self else { return }

                self.sessionConfiguration = sessionConfiguration
                self.didFechSessionConfiguration?()
                completion(.success(()))
            }
        }
    }
}

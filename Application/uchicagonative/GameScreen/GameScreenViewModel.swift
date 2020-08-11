//
//  GameScreenViewModel.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 07.08.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Foundation
import UIKit

class GameScreenViewModel {
    // MARK: - Init

    init(userSession: UserSession) {
        self.userSession = userSession
    }

    // MARK: - Private Properties

    private(set) var backgroundColor: String = ""
    private(set) var colors = [String]()
    private(set) var iconName: String = ""
    private(set) var setSize: CGFloat = 0

    private let userSession: UserSession
    private let sessionConfigurations = [String: Any]()

    /// Map icon name from server to icon name in app
    private let iconDictionary = [
        "the-punisher-seeklogo.com": "punisher",
        "github-logo": "githublogo",
        "square": "square",
        "wrestling": "wrestling",
        "diaspora": "diaspora"
    ]

    // MARK: - Public Methods

    func fetchSessionConfigurations(completion: @escaping ((Result<Void, Error>) -> Void)) {
        FirebaseManager.sharedInstance.fetchSessionConfigurations(withSessionId: userSession.user.projectId) { [weak self] result in

            switch result {
            case let .failure(error):
                completion(.failure(error))

            case let .success(sessionConfigurations):
                guard let self = self else { return }

                self.userSession.setSessionConfiguration(newSession: sessionConfigurations)

                self.backgroundColor = self.userSession.sessionConfiguration.backgroundColor
                self.colors = self.userSession.sessionConfiguration.colors
                let iconName = self.userSession.sessionConfiguration.iconName
                self.iconName = self.iconDictionary[iconName] ?? ""
                self.setSize = self.userSession.sessionConfiguration.setSize
                completion(.success(()))
            }
        }
    }
}

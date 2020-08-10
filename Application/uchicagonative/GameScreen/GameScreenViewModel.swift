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

    // MARK: - Public Methods

    func fetchSessionConfigurations(completion: @escaping ((Result<Void, Error>) -> Void)) {
        FirebaseManager.sharedInstance.fetchSessionConfigurations(withSessionId: userSession.user.projectId) { [weak self] result in

            switch result {
            case let .failure(error):
                completion(.failure(error))

            case let .success(sessionConfigurations):
                self?.backgroundColor = sessionConfigurations["backgroundColor"] as? String ?? ""
                self?.colors = sessionConfigurations["colors"] as? [String] ?? []
                self?.iconName = sessionConfigurations["iconName"] as? String ?? ""
                self?.setSize = sessionConfigurations["setSize"] as? CGFloat ?? 0
                completion(.success(()))
            }
        }
    }
}

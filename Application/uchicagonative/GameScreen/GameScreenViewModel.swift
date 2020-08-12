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

    // size of cells
    private(set) var stimuliSize: CGFloat = 0

    // number of cells
    private(set) var setSize: Int = 0

    private let userSession: UserSession
    private let sessionConfigurations = [String: Any]()

    private(set) var locations = [[Int]]()

    /// Map icon name from server to icon name in app
    private let iconDictionary = [
        "the-punisher-seeklogo.com": "punisher",
        "github-logo": "githublogo",
        "square": "square",
        "wrestling": "wrestling",
        "diaspora": "diaspora"
    ]

    // MARK: - Handlers

    var didUpdateLocation: (() -> Void)?
    var didFetchSession: (() -> Void)?

    // MARK: - Public Methods

    func fetchSessionConfigurations(completion: @escaping ((Result<Void, Error>) -> Void)) {
        FirebaseManager.sharedInstance.fetchSessionConfigurations(withSessionId: userSession.user.projectId) { [weak self] result in

            switch result {
            case let .failure(error):
                completion(.failure(error))

            case let .success(sessionConfigurations):
                guard let self = self else { return }

                self.backgroundColor = sessionConfigurations.backgroundColor
                self.colors = sessionConfigurations.colors
                let iconName = sessionConfigurations.iconName
                self.iconName = self.iconDictionary[iconName] ?? ""
                self.setSize = sessionConfigurations.setSize
                self.stimuliSize = sessionConfigurations.stimuliSize
                self.didFetchSession?()
                completion(.success(()))
            }
        }
    }

    func generateNewCellsLocation(forView view: UIView, count: Int) {
        locations.removeAll()
        didUpdateLocation?()
        generateCellsLocation(forView: view, count: count)
    }

    // MARK: - Private Methods

    private func generateCellsLocation(forView view: UIView, count: Int) {
        for _ in 0 ..< count {
            let xCoordinate = Int.random(in: 0 ..< Int(view.frame.width - stimuliSize))
            let yCoordinate = Int.random(in: 0 ..< Int(view.frame.height - stimuliSize - 100))
            let newLocation = [xCoordinate, yCoordinate]

            if isFreeZone(locations: locations, newLocation: newLocation, iconSize: Int(stimuliSize)) {
                locations.append(newLocation)
            } else {
                generateCellsLocation(forView: view, count: 1)
            }
        }
    }

    private func isFreeZone(locations: [[Int]], newLocation: [Int], iconSize: Int) -> Bool {
        if locations.isEmpty {
            return true
        }

        for location in locations {
            let xStart = location[0] - iconSize
            let xEnd = location[0] + iconSize

            let yStart = location[1] - iconSize
            let yEnd = location[1] + iconSize

            if xStart ..< xEnd ~= newLocation[0], yStart ..< yEnd ~= newLocation[1] {
                return false
            }
        }
        return true
    }
}

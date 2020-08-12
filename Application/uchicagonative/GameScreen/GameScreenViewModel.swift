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

    private(set) var roundLocations = [[Int]]()
    private var roundColors = [String]()

    /// Struct for saving game session result
    private var gameResult = GameResult()

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

    /// Write round info in GameResult struct
    func setRoundInfo() {
        gameResult.setGameRoundLocationsInfo(locationInfo: roundLocations)
        gameResult.setGameRoundColorsInfo(colorsInfo: roundColors)

        roundLocations.removeAll()
        roundColors.removeAll()
    }

    func setRoundColors(color: String) {
        roundColors.append(color)
    }

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

    func generateNewCellLocations(forView view: UIView) {
        roundLocations.removeAll()
        didUpdateLocation?()
        generateCellLocations(forView: view)
    }

    // MARK: - Private Methods

    private func generateCellLocations(forView view: UIView, recursively: Bool = false) {
        let count = !recursively ? setSize : 1
        for _ in 0 ..< count {
            let xCoordinate = Int.random(in: 0 ..< Int(view.frame.width - stimuliSize))
            let yCoordinate = Int.random(in: 0 ..< Int(view.frame.height - stimuliSize - 100))
            let newLocation = [xCoordinate, yCoordinate]

            if isFreeZone(locations: roundLocations, newLocation: newLocation, iconSize: Int(stimuliSize)) {
                roundLocations.append(newLocation)
            } else {
                generateCellLocations(forView: view, recursively: true)
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

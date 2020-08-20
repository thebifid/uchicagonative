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
    /// Represents position, size and color of a cell.
    struct Cell {
        let frame: CGRect
        let color: String

        var location: [Int] {
            return [Int(frame.origin.x), Int(frame.origin.y)]
        }
    }

    // MARK: - Init

    init(userSession: UserSession, sessionConfiguration: SessionConfiguration) {
        self.userSession = userSession
        self.sessionConfiguration = sessionConfiguration
    }

    // MARK: - Private Properties

    private let userSession: UserSession
    private var sessionConfiguration: SessionConfiguration
    private(set) var cells = [Cell]()
    private(set) var testCell = Cell(frame: .zero, color: "#fffff")

    private var currentRound = 0

    private var changeProbabilityArray = [Int]()

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

    // MARK: - Public Properties

    /// Background color for the whole view. Available when session configuration is available.
    var backgroundColor: UIColor? {
        return UIColor(hexString: sessionConfiguration.backgroundColor)
    }

    /// The svg image name to show.
    var svgImageName: String {
        return iconDictionary[sessionConfiguration.iconName] ?? "square"
    }

    /// Number of Trials.
    var numberOfTrials: Int {
        return sessionConfiguration.numberOfTrials
    }

    /// Time between user answer and show new trial
    var interTrialInterval: Int {
        return sessionConfiguration.interTrialInterval
    }

    /// Time for show sample
    var sampleExposureDuration: Int {
        return sessionConfiguration.sampleExposureDuration
    }

    /// Time of showing all elements and test element
    var delayPeriod: Int {
        return sessionConfiguration.delayPeriod
    }

    // MARK: - Handlers

    var didFetchSessionConfiguration: (() -> Void)?

    // MARK: - Public Methods

    /// Write round info in GameResult struct
    func setRoundInfo() {
        gameResult.setGameRoundLocationsInfo(locationInfo: cells.map { $0.location })
        gameResult.setGameRoundColorsInfo(colorsInfo: cells.map { $0.color })
    }

    func fetchSessionConfigurations(completion: @escaping ((Result<Void, Error>) -> Void)) {
        FirebaseManager.sharedInstance.fetchSessionConfigurations(withSessionId: userSession.user.projectId) { [weak self] result in
            switch result {
            case let .failure(error):
                completion(.failure(error))

            case let .success(sessionConfiguration):
                guard let self = self else { return }

                self.sessionConfiguration = sessionConfiguration
                self.didFetchSessionConfiguration?()
                completion(.success(()))
                self.generateChangeProbability()
            }
        }
    }

    /// Generates new cells to show on a screen. See `cells`.
    func generateCells(viewBounds: CGRect) {
        let config = sessionConfiguration
        cells = []
        for index in 0 ..< config.setSize {
            let cell = Cell(frame: generateRect(viewBounds: viewBounds, config: config, occupiedRects: cells.map { $0.frame }),
                            color: chooseColor(index, config: config))
            cells.append(cell)
        }

        let change = changeProbabilityArray[currentRound] == 1 ? true : false
        currentRound += 1
        generateTestCell(viewBounds: viewBounds, change: change)
    }

    // MARK: - Private Methods

    // change = is Correct or not
    private func generateTestCell(viewBounds: CGRect, change: Bool) {
        if change {
            let randomNumber = Int.random(in: 0 ... cells.count)
            let cell = cells[randomNumber]
            testCell = cell
        } else {
            let config = sessionConfiguration
            let randomNumberForColor = Int.random(in: 0 ... config.colors.count)
            let cell = Cell(frame: generateRect(viewBounds: viewBounds, config: config, occupiedRects: cells.map { $0.frame }),
                            color: chooseColor(randomNumberForColor, config: config))
            testCell = cell
        }
    }

    private func generateRect(viewBounds: CGRect, config: SessionConfiguration, occupiedRects: [CGRect]) -> CGRect {
        while true {
            let xCoordinate = Int.random(in: Int(viewBounds.origin.x) ..< Int(viewBounds.width - config.stimuliSize))
            let yCoordinate = Int.random(in: Int(viewBounds.origin.y) ..< Int(viewBounds.height - config.stimuliSize))
            let rect = CGRect(x: CGFloat(xCoordinate), y: CGFloat(yCoordinate),
                              width: CGFloat(config.stimuliSize), height: CGFloat(config.stimuliSize))
            if !rect.intersectsAny(occupiedRects) {
                return rect
            }
        }
    }

    private func chooseColor(_ index: Int, config: SessionConfiguration) -> String {
        var newIndex = index
        if newIndex >= config.colors.count {
            newIndex = index % config.colors.count
        } else {
            newIndex = index
        }
        let color = config.colors[newIndex]
        return color
    }

    private func generateChangeProbability() {
        changeProbabilityArray.removeAll()
        for _ in 0 ... sessionConfiguration.numberOfTrials {
            let chance = 100 * sessionConfiguration.changeProbability
            let generatedValue = Float.random(in: 0 ... 99)

            if generatedValue > chance {
                changeProbabilityArray.append(0)
            } else {
                changeProbabilityArray.append(1)
            }
        }
    }
}

private extension CGRect {
    /// Returns true if intersects at least one rect.
    func intersectsAny(_ rects: [CGRect]) -> Bool {
        for rect in rects {
            if intersects(rect) {
                return true
            }
        }
        return false
    }
}

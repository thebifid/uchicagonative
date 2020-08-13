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

    init(userSession: UserSession) {
        self.userSession = userSession
    }

    // MARK: - Private Properties

    private let userSession: UserSession
    private var sessionConfiguration: SessionConfiguration?
    private(set) var cells = [Cell]()

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

    /// Background color for the whole view. Available when session configuration is available.
    var backgroundColor: UIColor? {
        return sessionConfiguration.map { UIColor(hexString: $0.backgroundColor) }
    }

    /// The svg image name to show.
    var svgImageName: String {
        return sessionConfiguration.flatMap { iconDictionary[$0.iconName] } ?? "square"
    }

    // MARK: - Handlers

    var didFetchSession: (() -> Void)?

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
                self.didFetchSession?()
                completion(.success(()))
            }
        }
    }

    /// Generates new cells to show on a screen. See `cells`.
    func generateCells(viewBounds: CGRect) {
        guard let config = sessionConfiguration else { return }
        cells = []
        for index in 0 ..< config.setSize {
            let cell = Cell(frame: generateRect(viewBounds: viewBounds, config: config, occupiedRects: cells.map { $0.frame }),
                            color: chooseColor(index, config: config))
            cells.append(cell)
        }
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

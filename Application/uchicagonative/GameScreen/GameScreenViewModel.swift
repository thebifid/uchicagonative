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

    init(userSession: UserSession, sessionConfiguration: SessionConfiguration) {
        self.userSession = userSession
        self.sessionConfiguration = sessionConfiguration
    }

    // MARK: - Private Properties

    private let userSession: UserSession
    private var sessionConfiguration: SessionConfiguration
    private(set) var cells = [Cell]()
    private(set) var testCell = Cell(frame: .zero, color: "#ffff", iconName: "square", stimuliSize: 0)

    private var currentRound = 0 // Переключения пока нет

    private var testPresentationTime = ""
    private var responseStartTime = ""
    private var responseEndTime = ""
    private var gestureDirection = ""

    private var changeProbabilityArray = [Int]()

    private var trials = Trials()
    private var sample = Sample()
    private var test = Test()
    private(set) var roundResult = RoundResult()

    /// Map icon name from server to icon name in app
    private let iconDictionary = [
        "the-punisher-seeklogo.com": "punisher",
        "github-logo": "githublogo",
        "square": "square",
        "wrestling": "wrestling",
        "diaspora": "diaspora"
    ]

    private var startPoint: CGPoint = .zero
    private var endPoint: CGPoint = .zero

    private var gestureDuration: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let responseEndTime = dateFormatter.date(from: self.responseEndTime) ?? Date()
        let testPresentationTime = dateFormatter.date(from: self.testPresentationTime) ?? Date()

        let responseEndTimeMiliseconds = convertDateToMiliseconds(date: responseEndTime)
        let testPresentationTimeMiliseconds = convertDateToMiliseconds(date: testPresentationTime)

        return responseEndTimeMiliseconds - testPresentationTimeMiliseconds
    }

    private var reactionTime: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let responseStartTime = dateFormatter.date(from: self.responseStartTime) ?? Date()
        let testPresentationTime = dateFormatter.date(from: self.testPresentationTime) ?? Date()

        let responseStartTimeMiliseconds = convertDateToMiliseconds(date: responseStartTime)
        let testPresentationTimeMiliseconds = convertDateToMiliseconds(date: testPresentationTime)

        return responseStartTimeMiliseconds - testPresentationTimeMiliseconds
    }

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

    var swipeDistanceX: CGFloat {
        return abs(startPoint.x - endPoint.x)
    }

    var swipeDistanceY: CGFloat {
        return abs(startPoint.y - endPoint.y)
    }

    var shouldMatch: Bool {
        return changeProbabilityArray[currentRound] == 1 ? true : false
    }

    // MARK: - Handlers

    var didFetchSessionConfiguration: (() -> Void)?
    var didRoundEnd: (() -> Void)?
    var showNotificationToUser: (() -> Void)?
    var didGameEnd: (() -> Void)?

    // MARK: - Public Methods

    func roundEnded() {
        setRoundInfo()
        showNotification()
        currentRound += 1
        nextRound()
    }

    /// Write round info in GameResult class
    private func setRoundInfo() {
        let locationInfo = cells.map { $0.location }
        roundResult.setGameRoundCellsLocationInfo(locationInfo: fromTwoDimensionalArrayToString(array: locationInfo))
        let colorsInfo = cells.map { $0.color }
        roundResult.setGameRoundCellsColorInfo(colorsInfo: fromOneDimensionalArrayToString(array: colorsInfo))
        roundResult.setGameRoundTestCellLocationInfo(locationInfo: fromOneDimensionalArrayToString(array: testCell.location,
                                                                                                   withSeparator: ":"))
        roundResult.setGameRoundTestCellColorInfo(colorInfo: testCell.color)

        roundResult.setTestPresentationTime(testPresentationTime: testPresentationTime)
        roundResult.setResponseStartTime(responseStartTime: responseStartTime)
        roundResult.setResponseEndTime(responseEndTime: responseEndTime)
        roundResult.setGestureDuration(gestureDuration: gestureDuration)
        roundResult.setReactionTime(reactionTime: reactionTime)

        roundResult.setSwipeDistanceX(distanceX: Float(swipeDistanceX))
        roundResult.setSwipeDistanceY(distanceY: Float(swipeDistanceY))

        roundResult.setGestureDirection(direction: gestureDirection)
        roundResult.setShouldMatch(shouldMatch: shouldMatch)

        trials.addResult(result: roundResult)
        trials.addSample(sample: Sample(cells: cells))
        trials.addTest(test: Test(cell: testCell))
    }

    func startGame() {
        nextRound()
        print(changeProbabilityArray)
    }

    private func nextRound() {
        if currentRound < numberOfTrials {
            didRoundEnd?()
        } else {
            didGameEnd?()
        }
    }

    private func showNotification() {
        showNotificationToUser?()
    }

    /// Set start point of user swipe
    func setStartPoint(startPoint: CGPoint) {
        self.startPoint = startPoint
    }

    /// Set end point of user swipe
    func setEndPoint(endPoint: CGPoint) {
        self.endPoint = endPoint
    }

    func setTestPresentationTime() {
        testPresentationTime = currentStringDate()
    }

    func setResponseStartTime() {
        responseStartTime = currentStringDate()
    }

    func setResponseEndTime() {
        responseEndTime = currentStringDate()
    }

    func setGestureDirection(direction: String) {
        gestureDirection = direction
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
                            color: chooseColor(index, config: config), iconName: config.iconName, stimuliSize: Int(config.stimuliSize))
            cells.append(cell)
        }

        let change = changeProbabilityArray[currentRound] == 1 ? true : false
        generateTestCell(viewBounds: viewBounds, change: change)
    }

    // MARK: - Private Methods

    // change = is Correct or not
    private func generateTestCell(viewBounds: CGRect, change: Bool) {
        if change {
            let randomNumber = Int.random(in: 0 ... cells.count - 1)
            let cell = cells[randomNumber]
            testCell = cell
        } else {
            let config = sessionConfiguration
            let randomNumberForColor = Int.random(in: 0 ... config.colors.count)
            let cell = Cell(frame: generateRect(viewBounds: viewBounds, config: config, occupiedRects: cells.map { $0.frame }),
                            color: chooseColor(randomNumberForColor, config: config),
                            iconName: config.iconName, stimuliSize: Int(config.stimuliSize))
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
        for _ in 0 ..< sessionConfiguration.numberOfTrials {
            let chance = 100 * sessionConfiguration.changeProbability
            let generatedValue = Float.random(in: 0 ... 99)

            if generatedValue > chance {
                changeProbabilityArray.append(0)
            } else {
                changeProbabilityArray.append(1)
            }
        }
    }

    private func currentStringDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let date = Date()
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }

    private func convertDateToMiliseconds(date: Date) -> Int {
        let since1970 = date.timeIntervalSince1970
        return Int(since1970 * 1000)
    }

    private func fromTwoDimensionalArrayToString<T: LosslessStringConvertible>(array: [[T]]) -> String {
        var stringFromArray: String = ""

        array.forEach { OneDimensionalArray in
            stringFromArray.append(contentsOf: fromOneDimensionalArrayToString(array: OneDimensionalArray, withSeparator: ":"))
            stringFromArray.append(contentsOf: ";")
        }

        stringFromArray.insert("[", at: stringFromArray.startIndex)
        stringFromArray.removeLast()
        stringFromArray.insert("]", at: stringFromArray.endIndex)

        return stringFromArray
    }

    private func fromOneDimensionalArrayToString<T: LosslessStringConvertible>(array: [T], withSeparator: String = ";") -> String {
        var stringFromArray: String = ""
        let separator = withSeparator

        array.forEach {
            stringFromArray.append(contentsOf: String($0))
            stringFromArray.append(contentsOf: separator)
        }

        stringFromArray.insert("[", at: stringFromArray.startIndex)
        stringFromArray.removeLast()
        stringFromArray.insert("]", at: stringFromArray.endIndex)

        return stringFromArray
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

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

    // MARK: - Enums

    enum SwipeDirection: String {
        case left, right, none
    }

    // MARK: - Private Properties

    private let userSession: UserSession
    private var sessionConfiguration: SessionConfiguration

    /// Sample cells.
    private(set) var cells = [Cell]()
    private(set) var testCell = Cell(frame: .zero, color: "#ffff", iconName: "square", stimuliSize: 0)
    private var currentRound = 0
    private var testPresentationTime = ""
    private var responseStartTime = ""
    private var responseEndTime = ""
    private var gestureDirection: GameScreenViewModel.SwipeDirection = .none
    private var startedAt = ""
    private var changeProbabilityArray = [Int]()
    private var trials = Trials()
    private(set) var roundResult = RoundResult()

    private var attributes = [String: Any]()

    /// Map icon name from server to icon name in app.
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

    /// Time between user answer and show new trial.
    var interTrialInterval: Int {
        return sessionConfiguration.interTrialInterval
    }

    /// Time for show sample.
    var sampleExposureDuration: Int {
        return sessionConfiguration.sampleExposureDuration
    }

    /// Time of showing all elements and test element.
    var delayPeriod: Int {
        return sessionConfiguration.delayPeriod
    }

    var swipeDistanceX: CGFloat {
        return endPoint.x - abs(startPoint.x)
    }

    var swipeDistanceY: CGFloat {
        return startPoint.y - abs(endPoint.y)
    }

    var shouldMatch: Bool {
        return changeProbabilityArray[currentRound] == 1 ? true : false
    }

    var feedbackTone: SessionConfiguration.FeedbackType {
        return sessionConfiguration.feedbackTone
    }

    var feedbackVibration: SessionConfiguration.FeedbackType {
        return sessionConfiguration.feedbackVibration
    }

    // MARK: - Handlers

    var didFetchSessionConfiguration: (() -> Void)?
    var didRoundEnd: (() -> Void)?
    var showNotificationToUser: (() -> Void)?
    var didGameEnd: (() -> Void)?

    // MARK: - Public Methods

    func startGame() {
        nextRound()
    }

    func roundEnded() {
        setRoundInfo()
        showNotification()
        currentRound += 1
        nextRound()
    }

    /// Set start point of user swipe.
    func setStartPoint(startPoint: CGPoint) {
        self.startPoint = startPoint
    }

    /// Set end point of user swipe.
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

    func setGestureDirection(direction: GameScreenViewModel.SwipeDirection) {
        gestureDirection = direction
    }

    func setStartedAt() {
        startedAt = currentStringDate()
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
                print(sessionConfiguration.feedbackVibration)
                completion(.success(()))
                self.generateChangeProbability()
            }
        }
    }

    func sendDataToFirebase(completion: @escaping ((Result<Void, Error>) -> Void)) {
        formData()

        if !FirebaseManager.sharedInstance.isConnected {
            let message = "The connection is lost. Your data will be recorded automatically the next time you connect to the Internet."
            let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
            completion(.failure(error))
        }

        FirebaseManager.sharedInstance.addDocumentToBlocks(attributes: attributes) { result in

            switch result {
            case let .failure(error):
                completion(.failure(error))
            case .success:
                completion(.success(()))
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

    private func formData() {
        attributes["config"] = formConfig()
        attributes["createdAt"] = convertDateToMiliseconds(date: Date())
        attributes["endedAt"] = currentStringDate()
        attributes["startedAt"] = trials.results[0].startedAt
        attributes["trials"] = formTrials()
        attributes["updatedAt"] = convertDateToMiliseconds(date: Date())
        attributes["user"] = formUser()
    }

    private func formConfig() -> [String: Any] {
        let config: [String: Any] = [
            "active": sessionConfiguration.active,
            "backgroundColor": sessionConfiguration.backgroundColor,
            "changeProbability": sessionConfiguration.changeProbability,
            "colorPaletteId": sessionConfiguration.colorPaletteId,
            "colorPaletteName": sessionConfiguration.colorPaletteName,
            "colors": sessionConfiguration.colors,
            "delayPeriod": sessionConfiguration.delayPeriod,
            "feedbackDuration": sessionConfiguration.feedbackDuration,
            "feedbackTone": sessionConfiguration.feedbackTone.rawValue,
            "feedbackVibration": sessionConfiguration.feedbackVibration.rawValue,
            "iconName": sessionConfiguration.iconName,
            "id": userSession.user.projectId,
            "interTrialInterval": sessionConfiguration.interTrialInterval,
            "name": sessionConfiguration.name,
            "numberOfTrials": sessionConfiguration.numberOfTrials,
            "sampleExposureDuration": sessionConfiguration.sampleExposureDuration,
            "setSize": sessionConfiguration.setSize,
            "stimuliSize": sessionConfiguration.stimuliSize
        ]
        return config
    }

    private func formTrials() -> [[String: Any]] {
        var arrayOfTrials = [[String: Any]]()
        for index in 0 ..< sessionConfiguration.numberOfTrials {
            var trialToSend = [String: Any]()
            trialToSend["id"] = trials.id

            let result = formResult(index: index)
            let sample = formSample(index: index)
            let test = formTest(index: index)

            trialToSend["results"] = result
            trialToSend["sample"] = sample
            trialToSend["test"] = test

            arrayOfTrials.append(trialToSend)
        }
        return arrayOfTrials
    }

    private func formResult(index: Int) -> [String: Any] {
        let currentTrial = trials.results[index]
        var result = [String: Any]()
        result["accuracy"] = currentTrial.accuracy
        result["change"] = currentTrial.change
        result["colors"] = currentTrial.colors
        result["gestureDirection"] = currentTrial.gestureDirection.rawValue
        result["gestureDuration"] = currentTrial.gestureDuration
        result["locations"] = currentTrial.locations
        result["reactionTime"] = currentTrial.reactionTime
        result["responseEndTime"] = currentTrial.responseEndTime
        result["responseStartTime"] = currentTrial.responseStartTime
        result["shouldMatch"] = currentTrial.shouldMatch
        result["startedAt"] = currentTrial.startedAt
        result["swipeDistanceX"] = currentTrial.swipeDistanceX
        result["swipeDistanceY"] = currentTrial.swipeDistanceY
        result["testColor"] = currentTrial.testColor
        result["testLocation"] = currentTrial.testLocation
        result["testPresentationTime"] = currentTrial.testPresentationTime

        return result
    }

    private func formSample(index: Int) -> [String: Any] {
        var cells = [[String: Any]]()
        trials.sample[index].cells.forEach { cell in
            let cellToSend = formCell(cell: cell)
            cells.append(cellToSend)
        }
        let sample: [String: Any] = ["cells": cells]

        return sample
    }

    private func formTest(index: Int) -> [String: Any] {
        var cells = [[String: Any]]()

        let testCell = trials.test[index].cell
        var cellToSend = [String: Any]()
        cellToSend = formCell(cell: testCell)
        cells.append(cellToSend)
        let test: [String: Any] = ["cells": cells]

        return test
    }

    private func formCell(cell: Cell) -> [String: Any] {
        var cellToSend = [String: Any]()
        cellToSend["color"] = cell.color
        cellToSend["iconName"] = cell.iconName
        cellToSend["id"] = cell.id
        cellToSend["stimuliSize"] = cell.stimuliSize
        cellToSend["x"] = cell.location[0]
        cellToSend["y"] = cell.location[1]

        return cellToSend
    }

    private func formUser() -> [String: Any] {
        var user = [String: Any]()

        user["birthYear"] = userSession.user.birthYear
        user["gender"] = userSession.user.gender
        user["id"] = userSession.user.id
        user["projectId"] = userSession.user.projectId
        user["zipCode"] = userSession.user.zipCode

        return user
    }

    /// Write round info in GameResult class
    private func setRoundInfo() {
        let locationInfo = cells.map { $0.location }
        roundResult.locations = fromTwoDimensionalArrayToString(array: locationInfo)
        let colorsInfo = cells.map { $0.color }
        roundResult.colors = fromOneDimensionalArrayToString(array: colorsInfo)
        roundResult.testLocation = fromOneDimensionalArrayToString(array: testCell.location, withSeparator: ":")
        roundResult.testColor = testCell.color
        roundResult.testPresentationTime = testPresentationTime
        roundResult.responseStartTime = responseStartTime
        roundResult.responseEndTime = responseEndTime
        roundResult.gestureDuration = gestureDuration
        roundResult.reactionTime = reactionTime
        roundResult.swipeDistanceX = Float(swipeDistanceX)
        roundResult.swipeDistanceY = Float(swipeDistanceY)
        roundResult.gestureDirection = gestureDirection
        roundResult.shouldMatch = shouldMatch
        roundResult.startedAt = startedAt
        trials.results.append(roundResult)
        trials.sample.append(Sample(cells: cells))
        trials.test.append(Test(cell: testCell))
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

    // change = is Correct or not test cell
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

    private func fromOneDimensionalArrayToString<T: LosslessStringConvertible>(array: [T],
                                                                               withSeparator separator: String = ";") -> String {
        var stringFromArray: String = ""
        let separator = separator

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

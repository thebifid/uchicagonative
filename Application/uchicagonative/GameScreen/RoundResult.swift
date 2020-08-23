//
//  GameResult.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 12.08.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Foundation

struct RoundResult {
    var accuracy: Int {
        if shouldMatch, gestureDirection == .right {
            return 1
        } else if !shouldMatch, gestureDirection == .left {
            return 1
        } else {
            return 0
        }
    }

    private(set) var gestureDirection: GameScreenViewModel.SwipeDirection = .none
    private(set) var reactionTime: Int = 0
    private(set) var responseEndTime: String = ""
    private(set) var responseStartTime: String = ""
    private(set) var shouldMatch: Bool = false
    private(set) var startedAt: String = "" // ??
    private(set) var swipeDistanceX: Float = 0
    private(set) var swipeDistanceY: Float = 0
    private(set) var testPresentationTime: String = ""
    private(set) var gestureDuration: Int = 0

    private(set) var locations: String = ""
    private(set) var colors: String = ""

    private(set) var testLocation: String = ""
    private(set) var testColor: String = ""

    mutating func setGameRoundCellsLocationInfo(locationInfo location: String) {
        locations = location
    }

    mutating func setGameRoundCellsColorInfo(colorsInfo color: String) {
        colors = color
    }

    mutating func setGameRoundTestCellLocationInfo(locationInfo location: String) {
        testLocation = location
    }

    mutating func setGameRoundTestCellColorInfo(colorInfo color: String) {
        testColor = color
    }

    mutating func setTestPresentationTime(testPresentationTime: String) {
        self.testPresentationTime = testPresentationTime
    }

    mutating func setResponseStartTime(responseStartTime: String) {
        self.responseStartTime = responseStartTime
    }

    mutating func setResponseEndTime(responseEndTime: String) {
        self.responseEndTime.append(responseEndTime)
    }

    mutating func setGestureDuration(gestureDuration: Int) {
        self.gestureDuration = gestureDuration
    }

    mutating func setReactionTime(reactionTime: Int) {
        self.reactionTime = reactionTime
    }

    mutating func setSwipeDistanceX(distanceX: Float) {
        swipeDistanceX = distanceX
    }

    mutating func setSwipeDistanceY(distanceY: Float) {
        swipeDistanceY = distanceY
    }

    mutating func setGestureDirection(direction: GameScreenViewModel.SwipeDirection) {
        gestureDirection = direction
    }

    mutating func setShouldMatch(shouldMatch: Bool) {
        self.shouldMatch = shouldMatch
    }

    mutating func setStartedAt(startedAt: String) {
        self.startedAt = startedAt
    }
}

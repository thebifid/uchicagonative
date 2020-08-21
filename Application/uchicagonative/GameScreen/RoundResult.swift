//
//  GameResult.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 12.08.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Foundation

struct RoundResult {
    private var accuracy: Int = 0 //
    private var gestureDirection: String = ""
    private var reactionTime: Int = 0
    private var responseEndTime: String = ""
    private var responseStartTime: String = ""
    private var shouldMatch: Bool = false //
    private var startedAt: String = "" // ??
    private var swipeDistanceX: Float = 0
    private var swipeDistanceY: Float = 0
    private var testPresentationTime: String = ""
    private var gestureDuration: Int = 0

    private var locations = [[Int]]()
    private var colors = [String]()

    private var testLocation = [Int]()
    private var testColor: String = ""

    mutating func setGameRoundCellsLocationInfo(locationInfo location: [[Int]]) {
        locations = location
    }

    mutating func setGameRoundCellsColorInfo(colorsInfo color: [String]) {
        colors = color
    }

    mutating func setGameRoundTestCellLocationInfo(locationInfo location: [Int]) {
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

    mutating func setGestureDirection(direction: String) {
        gestureDirection = direction
    }

    mutating func setShouldMatch(shouldMatch: Bool) {
        self.shouldMatch = shouldMatch
    }
}

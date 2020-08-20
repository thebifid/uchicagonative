//
//  GameResult.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 12.08.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Foundation

struct GameResult {
    private var cellsLocationsInfo = [[[Int]]]()
    private var cellsColorsInfo = [[String]]()

    private var testCellLocationsInfo = [[Int]]()
    private var testCellColorsInfo = [String]()

    private var testPresentationTime = [String]()
    private var responseStartTime = [String]()
    private var responseEndTime = [String]()
    private var gestureDuration = [Int]()
    private var reactionTime = [Int]()

    private var swipeDistanceX: Float = 0
    private var swipeDistanceY: Float = 0

    mutating func setGameRoundCellsLocationInfo(locationInfo location: [[Int]]) {
        cellsLocationsInfo.append(location)
    }

    mutating func setGameRoundCellsColorInfo(colorsInfo color: [String]) {
        cellsColorsInfo.append(color)
    }

    mutating func setGameRoundTestCellLocationInfo(locationInfo location: [Int]) {
        testCellLocationsInfo.append(location)
    }

    mutating func setGameRoundTestCellColorInfo(colorInfo color: String) {
        testCellColorsInfo.append(color)
    }

    mutating func setTestPresentationTime(testPresentationTime: String) {
        self.testPresentationTime.append(testPresentationTime)
    }

    mutating func setResponseStartTime(responseStartTime: String) {
        self.responseStartTime.append(responseStartTime)
    }

    mutating func setResponseEndTime(responseEndTime: String) {
        self.responseEndTime.append(responseEndTime)
    }

    mutating func setGestureDuration(gestureDuration: Int) {
        self.gestureDuration.append(gestureDuration)
    }

    mutating func setReactionTime(reactionTime: Int) {
        self.reactionTime.append(reactionTime)
    }

    mutating func setSwipeDistanceX(distanceX: Float) {
        swipeDistanceX = distanceX
    }

    mutating func setSwipeDistanceY(distanceY: Float) {
        swipeDistanceY = distanceY
    }
}

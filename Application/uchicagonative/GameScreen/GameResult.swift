//
//  GameResult.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 12.08.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Foundation

struct GameResult {
    private(set) var cellsLocationsInfo = [[[Int]]]()
    private(set) var cellsColorsInfo = [[String]]()

    private(set) var testPresentationTime = [String]()
    private(set) var responseStartTime = [String]()
    private(set) var responseEndTime = [String]()

    mutating func setGameRoundLocationsInfo(locationInfo location: [[Int]]) {
        cellsLocationsInfo.append(location)
    }

    mutating func setGameRoundColorsInfo(colorsInfo color: [String]) {
        cellsColorsInfo.append(color)
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
}

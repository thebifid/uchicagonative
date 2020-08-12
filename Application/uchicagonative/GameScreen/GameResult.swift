//
//  GameResult.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 12.08.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import Foundation

struct GameResult {
    private(set) var gameLocationsInfo = [[[Int]]]()
    private(set) var gameColorsInfo = [[String]]()

    mutating func setGameRoundLocationsInfo(locationInfo location: [[Int]]) {
        gameLocationsInfo.append(location)
    }

    mutating func setGameRoundColorsInfo(colorsInfo color: [String]) {
        gameColorsInfo.append(color)
    }
}

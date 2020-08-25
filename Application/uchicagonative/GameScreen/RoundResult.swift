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

    var change: Int {
        return shouldMatch == true ? 0 : 1
    }

    var gestureDirection: GameScreenViewModel.SwipeDirection = .none
    var reactionTime: Int = 0
    var responseEndTime: String = ""
    var responseStartTime: String = ""
    var shouldMatch: Bool = false
    var startedAt: String = "" // ??
    var swipeDistanceX: Float = 0
    var swipeDistanceY: Float = 0
    var testPresentationTime: String = ""
    var gestureDuration: Int = 0
    var locations: String = ""
    var colors: String = ""
    var testLocation: String = ""
    var testColor: String = ""
}

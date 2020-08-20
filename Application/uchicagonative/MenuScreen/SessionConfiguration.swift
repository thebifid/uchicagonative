//
//  SessionConfiguration.swift
//  uchicagonative
//
//  Created by Vasiliy Matveev on 11.08.2020.
//  Copyright © 2020 Vasiliy Matveev. All rights reserved.
//

import UIKit

struct SessionConfiguration {
    let active: String
    let backgroundColor: String
    let changeProbability: Float
    let colorPaletteId: String
    let colorPaletteName: String
    let colors: [String]
    let createdAt: Any
    let delayPeriod: Int
    let feedbackDuration: Int
    let feedbackTone: String
    let feedbackVibration: String
    let iconName: String
    let interTrialInterval: Int
    let name: String
    let numberOfTrials: Int
    let sampleExposureDuration: Int
    let setSize: Int
    let stimuliSize: CGFloat
    let updatedAt: Any

    init() {
        active = ""
        backgroundColor = ""
        changeProbability = 0
        colorPaletteId = ""
        colorPaletteName = ""
        colors = []
        createdAt = ""
        delayPeriod = 0
        feedbackDuration = 0
        feedbackTone = ""
        feedbackVibration = ""
        iconName = ""
        interTrialInterval = 0
        name = ""
        numberOfTrials = 0
        sampleExposureDuration = 0
        setSize = 0
        stimuliSize = 0
        updatedAt = ""
    }

    init?(rawDict: [String: Any]) {
        active = rawDict["active"] as? String ?? ""
        backgroundColor = rawDict["backgroundColor"] as? String ?? ""
//        changeProbability = rawDict["changeProbability"] as? Float ?? 0
        let change = rawDict["changeProbability"] as? Double ?? 0
        changeProbability = Float(change)
        colorPaletteId = rawDict["colorPaletteId"] as? String ?? ""
        colorPaletteName = rawDict["colorPaletteName"] as? String ?? ""
        colors = rawDict["colors"] as? [String] ?? []
        createdAt = rawDict["createdAt"] ?? ""
        delayPeriod = rawDict["delayPeriod"] as? Int ?? 0
        feedbackDuration = rawDict["feedbackDuration"] as? Int ?? 0
        feedbackTone = rawDict["feedbackTone"] as? String ?? ""
        feedbackVibration = rawDict["feedbackVibration"] as? String ?? ""
        iconName = rawDict["iconName"] as? String ?? ""
        interTrialInterval = rawDict["interTrialInterval"] as? Int ?? 0
        name = rawDict["name"] as? String ?? ""
        numberOfTrials = rawDict["numberOfTrials"] as? Int ?? 0
        sampleExposureDuration = rawDict["sampleExposureDuration"] as? Int ?? 0
        setSize = rawDict["setSize"] as? Int ?? 0
        stimuliSize = rawDict["stimuliSize"] as? CGFloat ?? 0
        updatedAt = rawDict["updatedAt"] ?? ""
    }
}
